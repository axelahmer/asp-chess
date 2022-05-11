import os

def read_prolog(arr, dimension, k):
    board = [[[" "] * dimension for _ in range(dimension)] for _ in range(k + 2)]
    print(board)
    for chess in arr:
        if chess.startswith('move'):
            continue
        index = chess.find('(')
        index_end = chess.find(')')
        chesspiece, row, col, time = chess[index+1:index_end].split(',')

        row, col, time = int(row), int(col), int(time) -1
        row, col = row-1, col-1
        if chesspiece== "queen" :
            board[time][row][col] = '\u2655'
        elif chesspiece== "rook" :
            board[time][row][col] = '\u2656'
        elif chesspiece== "bishop" :
            board[time][row][col] = '\u2657'
        elif chesspiece== "knight" :
            board[time][row][col] = '\u2658'
        elif chesspiece== "pawn" :
            board[time][row][col] = '\u2659'
        elif chesspiece== "king" :
            board[time][row][col] = '\u265A'
    return board


def print_board(board, dimension):
    linebreak = "\n" + "---" * dimension + '-'
    for i in range(dimension):
        print(linebreak)
        print('|', end='')
        for j in range(dimension):
            print(board[dimension-1-i][j], end=" |")
    print(linebreak)


def run_clingo(n, k, knight_count=None):
    os.system(f"clingo asp/simple.lp -c n={n} -c k={k} -c knight_count={knight_count} 10 > output.txt")


def read_output_and_print(n, k):
    with open("output.txt", "r") as reader:
        results = reader.readlines()
        ans_count = 0
        for i in range(len(results)):
            if results[i].startswith("Answer"):
                ans_count += 1
                i += 1
                arr = results[i].split()
                board = read_prolog(arr, n, k)
                print("\nAnswer {}".format(ans_count) )
                for j in range(k):
                    print_board(board[j], n)


if __name__ == "__main__":
    # val = ""
    # while val != "q":
    #     val = input("Enter the ASP result or q to quit\n")
    #     dimension = int(input("Enter dimension of the chessboard\n"))
    #     arr = val.split()
    #     board = read_prolog(arr, dimension)
    #     print_board(board, dimension)

    n = int(input("Enter board dimension \n"))
    chess_count = int(input("Enter chess piece count \n"))
    k = int(input("Enter steps count \n"))
    run_clingo(n, k, chess_count)
    read_output_and_print(n, k)
