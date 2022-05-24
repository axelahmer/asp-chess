row(1..3).
col(1..6).
color(white).
color(black).
enemy(white,black).
enemy(black,white).
time(1..2).
color_to_move(1, black).
color_to_move(T, white) :- color_to_move(T-1, black), time(T).
color_to_move(T, black) :- color_to_move(T-1, white), time(T).

% dir(name, delta_row, delta_col)
dir(
    up,                1,     0 ;
    down,             -1,     0 ;
    left,              0,     -1;
    right,             0,     1 ;
    up_left,           1,     -1;
    up_right,          1,     1 ;
    down_left,        -1,     -1;
    down_right,       -1,     1 ;
).

oppDir(
    up, down;
    left, right;
    up_left, down_right;
    up_right, down_left;
).

oppDir(X,Y) :- oppDir(Y,X).

% linPiece(pieceName, direction)
linPiece(
    rook,   (up;down;left;right);
    bishop, (up_left;up_right;down_left;down_right);
    queen,  (up;down;left;right;up_left;up_right;down_left;down_right);
    king, (up;down;left;right;up_left;up_right;down_left;down_right) % the king radiates queen's linear attacks for pinned action
).

% a linear piece radiates linear attacks outwards, starting from its current square in every relevant direction.
linearAttack(R,C,Col,Dir,R,C,T) :- 
    linPiece(P,Dir),
    chessman(P,Col,R,C,T).

% a linear attack continues unless it is blocked by a piece!
linearAttack(R',C',Col,Dir,R0,C0,T) :-
    dir(Dir, DeltaR, DeltaC),
    linearAttack(R,C,Col,Dir,R0,C0,T),
    R' = R + DeltaR, row(R'),
    C' = C + DeltaC, col(C'),
    (R,C) == (R0,C0) : chessman(_,_,R,C,T).

% xray attack the square after a king if a linear attack is occuring on a kings square.
xray(R',C',Col,T) :-
    enemy(Col,ECol),
    dir(Dir, DeltaR, DeltaC),
    linearAttack(R,C,Col,Dir,R0,C0,T),
    chessman(king,ECol,R,C,T),
    R' = R + DeltaR, row(R'),
    C' = C + DeltaC, col(C').

% a piece at R,C is pinned by a piece at R0,C0 to the friendly king.
% pin(R,C,R0,C0,T) :-
%     enemy(Col,ECol),
%     chessman(_,Col,R,C,T),
%     linearAttack(R,C,ECol,Dir,R0,C0,T),
%     dir(Dir, DeltaR, DeltaC),
%     {chessman(king,Col,R',C',T) : row(R'), col(C'), R'=R+DeltaR*N , C'=C+DeltaC*N, N=1..8}=1.

% a piece at R,C is pinned if it is under linearAttack from the king and the enemy piece at once
pinned(R, C, R0, C0, Dir, T) :- 
    oppDir(Dir, Dir2),
    linearAttack(R,C, ECol, Dir, R0, C0,T),
    linearAttack(R,C, Col, Dir2, RK, CK,T),
    chessman(_, Col, R,C,T),
    chessman(king, Col, RK, CK, T),
    (R,C) != (RK,CK),
    enemy(Col, ECol).

% a square is guarded if there is a linear attack on that square - if the piece is not standing on that square already.
guarded(R,C,R0,C0,Col,T) :- 
    linearAttack(R,C,Col,_,R0,C0,T),
    (R,C) != (R0,C0),
    not chessman(king,Col,R0,C0,T).

% KINGS
guarded(
    Row+1,  Col,    Row, Col, Color, T;
    Row,    Col+1,  Row, Col, Color, T;
    Row-1,  Col+1,  Row, Col, Color, T;
    Row-1,  Col,    Row, Col, Color, T;
    Row-1,  Col-1,  Row, Col, Color, T;
    Row,    Col-1,  Row, Col, Color, T;
    Row+1,  Col+1,  Row, Col, Color, T;
    Row+1,  Col-1,  Row, Col, Color, T) :-
    chessman(king, Color, Row, Col, T).

% test case
% chessman(rook,white,1,1,1).
chessman(rook,black,1,4,1).
chessman(bishop,white,3,3,1).
% chessman(rook,black,3,1,1).
chessman(king,black,1,5,1).
% chessman(bishop,white,3,3,1).

% #show linearAttack/7.
% #show guarded/6.
% #show pinned/6.
% #show blockSquare/3.
% #show pinMoves/5.
% #show xray/4.
% #show color_to_move/2.
#show possibleMove/5.



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

% intersection 
% #count {blockSquare(R,C,T), pinnedSquare(R,C,T)}

% blockSquare(R,C,T) :-
%     chessman(king,Col,RK,CK,T),
%     linearAttack(RK,CK,ECol,Dir,R0,C0),
%     enemy(Col,ECol).

% blockSquare(R,C,T) :-
%     dir(Dir, DeltaR, DeltaC),
%     linearAttack(R,C,Col,Dir,R0,C0,T),
%     R' = R + DeltaR, row(R'),
%     C' = C + DeltaC, col(C'),
%     (R,C) == (R0,C0) : chessman(_,_,R,C,T).

% which branch we care about 

possibleMove(R,C,R',C',T) :-
    #count{(R0, C0) : guarded(RK,CK,R0,C0,ECol,T), chessman(king,Col,RK,CK,T), enemy(Col, ECol)}=0,
    chessman(_,Col,R,C,T),
    color_to_move(T,Col),
    guarded(R',C',R,C,Col,T),
    not chessman(_,Col,R',C',T),
    pinMoves(R,C,R',C',T) : pinned(R,C,_,_,_,T).

% friendly pices taking out or block the sole attacker
possibleMove(R,C,R',C',T) :-
    #count{(R0, C0) : guarded(RK,CK,R0,C0,ECol,T), enemy(Col, ECol)}=1,
    chessman(king,Col,RK,CK,T),
    (RK, CK) != (R,C),
    color_to_move(T,Col),
    guarded(R',C',R,C,Col,T),
    not chessman(_,Col,R',C',T),
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
    
    
% possibleMove(R,C,R',C',T) :-
%     {guarded(RK,CK,R0,C0,ECol,T) : chessman(king,Col,RK,CK,T)}=2

% {possibleMove(R,C,R',C',T)}=1 :- color_to_move(black, T).

% no check
    % any piece can move to any square it is guarding.

% check with 1 piece
    % take, block, move

    % take and block: if not pinned - you can move to the set of squares = attacker + blockSquares
    %                  if pinned    - you can move to the set of squares = (attacker + blockSquares) /\ pinSquares.

    % move:           king moves to any square which is NOT guarded and NOT an xray
    %       

% check with 2 pieces
    % move only
