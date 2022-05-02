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
:- knight(Row, Col), rook(Row, Col).
:- rook(Row, Col), pawn(Row, Col).
:- rook(Row, Col), king(Row, Col).
:- bishop(Row, Col), king(Row, Col).
:- bishop(Row, Col), rook(Row, Col).
:- bishop(Row, Col), knight(Row, Col).
:- bishop(Row, Col), pawn(Row, Col).

% pawns guarding positions
being_guarded(Row+1, Col+1; Row+1, Col-1) :- pawn(Row, Col).

% knights guarding positions
being_guarded(
    Row+2, Col+1; Row+1, Col+2; Row-1, Col+2; Row-2, Col+1;
    Row-2, Col-1; Row-1, Col-2; Row+1, Col-2; Row+2, Col-1
) :- knight(Row, Col).

% rooks guarding positions - horizontal
being_guarded(Row, Low..Col-1; Row, Col+1..High)
 :- High = #min{Col2-1 : 
    enemy(Row, Col2), Col2 > Col;
    n: #true},
    Low = #max{Col2+1 : 
    enemy(Row, Col2), Col > Col2; 
    1: #true},
    rook(Row, Col).

% rooks guarding positions - vertical
being_guarded(Low..Row-1, Col; Row+1..High, Col)
 :- High = #min{Row2-1 : 
    enemy(Row2, Col), Row2 > Row;
    n: #true},
    Low = #max{Row2+1 : 
    enemy(Row2, Col), Row > Row2; 
    1: #true},
    rook(Row, Col).

% bishops guarding positions - slash
being_guarded(Row+UpBounds, Col+UpBounds; Row-LowBounds, Col-LowBounds)
 :- 
    High = #min{Row2-Row : 
    enemy(Row2, Col2), Row2-Row == Col2-Col, Row2 > Row;
    n: #true},
    Low = #max{Row-Row2 : 
    enemy(Row2, Col2), Row-Row2 == Col-Col2, Row > Row2; 
    1: #true},
    bishop(Row, Col),
    LowBounds = 1..Low,
    UpBounds = 1..High.

% bishops guarding positions - backslash
being_guarded(Row+UpBounds, Col-UpBounds; Row-LowBounds, Col+LowBounds)
 :- 
    High = #min{Row2-Row : 
    enemy(Row2, Col2), Row2-Row == Col-Col2, Row2 > Row;
    n: #true},
    Low = #max{Row-Row2 : 
    enemy(Row2, Col2), Row-Row2 == Col2-Col, Row > Row2; 
    1: #true},
    bishop(Row, Col),
    LowBounds = 1..Low,
    UpBounds = 1..High.

% pick a position to place king
{king(Row, Col):row(Row), col(Col)} = 1.

% pick positions to place pawns 
% {pawn(Row, Col): row(Row), col(Col)}.

% pick positions to place knight 
% {knight(Row, Col): row(Row), col(Col)}.

% {rook(Row, Col): row(Row), col(Col)}.
{bishop(Row, Col): row(Row), col(Col)}.

% limit the number of chess pieces
enemy(Row, Col) :- knight(Row, Col).
enemy(Row, Col) :- pawn(Row, Col).
enemy(Row, Col) :- rook(Row, Col).
enemy(Row, Col) :- bishop(Row, Col).

:- #count{ (Row, Col): enemy(Row, Col) } = N, N > chess_count.


#show king/2.
#show knight/2.
#show pawn/2.
#show rook/2.
#show bishop/2.
% #show enemy/2.
