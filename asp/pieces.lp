piece(knight; rook).

% guarded/5 defines how a piece type attacks

% Guarded: What squares a piece is protecting/attacking.

% PAWNS
guarded(Row+1, Col+1, Row, Col, T;
        Row+1, Col-1, Row, Col, T) :-
    chessman(pawn, white, Row, Col, T), time(T).

% KNIGHTS
guarded(
        Row+2, Col+1, Row, Col, Color, T;
        Row+1, Col+2, Row, Col, Color, T;
        Row-1, Col+2, Row, Col, Color, T;
        Row-2, Col+1, Row, Col, Color, T;
        Row-2, Col-1, Row, Col, Color, T;
        Row-1, Col-2, Row, Col, Color, T;
        Row+1, Col-2, Row, Col, Color, T;
        Row+2, Col-1, Row, Col, Color, T) :-
    chessman(knight, Color, Row, Col, T).

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

% % pawns cannot exist on row=1,n

% % pawns promote to a bishop, knight, rook, or queen if there is a move that puts them to the end of the board,

