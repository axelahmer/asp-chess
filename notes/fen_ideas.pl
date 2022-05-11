Squares: List of square(type, color)

board(Squares,)

Positions : List of Position

position(Squares)


piece(type,color,x,y)



position(Pieces,SideToMove,CastlingRights,EnPassantSquare,HalfMoveClock,FullMoveClock) :-



initial_fen_string("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1").
% generate a position from fen:
fen(FenString,position(Pieces,Side,Castling,Passant,HalfClock,FullClock)) :-


rank(Y, [Char | Rest], Rest) :-
    nth1(Y, "12345678", Char).
    
    file(X, [Char | Rest], Rest) :-
    nth1(X, "abcdefgh", Char).

piece_char(piece(PieceType, white), Char) :-
    nth0(Ix, "PBNRQK", Char),
    nth0(Ix, [pawn, bishop, knight, rook, queen, king], PieceType).
    
    piece_char(piece(PieceType, black), Char) :-
    nth0(Ix, "pbnrqk", Char),
    nth0(Ix, [pawn, bishop, knight, rook, queen, king], PieceType).