% there must be no check at time 1 for white or black.
:- check(_, white,1).
:- check(_, black,1).

% colors alternate per turn.
color_to_move(1, white).
color_to_move(T, white) :- color_to_move(T-1, black), time(T).
color_to_move(T, black) :- color_to_move(T-1, white), time(T).

% there can not be more than 1 legal move for every black turn.
:-  time(T),
    color_to_move(T, black),
    legalMove(R1,C1,R1',C1',T),
    legalMove(R2,C2,R2',C2',T),
    (R1,C1,R1',C1') != (R2,C2,R2',C2').

% checkmate depends on the color to move
checkmate(T) :-
    time(T),
    color_to_move(T,Col),
    check(Col,T),
    {legalMove(_,_,_,_,T)}=0.


% #minimize{N:checkmate(N)}.
% :~ checkmate(N). [N]

% there must be a checkmate.
:- not {checkmate(N) : time(N)}=1.

% the checkmate must not be on white.
:- checkmate(N), color_to_move(N,white).


% all legal moves white makes at t=1 must lead to black not in check.
:-  color_to_move(T,white),
    legalMove(R,C,R',C',T),
    check(dynamicMove(R,C,R',C',T), black, T+1),
    T < N-1 : checkmate(N).

% there must be a checkmate at some const time.
:- not checkmate(4).

% there must not be a check to black at time 2.
:- check(black,2).

% soft constraints: min white piece values, max black piece values.
:~ #sum{V,R,C : chessman(P,white,R,C,1), value(P,V)}=T. [T@10]
:~ #sum{V,R,C : chessman(P,black,R,C,1), value(P,V)}=T. [-T@5]
