import os

def read_prolog(arr, dimension):
    board = [[" "] * dimension for _ in range(8)]
    for chess in arr:
        index = chess.find('(')
        index_end = chess.find(')')
        row, col = chess[index+1:index_end].split(',')
        row, col = int(row), int(col)
        row, col = row-1, col-1
        if chess.startswith("knight"):
            board[row][col] = '\u2658'
        elif chess.startswith("pawn"):
            board[row][col] = '\u2659'
        elif chess.startswith("king"):
            board[row][col] = '\u265A'
    return board


def print_board(board, dimension):
    linebreak = "\n" + "---" * dimension + '-'
    for i in range(dimension):
        print(linebreak)
        print('|', end='')
        for j in range(dimension):
            print(board[dimension-1-i][j], end=" |")
    print(linebreak)


def run_clingo(n):
    os.system("clingo chess.lp --const n={} 0 > output.txt".format(n)) 

def read_output_and_print(n):
    with open("output.txt", "r") as reader:
        results = reader.readlines()
        ans_count = 0
        for i in range(len(results)):
            if results[i].startswith("Answer"):
                ans_count += 1
                i += 1
                arr = results[i].split()
                board = read_prolog(arr, n)
                print("\nAnswer {}".format(ans_count) )
                print_board(board, n)


if __name__ == "__main__":
    # val = ""
    # while val != "q":
    #     val = input("Enter the ASP result or q to quit\n")
    #     dimension = int(input("Enter dimension of the chessboard\n"))
    #     arr = val.split()
    #     board = read_prolog(arr, dimension)
    #     print_board(board, dimension)

    n = int(input("Enter board dimension \n"))
    run_clingo(n)
    read_output_and_print(n)
