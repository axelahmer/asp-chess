piece(bishop;rook;knight;queen).

% 2 kings: 1 white, 1 black
{chessman(king, black, Row, Col, 1) : row(Row), col(Col)} = 1.
{chessman(king, white, Row, Col, 1) : row(Row), col(Col)} = 1.
{chessman(Piece, white,Row, Col, 1) : row(Row), col(Col), piece(Piece)} = white_count.
{chessman(Piece, black,Row, Col, 1) : row(Row), col(Col), piece(Piece)} = black_count.