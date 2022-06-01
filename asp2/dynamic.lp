% there must be no check at time 1 for white or black
:- check(_, white,1).
:- check(_, black,1).

% colors alternate turns
color_to_move(1, white).
color_to_move(T, white) :- color_to_move(T-1, black), time(T).
color_to_move(T, black) :- color_to_move(T-1, white), time(T).

% there can not be more than 1 legal move for black every turn.
:- time(T), color_to_move(T, black), legalMove(R1,C1,R1',C1',T), legalMove(R2,C2,R2',C2',T), (R1,C1,R1',C1') != (R2,C2,R2',C2').

% there must be a checkmate at some const time
% :- not checkmate(4).

% :- check(black,2).

% checkmate depends on the color to move
checkmate(T) :-
    time(T),
    color_to_move(T,Col),
    check(Col,T),
    {legalMove(_,_,_,_,T)}=0.


% #minimize{N:checkmate(N)}.
:~ checkmate(N). [N]

% there must be a checkmate
:- not {checkmate(N) : time(N)}=1.

% the checkmate must not be on white
:- checkmate(N), color_to_move(N,white).
