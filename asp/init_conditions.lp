row(1..n).
col(1..n).

% limit the number of chess pieces
{chessman(king,Row,Col,0):row(Row), col(Col)}=1.
{chessman(knight,Row,Col,0):row(Row), col(Col)} = chess_count.


