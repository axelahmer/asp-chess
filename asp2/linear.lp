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
linearAttack(DMove, R,C,Col,Dir,R,C,T) :- 
    dynamicMove(MR,MC,MR',MC',T-1),
    DMove = dynamicMove(MR,MC,MR',MC',T-1),
    linPiece(P,Dir),
    ichessman(DMove,P,Col,R,C,T).

% a linear attack continues unless it is blocked by a piece!
linearAttack(DMove, R',C',Col,Dir,R0,C0,T) :-
    dir(Dir, DeltaR, DeltaC),
    linearAttack(DMove, R,C,Col,Dir,R0,C0,T),
    R' = R + DeltaR, row(R'),
    C' = C + DeltaC, col(C'),
    (R,C) == (R0,C0) : ichessman(DMove,_,_,R,C,T). % terminate propagation if hit ichessman.

% a square is guarded if there is a linear attack on that square - if the piece is not standing on that square already.
guarded(DMove, R,C,R0,C0,Col,T) :- 
    linearAttack(DMove, R,C,Col,_,R0,C0,T),
    (R,C) != (R0,C0). % cannot guard itself.
