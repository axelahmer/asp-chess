% Simple Problem: From a semi defined start position - plan to minimize the number of moves to checkmate black.

row(1..n).
col(1..n).
time(1..k).

% Rules: 
% Checkmate happens when all 3 constraints are satisfied:
%     - The King is under atk
%     - The King cannot move to a safe spot
%     - The attacker cant be taken

% NewRow, NewCol = King's movement
checkmate(T) :- #count 
    % set of King's valid move (not being guard by pawns)
    {(NewRow, NewCol): 
    (NewRow, NewCol) != (Row, Col), 
    NewRow=Row-1..Row+1, 
    NewCol=Col-1..Col+1, 
    col(NewCol), row(NewRow),
    not guarded(NewRow, NewCol,_,_, T)
    } = N, 
    % the king cnanot move to a safe spot
    N=0,
    % the king is currently under attack
    chessman(king,Row,Col,T), guarded(Row,Col,_,_,T). % guarded(Row,Col);

check(T) :- chessman(king,Row,Col,T), guarded(Row,Col,_,_,T).

% the pieces cant be on the same position TODO: Refactor this
:- chessman(X, Row, Col, T), chessman(Y, Row, Col, T), X!=Y.

% create a chessman at t+1 that moved!
chessman(Piece, NewRow, NewCol, T+1) :-
    chessman(Piece,Row,Col,T), move(Row, Col, NewRow, NewCol, T).

% add to the set of chessmen at t+1 all the men who have not moved.
chessman(Piece, Row, Col, T+1) :-
    chessman(Piece,Row,Col,T),
    move(Row', Col', NewRow, NewCol, T),
    (Row, Col) != (Row', Col'), 
    row(NewRow), col(NewCol), row(Row'), col(Col'),
    time(T). % TODO gotcha: a piece may have been taken.

{ move(Row, Col, NewRow, NewCol, T) :
    guarded(NewRow, NewCol, Row, Col, T),
    row(NewRow),
    col(NewCol),
    chessman(_,Row,Col,T)}=1 :- time(T), T<k.


% set initial board state
{chessman(king,Row,Col,1) : row(Row), col(Col)} = 1.
{chessman(knight,Row,Col,1) : row(Row), col(Col)} = knight_count.

% it is not check at t<k:
:- check(T), time(T), T<k.

% enforce mate at time=k
:- not checkmate(k).

% #show king/2.
#show chessman/4.
#show move/5.