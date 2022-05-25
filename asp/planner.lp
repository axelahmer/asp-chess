row(1..n).
col(1..n).
color(white).
color(black).
enemy(white,black).
enemy(black,white).
time(1..k).
color_to_move(1, white).
% there must be no check at time 1 for black
:- check(white,1).
:- check(black,1).
% :- check(black,2).
color_to_move(T, white) :- color_to_move(T-1, black), time(T).
color_to_move(T, black) :- color_to_move(T-1, white), time(T).

% it cannot be the case that after a move that color is in check
% color_to_move(Color, T), it cannot be the case that enemy(Color, EnemyColor) check(EnemyColor, T)
:- time(T), color_to_move(T,white), check(white, T+1).

% new definition of checkmate:
checkmate(T) :-
    color_to_move(T,C),
    time(T),
    {possibleMove(_,_,_,_,T)}=0,
    check(C,T).

stalemate(T) :-
    color_to_move(T,C),
    time(T),
    {possibleMove(_,_,_,_,T)}=0,
    not check(C,T).

% possible_moves_at_time(T,N) :-
%     color_to_move(T,C),
%     time(T),
%     {possibleMove(_,_,_,_,T)}=N.
%     % check(C,T).

check(C,T) :-
    enemy(C,EC),
    guarded(Row, Col, _, _, EC, T),
    chessman(king, C, Row, Col, T).

% minimize the number of moves until checkmate
#minimize{N@10:checkmate(N)}.

% we prefer a small amount of possible white moves.
:~ {possibleMove(_,_,_,_,T): color_to_move(T,white), time(T)}=N. [N@1]

% blacks possible moves = 1 at every time
:- not {possibleMove(_,_,_,_,T) : color_to_move(T,black), time(T)}=1.

% there must be a checkmate
:- not {checkmate(N) : color_to_move(N,black), time(N)}=1. 

% the checkmate must not be on white
% :- checkmate(N), color_to_move(N,white).

% create a chessman at t+1 that moved!
chessman(Piece, Color, NewRow, NewCol, T+1) :-
    move(Row, Col, NewRow, NewCol, T),
    color(Color),
    chessman(Piece, Color, Row, Col, T),
    color_to_move(T, Color).

% add to the set of chessmen at t+1 all the men who have not moved.
chessman(Piece, Color, Row, Col, T+1) :-
    move(Row', Col', NewRow, NewCol, T),
    (Row, Col) != (Row', Col'), % the chessman cannot be the one who moved
    (Row, Col) != (NewRow, NewCol), % the chessman cannot be the one being taken
    row(NewRow), col(NewCol), row(Row'), col(Col'),
    time(T), % TODO gotcha: a piece may have been taken.
    chessman(Piece, Color, Row, Col, T),
    color(Color).

{ move(Row, Col, NewRow, NewCol, T) :
    possibleMove(Row,Col,NewRow,NewCol,T),
    row(Row),col(Col),row(NewRow), col(NewCol)
    }=1 :- time(T), T<N : checkmate(N).

% { move(Row, Col, NewRow, NewCol, T) :
%     guarded(NewRow, NewCol, Row, Col, Color, T),
%     row(Row),col(Col),row(NewRow), col(NewCol),
%     % cannot take friendly piece down
%     not chessman(_, white, NewRow, NewCol, T),
%     chessman(_, white, Row, Col, T)
%     }=1 :- color_to_move(T,white), time(T), T<N : checkmate(N).



% it cannot be the case that there is more than 1 chessman on a square
:- chessman(P,Color,R,C,T), chessman(P',Color',R',C',T), (P,Color)!=(P',Color'), (R,C)==(R',C'), time(T).

% a piece at R,C is pinned if it is under linearAttack from the king and the enemy piece at once
pinned(R, C, R0, C0, Dir, T) :- 
    oppDir(Dir, Dir2),
    linearAttack(R,C, ECol, Dir, R0, C0,T),
    linearAttack(R,C, Col, Dir2, RK, CK,T),
    chessman(_, Col, R,C,T),
    not chessman(king,ECol,R0,C0,T),
    chessman(king, Col, RK, CK, T),
    (R,C) != (RK,CK),
    enemy(Col, ECol).

% block squares only used when in check
blockSquare(R,C,T) :-
    color_to_move(T,Col),
    chessman(king,Col,RK,CK,T),
    guarded(RK,CK,R0,C0,ECOl,T),
    enemy(Col,ECol),
    linearAttack(RK,CK,_,Dir,R0,C0,T),
    linearAttack(R,C,_,Dir, R0, C0,T),
    (R,C) != (RK,CK).

% R, C = pinned piece pos, R', C' = valid move
pinMoves(R,C, R', C', T) :-
    pinned(R,C,R0,C0,DirA,T),
    color_to_move(T, Col),
    chessman(king,Col,RK,CK,T),
    linearAttack(
        R',C',_,DirK,RK,CK,T ; 
        R',C',_,DirA,R0,C0,T ),
    (R',C') != (RK,CK), % does not include the king's square as a pin move
    oppDir(DirA,DirK).

% _attacking_piece_count(N, T):-
%     #count{(R0, C0) : guarded(RK,CK,R0,C0,ECol,T), chessman(king,Col,RK,CK,T), enemy(Col, ECol),color_to_move(T,Col)}=N,
%     chessman(_,Col,R,C,T),
%     color_to_move(T,Col),
%     guarded(R',C',R,C,Col,T),
%     not chessman(_,Col,R',C',T),
%     row(R'), col(C'),
%     pinMoves(R,C,R',C',T) : pinned(R,C,_,_,_,T).

numChecks(N,T) :-
    #count{(R0, C0) : guarded(RK,CK,R0,C0,ECol,T), chessman(king,Col,RK,CK,T), enemy(Col, ECol), color_to_move(T,Col)}=N,
    time(T).

% possible moves when no check
possibleMove(R,C,R',C',T) :-
    numChecks(0,T),
    chessman(P,Col,R,C,T),
    P != king,
    color_to_move(T,Col),
    guarded(R',C',R,C,Col,T),
    not chessman(_,Col,R',C',T),
    row(R'), col(C'), time(T),
    pinMoves(R,C,R',C',T) : pinned(R,C,_,_,_,T).

% friendly pices taking out or block the sole attacker
possibleMove(R,C,R',C',T) :-
    numChecks(1,T),
    chessman(king,Col,RK,CK,T),
    (RK, CK) != (R,C),
    color_to_move(T,Col),
    guarded(R',C',R,C,Col,T),
    not chessman(_,Col,R',C',T),
    row(R'), col(C'),
    chessman(EPiece,ECol,ER,EC, T),
    guarded(RK,CK,ER,EC,ECol,T),
    enemy(Col,ECol),
    blockSquare(R',C',T) : linPiece(EPiece, _);
    pinMoves(R,C,R',C',T) : pinned(R,C,_,_,_,T),
    time(T).

% king moving out of check / genearlly moving the king
possibleMove(RK,CK,R',C',T) :-
    % the king could always move to a safe spot if allowed
    numChecks(N,T),
    N<=2,
    chessman(king,Col,RK,CK,T),
    color_to_move(T,Col),
    time(T),
    guarded(R',C',RK,CK,Col,T),
    not chessman(_,Col,R',C',T),
    not guarded(R',C',_,_,ECol,T),
    not xray(R',C',ECol,T),
    row(R'), col(C'),
    enemy(Col,ECol).
    
    
% #show linearAttack/7.
#show guarded/6.
% #show pinned/6.
% #show blockSquare/3.
% #show pinMoves/5.
% #show xray/4.
% #show color_to_move/2.
#show chessman/5.
#show checkmate/1.
#show check/2.
#show xray/4.
#show possibleMove/5.
% #show _attacking_piece_count/2.
% #show possible_moves_at_time/2.