import os

n = 5
k = 5
num_pieces = 0
l = 1

path = 'asp/test'
files = os.listdir(path)

for f in files:
    os.system(f"clingo {path}/{f} asp/simple.lp asp/pieces.lp -c n={n} -c k={k} -c knight_count={num_pieces} --opt-mode optN -n {l} > output.txt")
    with open("output.txt", "r") as reader:
        print(f'running test: {f}')
        results = reader.read()
        print('PASSED') if 'SATISFYABLE' in results else print('FAILED')