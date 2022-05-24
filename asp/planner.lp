row(1..n).
col(1..n).
color(white).
color(black).
enemy(white,black).
enemy(black,white).
time(1..k).
color_to_move(1, black).
% there must be no check at time 1 for black
:- check(white,1).
color_to_move(T, white) :- color_to_move(T-1, black), time(T).
color_to_move(T, black) :- color_to_move(T-1, white), time(T).

% it cannot be the case that after a move that color is in check
% color_to_move(Color, T), it cannot be the case that enemy(Color, EnemyColor) check(EnemyColor, T)
:- time(T), color_to_move(T,Color), check(Color, T+1).

% new definition of checkmate:
checkmate(T) :-
    color_to_move(T,C),
    time(T),
    {possibleMove(_,_,_,_,T)}=0,
    check(C,T).

check(C,T) :-
    enemy(C,EC),
    guarded(Row, Col, _, _, EC, T),
    chessman(king, C, Row, Col, T).

% minimize the number of moves until checkmate
#minimize{N:checkmate(N)}.

% there must be a checkmate
:- not {checkmate(N) : time(N)}=1.

% the checkmate must not be on white
:- checkmate(N), color_to_move(N,white).

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
    color_to_move(T,Color),
    guarded(NewRow, NewCol, Row, Col, Color, T),
    % cannot take friendly piece down
    not chessman(_, Color, NewRow, NewCol, T),
    row(NewRow),
    col(NewCol),
    chessman(_, _, Row, Col, T)}=1 :- time(T), T<N : checkmate(N).

% it cannot be the case that there is more than 1 chessman on a square
:- chessman(P,Color,R,C,T), chessman(P',Color',R',C',T), (P,Color)!=(P',Color'), (R,C)==(R',C').

% a piece at R,C is pinned if it is under linearAttack from the king and the enemy piece at once
pinned(R, C, R0, C0, Dir, T) :- 
    oppDir(Dir, Dir2),
    linearAttack(R,C, ECol, Dir, R0, C0,T),
    linearAttack(R,C, Col, Dir2, RK, CK,T),
    chessman(_, Col, R,C,T),
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

% possible moves when no check
possibleMove(R,C,R',C',T) :-
    #count{(R0, C0) : guarded(RK,CK,R0,C0,ECol,T), chessman(king,Col,RK,CK,T), enemy(Col, ECol)}=0,
    chessman(_,Col,R,C,T),
    color_to_move(T,Col),
    guarded(R',C',R,C,Col,T),
    not chessman(_,Col,R',C',T),
    row(R'), col(C'),
    pinMoves(R,C,R',C',T) : pinned(R,C,_,_,_,T).

% friendly pices taking out or block the sole attacker
possibleMove(R,C,R',C',T) :-
    #count{(R0, C0) : guarded(RK,CK,R0,C0,ECol,T), enemy(Col, ECol)}=1,
    chessman(king,Col,RK,CK,T),
    (RK, CK) != (R,C),
    color_to_move(T,Col),
    guarded(R',C',R,C,Col,T),
    not chessman(_,Col,R',C',T),
    row(R'), col(C'),
    blockSquare(R',C',T),
    pinMoves(R,C,R',C',T) : pinned(R,C,_,_,_,T).

% king moving out of check
possibleMove(RK,CK,R',C',T) :-
    % the king could always move to a safe spot if allowed
    #count{(R0, C0) : guarded(RK,CK,R0,C0,ECol,T), chessman(king,Col,RK,CK,T), enemy(Col, ECol)}=N,
    N<=2,
    chessman(king,Col,RK,CK,T),
    color_to_move(T,Col),
    guarded(R',C',RK,CK,Col,T),
    not guarded(R',C',_,_,ECol,T),
    not xray(R',C',ECol,T),
    row(R'), col(C'),
    enemy(Col,ECol).
    
    
% #show linearAttack/7.
% #show guarded/6.
% #show pinned/6.
% #show blockSquare/3.
% #show pinMoves/5.
% #show xray/4.
% #show color_to_move/2.
#show chessman/5.
#show checkmate/1.
#show possibleMove/5.