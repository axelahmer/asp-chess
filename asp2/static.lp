% minimize the number of moves until checkmate.
#minimize{N:checkmate(N)}.
% :~ checkmate(N). [N]

% there must be a checkmate.
:- not {checkmate(N) : time(N)}=1.

% the checkmate must not be on white.
:- checkmate(N), color_to_move(N,white).

% there must be no check at time 1 for white or black.
:- check(_, white,1).
:- check(_, black,1).

% colors do not alternate until checkmate.
color_to_move(1, white).
color_to_move(T, white) :- color_to_move(T-1, white), time(T), T<N: checkmate(N).
color_to_move(T, black) :- time(T), checkmate(T).

% checkmate is when only black has no moves, and they are in check.
checkmate(T) :-
    time(T),
    check(black,T),
    {legalMove(_,_,_,_,T)}=0.

% black is not in check until they are checkmated.
:- check(black, T), checkmate(N), T < N.