% if kings are not in the corner, there should be a mate in 1 via xray guarding.
{chessman(rook, white, Row, Col, 1) : row(Row), col(Col)} = 1.
:- chessman(king,_, Row, Col, 1), Col=(1;n), Row=(1;n).