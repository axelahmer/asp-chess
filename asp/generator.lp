row(1..n).
col(1..n).

piece(bishop;rook;knight;queen).

% 2 kings: 1 white, 1 black
{chessman(king, black, Row, Col, 1) : row(Row), col(Col)} = 1.
% {chessman(king, white, Row, Col, 1) : row(Row), col(Col)} = 1.
{chessman(Piece, white,Row, Col, 1) : row(Row), col(Col), piece(Piece)} = w.
{chessman(Piece, black,Row, Col, 1) : row(Row), col(Col), piece(Piece)} = b.


#show chessman/5.