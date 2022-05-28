row(1..n).
col(1..n).
time(1..k).
itime(1..k+1).
color(white).
color(black).
enemy(white, black).
enemy(black, white).
% there must be no check at time 1 for white or black
:- check(_, white,1).
:- check(_, black,1).

% colors alternate turns
color_to_move(1, white).
color_to_move(T, white) :- color_to_move(T-1, black), time(T).
color_to_move(T, black) :- color_to_move(T-1, white), time(T).

check(DMove, Col, T) :-
    dynamicMove(MR,MC,MR',MC',T-1),
    DMove = dynamicMove(MR,MC,MR',MC',T-1),
    enemy(Col,ECol),
    guarded(DMove, KR, KC, _, _, ECol, T),
    ichessman(DMove, king, Col, KR, KC, T).

numDMoves(T,N):-
    time(T),
    color_to_move(T,Col),
    {dynamicMove(_,_,_,_,T)} = N.

checkmate(T) :-
    time(T),
    color_to_move(T,Col),
    check(Col,T),
    {dynamicMove(_,_,_,_,T)}=0.

% chessman that moved
ichessman(DMove, P, Col, R',C',T+1) :- 
    itime(T+1),
    dynamicMove(R,C,R',C',T),
    DMove = dynamicMove(R,C,R',C',T),
    chessman(P,Col,R,C,T).

% add to the set of chessmen at t+1 all the men who have not moved.
ichessman(DMove, P, Col, R, C, T+1) :-
    itime(T+1),
    dynamicMove(R0, C0, R1, C1, T),
    DMove = dynamicMove(R0, C0, R1, C1, T),
    (R, C) != (R0, C0), % the chessman cannot be the one who moved
    (R, C) != (R1, C1), % the chessman cannot be the one being taken
    chessman(P, Col, R, C, T),
    color(Col).


% for all time before a checkmate there must be a move made.
{move(R,C,R',C',T) : dynamicMove(R,C, R',C',T)}=1 :- % , row(R), col(C), row(R'), col(C')
    time(T),
    T<N : checkmate(N).

% real chessmen are created for the selected dynamicMove. 
chessman(P, Col, R', C', T+1) :- 
    time(T),
    move(DMove, T),
    ichessman(DMove, P, Col, R', C', T+1).

% helper predicate to extract the previous concrete DMove
move(dynamicMove(MR, MC, MR', MC',T), T) :- 
    % dynamicMove(MR, MC, MR', MC',T),
    move(MR, MC, MR', MC',T).

dynamicMove(R, C, R', C', T) :- 
    color_to_move(T,Col), 
    chessman(_,Col,R,C,T), 
    guarded(DMove,R',C',R,C,_,T), 
    row(R'), col(C'),
    itime(T),
    move(DMove, T-1).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CONSTRAINTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% there must be a checkmate
% :- not {checkmate(N) : time(N)}=1. 

% it cannot be the case that there is more than 1 chessman on a square
:-  ichessman(DMove,P,Col,R,C,T),
    ichessman(DMove,P',Col',R',C',T),
    (P,Col)!=(P',Col'), % different piece
    (DMove, R,C)==(DMove, R',C'), % same location
    itime(T).

% a piece can never move such that its king is in check the next timestep
:-  time(T),
    color_to_move(T,Col),
    check(dynamicMove(R,C,R',C',T),Col,T+1) : dynamicMove(R,C,R',C',T).

% a piece can never take its own color.
:-  dynamicMove(R, C, R', C', T),
    color_to_move(T,Col),
    chessman(_,Col,R',C',T).


% there can not be more than 1 dynamic move for black every turn.
% :- time(T), color_to_move(T, black), dynamicMove(R1,C1,R1',C1',T), dynamicMove(R2,C2,R2',C2',T), (R1,C1,R1',C1') != (R2,C2,R2',C2').

% constrain check at t2
% :- not check(_,2).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PIECES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

guarded(R',C',R,C,Col,T) :-
    time(T),
    move(DMove, T-1),
    guarded(DMove, R',C',R,C,Col,T).

check(Col, T) :-
    time(T),
    move(DMove, T-1),
    check(DMove,Col,T).


% KNIGHTS
guarded(DMove, R+2, C+1, R, C, Col, T;
        DMove, R+1, C+2, R, C, Col, T;
        DMove, R-1, C+2, R, C, Col, T;
        DMove, R-2, C+1, R, C, Col, T;
        DMove, R-2, C-1, R, C, Col, T;
        DMove, R-1, C-2, R, C, Col, T;
        DMove, R+1, C-2, R, C, Col, T;
        DMove, R+2, C-1, R, C, Col, T) :-
    ichessman(DMove, knight, Col, R, C, T).

% KINGS
guarded(DMove, R+1,  C,    R, C, Col, T;
        DMove, R,    C+1,  R, C, Col, T;
        DMove, R-1,  C+1,  R, C, Col, T;
        DMove, R-1,  C,    R, C, Col, T;
        DMove, R-1,  C-1,  R, C, Col, T;
        DMove, R,    C-1,  R, C, Col, T;
        DMove, R+1,  C+1,  R, C, Col, T;
        DMove, R+1,  C-1,  R, C, Col, T) :-
    ichessman(DMove, king, Col, R, C, T).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INIT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ichessman(dynamicMove(0,0,0,0,0), P, Col, R, C, 1)  :- chessman(P, Col, R, C, 1).
dynamicMove(0,0,0,0,0).
move(0,0,0,0,0).

% 2 kings: 1 white, 1 black
{chessman(king, black, Row, Col, 1) : row(Row), col(Col)} = 1.
{chessman(king, white, Row, Col, 1) : row(Row), col(Col)} = 1.
{chessman(knight, white, Row, Col, 1) : row(Row), col(Col)} = w.
{chessman(knight, black, Row, Col, 1) : row(Row), col(Col)} = b.

#show chessman/5.
% #show move/5.
% % #show ichessman/6.
% #show check/3.
#show checkmate/1.
#show guarded/6.
% #show guarded/7.
% #show color_to_move/2.
#show check/2.
#show check/3.
#show checkmate/1.

#show numDMoves/2.

% :- not checkmate(2).