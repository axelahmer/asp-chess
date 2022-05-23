% if black pieces are placed badly it is possible to mate with a single knight.
{chessman(knight, white, Row, Col, 1) : row(Row), col(Col)} = 1.
{chessman(knight, black, Row, Col, 1) : row(Row), col(Col)} = 1.