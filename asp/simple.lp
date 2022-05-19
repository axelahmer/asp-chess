% Simple Problem: From a semi defined start position - plan to minimize the number of moves to checkmate black.

row(1..n).
col(1..n).
color(white).
color(black).
time(1..k).
color_to_move(1, white).
color_to_move(T, white) :- color_to_move(T-1, black), time(T).
color_to_move(T, black) :- color_to_move(T-1, white), time(T).
% Rules: 
% Checkmate happens when all 3 constraints are satisfied:
%     - The King is under atk
%     - The King cannot move to a safe spot
%     - The attacker cant be taken

possible_moves(Row', Col', Row, Col, T) :- 
    chessman(king, Color, Row, Col, T), 
    guarded(Row', Col', Row, Col, Color, T),
    Color != Color2, color(Color2), row(Row'), col(Col'),
    (Row', Col') != (Row2, Col2): guarded(Row2, Col2, Row3, Col3, Color2, T).
    

possible_moves(Row2, Col2, Row3, Col3, T) :- 
    chessman(king, Color, Row, Col, T), 
    % the king is under atk
    guarded(Row, Col, Row2, Col2, Color2, T),
    % but a friendly piece can take it out
    guarded(Row2, Col2, Row3, Col3, Color, T),
    Color != Color2,
    chessman(_, white, Row3, Col3, T).

% NewRow, NewCol = King's movement
checkmate(T) :- 
    % set of King's valid move (not being guard by pawns)
    #count 
    {(NewRow, NewCol): 
    (NewRow, NewCol) != (Row, Col), 
    NewRow=Row-1..Row+1, 
    NewCol=Col-1..Col+1, 
    col(NewCol), row(NewRow),
    not guarded(NewRow, NewCol,_,_, Color2, T)
    } = N, 
    % the king cannot move to a safe spot
    N=0,
    % the king is currently under attack
    chessman(king,Color,Row,Col,T), 
    guarded(Row,Col,_,_, Color2, T),
    Color != Color2, 
    color_to_move(T, Color).

check(T) :-
    guarded(Row, Col, Row', Col', Color', T),
    Color != Color';
    chessman(king, Color, Row, Col, T), 
    color_to_move(T, Color).

check(1) :- 
    guarded(Row, Col, _, _, white, 1),
    chessman(king, black, Row, Col, 1).

% the pieces cant be on the same position TODO: Refactor this
:- chessman(X, _, Row, Col, T), chessman(Y, _, Row, Col, T), X!=Y.

% create a chessman at t+1 that moved!
chessman(Piece, Color, NewRow, NewCol, T+1) :-
    move(Row, Col, NewRow, NewCol, T),
    color(Color),
    chessman(Piece, Color, Row, Col, T),
    color_to_move(T, Color).

% add to the set of chessmen at t+1 all the men who have not moved.
chessman(Piece, Color, Row, Col, T+1) :-
    move(Row', Col', NewRow, NewCol, T),
    (Row, Col) != (Row', Col'), 
    row(NewRow), col(NewCol), row(Row'), col(Col'),
    time(T), % TODO gotcha: a piece may have been taken.
    chessman(Piece, Color, Row, Col, T),
    color(Color).

% it does not matter whos move it is - any color can move.
{ move(Row, Col, NewRow, NewCol, T) :
    guarded(NewRow, NewCol, Row, Col, Color, T),
    % cannot take friendly piece down
    not chessman(_, Color, NewRow, NewCol, T),
    row(NewRow),
    col(NewCol),
    chessman(_, _, Row, Col, T)}=1 :- time(T), T<N : checkmate(N).


% set initial board state
{chessman(king, black, Row, Col, 1) : row(Row), col(Col)} = 1.
{chessman(knight, white, Row, Col, 1) : row(Row), col(Col)} = knight_count.
{chessman(knight, black, Row, Col, 1) : row(Row), col(Col)} = 1.

% it is not check at t<N:
:- check(T) : time(T), T<N, checkmate(N).

% there must be no check at time 1
:- check(1).

% minimize the number of moves until checkmate
#minimize{N@1:checkmate(N)}.

% there must be a checkmate
:- not {checkmate(N) : color_to_move(N, black), time(N)}=1.

% king cannot be in corner
% :- chessman(king,_, Row, Col, 1), Col=(1;n), Row=(1;n).


% #show king/2.
#show chessman/5.
#show possible_moves/5.
#show move/5.