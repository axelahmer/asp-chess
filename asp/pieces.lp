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

% BISHOPS

% ROOKS
% rooks guarding positions - horizontal
guarded(Row, Low..Col-1, Row, Col, Color, T; Row, Col+1..High, Row, Col, Color, T)
 :- High = #min{
    Col2 : chessman(_,_, Row, Col2, T), Col2 > Col;
    Col2+1: chessman(king, Color2, Row, Col2, T); % xray attack
    n: #true},
    Low = #max{
    Col2 : chessman(_,_, Row, Col2, T), Col > Col2; 
    Col2-1: chessman(king, Color2, Row, Col2, T); % xray attack
    1: #true},
    chessman(rook, _, Row, Col, T),
    enemy(Color, Color2).

% rooks guarding positions - vertical
guarded(Low..Row-1, Col, Row, Col, Color, T; Row+1..High, Col, Row, Col, Color, T)
 :- High = #min{
    Row2 : chessman(_,_, Row2, Col, T), Row2 > Row;
    Row2 + 1: chessman(king, Color2, Row2, Col, T), Row2 > Row; % xray attack
    n: #true},
    Low = #max{
    Row2 : chessman(_,_, Row2, Col, T), Row > Row2; 
    Row2 - 1: chessman(king, Color2, Row2, Col, T), Row2 > Row; % xray attack
    1: #true},
    chessman(rook, _, Row, Col, T),
    enemy(Color, Color2).

% not working just yet
pin(Row, Col, T):-
    chessman(king, Color, Row, KingCol, T),
    chessman(rook, Color2, Row, RookCol, T),
    chessman(_, Color, Row, Col, T),
    Col < KingCol, Col > RookCol, 
    #count { chessman(Piece, Color, Row, Col', T): piece(Piece), time(T), col(Col'), Col' < KingCol, Col' > RookCol } =1.
    
% QUEENS

% pawns cannot exist on row=1,n

% pawns promote to a bishop, knight, rook, or queen if there is a move that puts them to the end of the board,

