row(1..3).
col(1..3).
color(white).
color(black).
enemy(white,black).
enemy(black,white).
time(1..5).

% dir(name, delta_row, delta_col)
dir(
    up,             0   ,    1;
    left,           -1  ,    0;
    right,          1   ,    0;
    up_left,        -1  ,    1;
    up_right,       1   ,    1;
    down_left,      -1  ,   -1;
    down_right,     1   ,   -1;
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

% a square is guarded if there is a linear attack on that square - if the piece is not standing on that square already.
guarded(R,C,R0,C0,Col,T) :- 
    linearAttack(R,C,Col,_,R0,C0,T),
    (R,C) != (R0,C0).

% test case
chessman(rook,white,1,1,1).
chessman(rook,black,1,2,1).

#show guarded/6.