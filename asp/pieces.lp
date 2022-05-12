% guarded/5 defines how a piece type attacks

% PAWNS
guarded(Row+1, Col+1; Row+1, Col-1, T) :-
    chessman(pawn, Row, Col, T), time(T).

% KNIGHTS
guarded(
        Row+2, Col+1, Row, Col, T;
        Row+1, Col+2, Row, Col, T;
        Row-1, Col+2, Row, Col, T;
        Row-2, Col+1, Row, Col, T;
        Row-2, Col-1, Row, Col, T;
        Row-1, Col-2, Row, Col, T;
        Row+1, Col-2, Row, Col, T;
        Row+2, Col-1, Row, Col, T) :-
    chessman(knight, Row, Col, T).