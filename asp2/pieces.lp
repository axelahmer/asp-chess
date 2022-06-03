%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PIECES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

value(queen,9).
value(rook,5).
value(bishop,3).
value(knight,3).


% KNIGHTS
guarded(DMove, R+2, C+1, R, C, Col, T;
        DMove, R+1, C+2, R, C, Col, T;
        DMove, R-1, C+2, R, C, Col, T;
        DMove, R-2, C+1, R, C, Col, T;
        DMove, R-2, C-1, R, C, Col, T;
        DMove, R-1, C-2, R, C, Col, T;
        DMove, R+1, C-2, R, C, Col, T;
        DMove, R+2, C-1, R, C, Col, T) :-
    ichessman(DMove, knight, Col, R, C, T).

% KINGS
guarded(DMove, R+1,  C,    R, C, Col, T;
        DMove, R,    C+1,  R, C, Col, T;
        DMove, R-1,  C+1,  R, C, Col, T;
        DMove, R-1,  C,    R, C, Col, T;
        DMove, R-1,  C-1,  R, C, Col, T;
        DMove, R,    C-1,  R, C, Col, T;
        DMove, R+1,  C+1,  R, C, Col, T;
        DMove, R+1,  C-1,  R, C, Col, T) :-
    ichessman(DMove, king, Col, R, C, T).
