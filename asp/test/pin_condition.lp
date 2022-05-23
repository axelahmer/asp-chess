% testcase for pin situation
chessman(king, black, 1, 2, 1).
chessman(rook, white, 1, 4, 1).
chessman(knight, black, 1, 3, 1).
:- move(1,4,Row, Col, 1), row(Row), col(Col).