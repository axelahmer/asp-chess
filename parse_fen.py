import sys
piece = {
    'p': ('pawn', 'black'),
    'n' : ('knight', 'black'),
    'b': ('bishop', 'black'),
    'r': ('rook', 'black'),
    'q' : ('queen', 'black'),
    'k' : ('king', 'black'),

    'P': ('pawn', 'white'),
    'N' : ('knight', 'white'),
    'B': ('bishop', 'white'),
    'R': ('rook', 'white'),
    'Q' : ('queen', 'white'),
    'K' : ('king', 'white')
}

# fen = input('fen:')
fen = 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR'

def fen_string(fen, dimension):
    fen = fen.split(' ')
    board = fen[0].split('/')
    preds = ''
    row = dimension
    time = 1
    for fen_row in board:
        col = 1
        for ch in fen_row:
            if ch.isnumeric():
                col += int(ch)
                continue
            piece_name, piece_color = piece[ch]
            preds += f'chessman({piece_name},{piece_color},{row},{col},{time}).\n'
            col += 1
        row -= 1
    return preds
    # text_file = open("init.lp", "w")
    # n = text_file.write(preds)
    # text_file.close()

if __name__ == "__main__":
    fen = sys.argv[1] 
    dimension = int(sys.argv[2])
    print(fen_string(fen, dimension))