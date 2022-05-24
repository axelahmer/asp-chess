row(1..1).
col(1..6).
color(white).
color(black).
enemy(white,black).
enemy(black,white).
time(1..5).

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

% linPiece(pieceName, direction)
linPiece(
    rook,   (up;down;left;right);
    bishop, (up_left;up_right;down_left;down_right);
    queen,  (up;down;left;right;up_left;up_right;down_left;down_right)
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
pin(R,C,R0,C0,T) :-
    enemy(Col,ECol),
    chessman(_,Col,R,C,T),
    linearAttack(R,C,ECol,Dir,R0,C0,T),
    dir(Dir, DeltaR, DeltaC),
    {chessman(king,Col,R',C',T) : row(R'), col(C'), R'=R+DeltaR*N , C'=C+DeltaC*N, N=1..8}=1.

% a square is guarded if there is a linear attack on that square - if the piece is not standing on that square already.
guarded(R,C,R0,C0,Col,T) :- 
    linearAttack(R,C,Col,_,R0,C0,T),
    (R,C) != (R0,C0).

% test case
chessman(rook,white,1,1,1).
chessman(bishop,black,1,3,1).
chessman(king,black,1,5,1).

#show linearAttack/7.
#show guarded/6.
#show xray/4.
#show pin/5.