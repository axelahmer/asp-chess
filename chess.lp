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
    not being_guarded(NewRow, NewCol)
    } = N, 
    % the king cnanot move to a safe spot
    N=0, 
    % the king is currently under check
    king(Row, Col), being_guarded(Row, Col). % being_guarded(Row,Col);

:- not checkmate.

% the king cant be on the same position as pawn
:- king(Row, Col), pawn(Row, Col).

% the king cant be on the same position as knight
:- king(Row, Col), knight(Row, Col).
:- knight(Row, Col), pawn(Row, Col).

% pawns guarding positions
being_guarded(Row+1, Col+1; Row+1, Col-1) :- pawn(Row, Col).

% knights guarding positions
being_guarded(
    Row+2, Col+1; Row+1, Col+2; Row-1, Col+2; Row-2, Col+1;
    Row-2, Col-1; Row-1, Col-2; Row+1, Col-2; Row+2, Col-1
) :- knight(Row, Col).

% pick a position to place king
{king(Row, Col):row(Row), col(Col)} = 1.

% pick positions to place pawns 
{pawn(Row, Col): row(Row), col(Col)}.

% pick positions to place knight 
{knight(Row, Col): row(Row), col(Col)}.

% limit the number of chess pieces
enemy(Row, Col) :- knight(Row, Col).
enemy(Row, Col) :- pawn(Row, Col).
:- #count{ (Row, Col):enemy(Row, Col) } = N, N > 3.


#show king/2.
#show knight/2.
#show pawn/2.
% #show enemy/2.
