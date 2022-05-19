holds(P, 0) :- init(P).

{occ(A,T) : action(A) } = 1 :- time(T).
:- occ(A,T), pre(A,F), not holds(F,T-1).

holds(F,T) :- occ(A,T), add(A,F).
holds(F,T) :- holds(F, T-1), time(T), not occ(A,T) :del(A,F).

:- query(F), not holds(F, k).


time(1..k).
cell(1..8, 1..8).
action(move_knight(X,Y)):- cell(X,Y).
pre(move_knight(X,Y), knight(X,Y)):- cell(X,Y).
add(move_knight(X,Y), knight(X+2, Y+1)):- cell(X,Y), cell(X+2, Y+1).
del(move_knight(X,Y), knight(X,Y)):- cell(X,Y).


% action(move_knight).
% pre(move_knight, knight(1,1)).
% add(move_knight, knight(3,2)).
% del(move_knight, knight(1,1)).

init(knight(1,1)).
query(knight(5,3)).



#show occ/2.
