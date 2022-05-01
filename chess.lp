row(1..n).
col(1..n).

% Problem: Find Checkmates with Given Pieces - Pawns(stage-1) 

% Ideas
% Answer set should include {King position}
% Rules: 
% Checkmate happens when all 3 constraints are satisfied:
%     - The King is under atk
%     - The King cannot move to a safe spot
%     - The attacker cant be taken

% NewRow, NewCol = King's movement
checkmate :- #count 
    % set of King's valid move (not being guard by pawns)
    {(NewRow, NewCol): 
    (NewRow, NewCol) != (Row, Col), 
    NewRow=Row-1..Row+1, 
    NewCol=Col-1..Col+1, 
    col(NewCol), row(NewRow),
    not pawn_guarding(NewRow, NewCol)
    } = N, 
    % the king cnanot move to a safe spot
    N=0, 
    % the king is currently under check
    king(Row, Col), pawn_guarding(Row,Col).

:- not checkmate.

% the king cant be on the same position as pawn
:- king(Row, Col), pawn(Row, Col).

% pawns guarding positions
pawn_guarding(Row+1, Col+1; Row+1, Col-1) :- pawn(Row, Col).

% pick a position to place king
{king(Row, Col):row(Row), col(Col)} = 1.

% pick positions to place pawns 
{pawn(Row, Col): row(Row), col(Col)} = 4.


#show king/2.
#show pawn/2.
