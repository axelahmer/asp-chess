import os

def read_prolog(arr, dimension, k):
    board = [[["   "] * dimension for _ in range(dimension)] for _ in range(k + 2)]
    max_time = 0
    solution = ['' for i in range(k)] 
    print(k, solution)
    for chess in arr:
        if chess.startswith('chessman'):
            index = chess.find('(')
            index_end = chess.find(')')
            chesspiece, color, row, col, time = chess[index+1:index_end].split(',')

            row, col, time = int(row), int(col), int(time) -1
            max_time = max(time, max_time)
            row, col = row-1, col-1
            if chesspiece== "queen" :
                if color == "white":
                    board[time][row][col] = ' \u2655 '
                elif  color == "black":
                    board[time][row][col] = ' \u265B '
            elif chesspiece== "rook" :
                if color == "white":
                    board[time][row][col] = ' \u2656 '
                elif  color == "black":
                    board[time][row][col] = ' \u265C '
            elif chesspiece== "bishop" :
                if color == "white":
                    board[time][row][col] = ' \u2657 '
                elif  color == "black":
                    board[time][row][col] = ' \u265D '
            elif chesspiece== "knight" :
                if color == "white":
                    board[time][row][col] = ' \u2658 '
                elif  color == "black":
                    board[time][row][col] = ' \u265E '
            elif chesspiece== "pawn" :
                if color == "white":
                    board[time][row][col] = ' \u2659 '
                elif  color == "black":
                    board[time][row][col] = ' \u265F '
            elif chesspiece== "king" :
                if color == "white":
                    board[time][row][col] = ' \u2654 '
                elif  color == "black":
                    board[time][row][col] = ' \u265A '
        elif chess.startswith("guarded"):
            index = chess.find('(')
            index_end = chess.find(')')
            row, col, _, _, color, time = chess[index+1:index_end].split(',')
            row, col, time = int(row), int(col), int(time) -1
            if row > dimension or col > dimension or row < 1 or col < 1:
                continue
            
            row, col = row-1, col-1
            board[time][row][col] = board[time][row][col][:-1] + 'X' if color == 'black' else 'O' + board[time][row][col][1:]

        elif chess.startswith("move"):
            index = chess.find('(')
            index_end = chess.find(')')
            row, col, newRow, newCol, time = chess[index+1:index_end].split(',')
            row, newRow, time = int(row), int(newRow), int(time) -1
            row, newRow = map_row_to_alphabet(row), map_row_to_alphabet(newRow)
            solution[time] = f'{row}{col}{newRow}{newCol}'
        else: 
            print(chess) 
    return board, max_time+1, solution[:-1]


def print_board(board, dimension):
    linebreak = "\n" + "-----" * dimension + '-'
    for i in range(dimension):
        print(linebreak)
        print('|', end='')
        for j in range(dimension):
            print(board[dimension-1-i][j], end=" |")
    print(linebreak)


def run_clingo(n, k, white_count, black_count, l, model):
    # os.system(f"clingo asp/init.lp asp/pieces.lp asp/linear.lp asp/planner.lp -c n={n} -c k={k} -c white_count={white_count} -c black_count={black_count} --opt-mode optN -n {l} > output.txt")
    # os.system(f"clingo asp2\{model}.lp asp2\planner.lp asp2\linear.lp asp2\pieces.lp -c n={n} -c k={k} -c w={white_count} -c b={black_count} --opt-mode optN -n {l} > output.txt")
    os.system(f"clingo asp2\{model}.lp asp2\planner.lp asp2\linear.lp asp2\pieces.lp --verbose=2 -c n={n} -c k={k} -c w={white_count} -c b={black_count} -n {l} > output.txt")


def read_output_and_print(n, k):
    with open("output.txt", "r") as reader:
        results = reader.readlines()
        ans_count = 0
        for i in range(len(results)):
            if results[i].startswith("Answer"):
                ans_count += 1
                i += 1
                arr = results[i].split()
                board, max_time, solution = read_prolog(arr, n, k)
                print("\nAnswer {}".format(ans_count) )
                for j in range(max_time):
                    print_board(board[j], n)
                
                write_to_file(parse_latex_chessboard(board[0], ','.join(solution)))

def write_to_file(latex_chessboard):
    with open("latex.txt", "a") as writer:
        writer.write(latex_chessboard)

def map_row_to_alphabet(n):
    return chr(ord('`')+n)

def parse_latex_chessboard(board, solution):
    def map_unicode_to_latex(cell):
        if cell == '\u2655':
            return f'Q{map_row_to_alphabet(i+1)}{j+1},'
        elif cell == '\u265B':
            return f'q{map_row_to_alphabet(i+1)}{j+1},'
        elif cell == '\u2656':
            return f'R{map_row_to_alphabet(i+1)}{j+1},'
        elif cell == '\u265C':
            return f'r{map_row_to_alphabet(i+1)}{j+1},'
        elif cell == '\u2657':
            return f'B{map_row_to_alphabet(i+1)}{j+1},'
        elif cell == '\u265D':
            return f'b{map_row_to_alphabet(i+1)}{j+1},'
        elif cell == '\u2658':
            return f'N{map_row_to_alphabet(i+1)}{j+1},'
        elif cell == '\u265E':
            return f'n{map_row_to_alphabet(i+1)}{j+1},'
        elif cell == '\u2659':
            return f'P{map_row_to_alphabet(i+1)}{j+1},'
        elif cell == '\u265F':
            return f'p{map_row_to_alphabet(i+1)}{j+1},'
        elif cell == '\u2654':
            return f'K{map_row_to_alphabet(i+1)}{j+1},'
        elif cell == '\u265A':
            return f'k{map_row_to_alphabet(i+1)}{j+1},'
        else:
            return ''

    dimension = len(board)

    latex_fen = f'\\dynamicplan{{{map_row_to_alphabet(dimension)}{dimension}}}{{'
    for i in range(len(board)):
        for j in range(len(board[i])):
            # if there is a Piece on the board 
            latex_fen += map_unicode_to_latex(board[i][j][1])
    
    return latex_fen[:-1] + f'}}{{{solution}}}\n'
            

if __name__ == "__main__":
    # val = ""
    # while val != "q":
    #     val = input("Enter the ASP result or q to quit\n")
    #     dimension = int(input("Enter dimension of the chessboard\n"))
    #     arr = val.split()
    #     board = read_prolog(arr, dimension)
    #     print_board(board, dimension)

    n = int(input("Enter board dimension \n"))
    white_count = int(input("Enter white piece count \n"))
    black_count = int(input("Enter black piece count \n"))

    k = int(input("Enter steps count \n"))
    l = int(input("Enter number of answers \n"))
    model = input("Dynamic (d) or Static (s)\n")
    run_clingo(n, k, white_count, black_count, l, "dynamic" if model=='d' else 'static')
    read_output_and_print(n, k)
