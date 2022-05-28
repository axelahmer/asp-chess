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
    king,   (up;down;left;right;up_left;up_right;down_left;down_right) % the king radiates queen's linear attacks for pinned action
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
    not chessman(king,Col,R0,C0,T),
    chessman(king,ECol,R,C,T),
    R' = R + DeltaR, row(R'),
    C' = C + DeltaC, col(C').

% a square is guarded if there is a linear attack on that square - if the piece is not standing on that square already.
guarded(R,C,R0,C0,Col,T) :- 
    linearAttack(R,C,Col,_,R0,C0,T),
    (R,C) != (R0,C0),
    not chessman(king,Col,R0,C0,T).
