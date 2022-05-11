% week 9 notes

% attacking defines how each piece attacks
attacking(X1,Y1,X2,Y2,T)

% pieces that dont move between moves:
chessman(type,color,X,Y,T+1) :- 
	chessman(type,color,X,Y,T),
	not move(X, Y, _, _, T), % the piece is not the moving piece
	not move(_, _, X, Y, T), % the piece is not the piece being taken

% pieces that do move between moves:
	

% defining move
{move(X_From, Y_From, X_To, Y_To,T): time(T), loc(X_From), loc(Y_From), loc(X_To), loc(Y_To) }=1 :- 
time(T).

% an action 

	
chessman(_,color,X_From,Y_From,T), % the piece must be white
	attacking(X_From,Y_From,X_To,Y_To,T), % only time not true - pawn


% ASP planning pseudocode
holds(P,0) :- init(P).
{ occ(A, T) : action(A) } = 1 :- time(T).
:- occ(A, T), pre(A,F), not holds(F, T-1).

holds(F,T) :- occ(A, T), add(A, F).
holds(F,T) :- holds(F, T-1), time(T), not occ(A,T) : del(A, F).
:- query(F), not holds(F, k).



t=0          ----action---->     t=1   -------a2---->     t=2      --------> goal state
{chessmen}                {chessmen}                  {chessmen}
{chessmen(_,_,_,_,0)}


% defining an action for a chessman to move from (X, Y) to (X2, Y2)
pre-condition :- the chessman is on (X, Y)
add :- what happens after the move, the chessman move to (X2, Y2), it's now guarding { cells2 }
del :- the chessman no longer on (X,Y), and no longer guarding { cells1 }

{ starting board positions, moves from t_1 to t_k }

pawn(1,1).
action(movePawn).
pawn(2,1), guarding(3,2).
del(pawn(1,1))

{sp0}  action> {sp1}




notes from https://www.youtube.com/watch?v=Rn-jPtQjFro:

STRIPS planning involve:
https://en.wikipedia.org/wiki/Stanford_Research_Institute_Problem_Solver

fluents (things that will change):
    - the move predicate
    - potentially the chessman predicate for all T? (placing pieces on the board)

inital and goal state:
    initial state:
        T=1, chessman predicate (position of pieces at T=1, i.e. some starting configuration).
        whos turn is it?
        en passant?
    
    goal state:
        checkmate at some T=N?

set of actions, consistion of pre- and postconditions:
    - preconditions tell us when an action is applicable.
        when a move can be made
            does T-1 have to be fully defined before the move from T-1 to T can be made?
            perhaps better to just restrict that the moving piece must be at the prev location,
                and can move to the destination. (not the whole board being fixed) 
    - postconditions tell us about the effects on an action.
        poscondition for a move at time T means the board position at T+1 is fully defined?

number k of allowed actions:
    all the moves for pieces of the correct color currently on the board.


additional notes:
we likely want to bound time(1..k), then try to find the minimum soln to getting checkmate from making a series of moves.