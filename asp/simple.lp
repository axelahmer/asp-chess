% Simple Problem: From a semi defined start position - plan to minimize the number of moves to checkmate black.

row(1..n).
col(1..n).
color(white).
color(black).
enemy(white,black).
enemy(black,white).
time(1..k).
color_to_move(1, white).
color_to_move(T, white) :- color_to_move(T-1, black), time(T).
color_to_move(T, black) :- color_to_move(T-1, white), time(T).


% Rules: 
% Checkmate happens when all 3 constraints are satisfied:
%     - The King is under atk
%     - The King cannot move to a safe spot
%     - The attacker cannot be taken (if 1 attacker)
%     - The attacker cannot be blocked (if 1 attacker)
%     - if two pieces are attacking the king : the king has to move.

% it cannot be the case that after a move that color is in check
% color_to_move(Color, T), it cannot be the case that enemy(Color, EnemyColor) check(EnemyColor, T)
:- time(T), color_to_move(T,C), enemy(C,EC), check(EC,T).




% definition of move:
    % :- move(T) and check(Color, T+1) and color_to_move(Color, T)

% if one piece is attacking the king ->
    % can it be taken / can the king move?
        % if it is a knight -> checkmate
    % if it

    % determine piece attacking king : Row, Col

    % KRow, KCol, ARow, ACol. % 1 piece attacking
    % take
    % guarded(ARow,ACol,_,_,KColor)

    % block


    % move
    % already done

    % KRow, KCol, A1Row, A1Col, A2Row, A2Col.

% possible_move(Row', Col', Row, Col, T) :-
%     color_to_move(T, Color),
%     chessman(Piece, Color, Row, Col, T), 
%     guarded(Row', Col', Row, Col, Color, T).

% the king moves to a safe spot and not on a friendly piece
possible_move(Row', Col', Row, Col, T) :- 
    chessman(king, Color, Row, Col, T), 
    guarded(Row', Col', Row, Col, Color, T),
    enemy(Color,EnemyColor),
    row(Row'),
    col(Col'),
    color_to_move(T, Color),
    (Row', Col') != (Row2, Col2) : guarded(Row2, Col2, _, _, EnemyColor, T),
    not chessman(_,Color,Row',Col',T).

% the king cannot step on it's own pieces
% :- chessman(_,Color,R',C',T), possible_move(R',C',R,C,T), chessman(king, Color, R, C, T).

% a friendly piece can take out the sole attacking piece
possible_move(Row2, Col2, Row3, Col3, T) :- 
    chessman(king, Color, Row, Col, T), 
    % the king is under atk
    guarded(Row, Col, Row2, Col2, EnemyColor, T),
    % but a friendly piece can take it out
    guarded(Row2, Col2, Row3, Col3, Color, T),
    enemy(Color, EnemyColor),
    color_to_move(T, Color).

% TODO
% a friendly piece can block the attacking piece
% possible_move(Row2, Col2, Row3, Col3, T) :- 
    % chessman(king, Color, Row, Col, T), 
    % % the king is under atk
    % guarded(Row, Col, Row2, Col2, Color2, T),
    % % but a friendly piece can take it out
    % guarded(Row2, Col2, Row3, Col3, Color, T),
    % Color != Color2,


% new definition of checkmate:
checkmate(T) :-
    color_to_move(T,C),
    time(T),
    {possible_move(_,_,_,_,T)}=0,
    check(C,T).

check(C,T) :-
    enemy(C,EC),
    guarded(Row, Col, _, _, EC, T),
    chessman(king, C, Row, Col, T).

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

{ move(Row, Col, NewRow, NewCol, T) :
    color_to_move(T,Color),
    guarded(NewRow, NewCol, Row, Col, Color, T),
    % cannot take friendly piece down
    not chessman(_, Color, NewRow, NewCol, T),
    row(NewRow),
    col(NewCol),
    chessman(_, _, Row, Col, T)}=1 :- time(T), T<N : checkmate(N).

% set initial board state

% 2 kings: 1 white, 1 black
{chessman(king, black, Row, Col, 1) : row(Row), col(Col)} = 1.
{chessman(king, white, Row, Col, 1) : row(Row), col(Col)} = 1.

% other pieces:
{chessman(rook, white, Row, Col, 1) : row(Row), col(Col)} = knight_count.
% {chessman(knight, black, Row, Col, 1) : row(Row), col(Col)} = 3.

% it cannot be the case that there is more than 1 chessman on a square
:- chessman(P,Color,R,C,T), chessman(P',Color',R',C',T), (P,Color)!=(P',Color'), (R,C)==(R',C').
% old version
% :- chessman(X, _, Row, Col, T), chessman(Y, _, Row, Col, T), X!=Y.

% it is not check at t<N:
% :- check(T) : time(T), T<N, checkmate(N).

% there must be no check at time 1 for black
:- check(black,1).

% minimize the number of moves until checkmate
#minimize{N:checkmate(N)}.

% there must be a checkmate
:- not {checkmate(N) : time(N)}=1.

% the checkmate must not be on white
:- checkmate(N), color_to_move(N,white).

% king cannot be in corner
% :- chessman(king,_, Row, Col, 1), Col=(1;n), Row=(1;n).


% :- checkmate(1..2).

% #show king/2.
#show chessman/5.
#show pin/3.
% #show possible_move/5.
#show guarded/5.
#show move/5.
% #show checkmate/1.
% #show check/2.
% #show color_to_move/2.