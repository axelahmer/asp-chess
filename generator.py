import os

k=6
n = input('n: ')
w = input('white: ')
b = input('black: ')

os.system(f'clingo asp/generator.lp -c n={n} -c w={w} -c b={b}  > results/init.txt')

with open("results/init.txt", "r") as reader:
    f = ''
    results = reader.readlines()[4].split(' ')
    for r in results:
        f+=f'{r}.\n'
    
    with open("results/init.lp", "w") as writer:
        writer.write(f)

# call solver
os.system(f'clingo results/init.lp asp/pieces.lp asp/linear.lp asp/planner.lp -c n={n} -c k={k}  > results/results.txt')