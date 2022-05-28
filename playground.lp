ichessman(0, P, Col, R, C, 1)  :- chessman(P, Col, R, C, 1).
time(2).
row(1..3).
col(1..3).
enemy(black, white; white, black).
chessman(knight, black, 1,1,1).
chessman(king, white, 1,3,1).
move(1,1,3,2,1).

% KNIGHTS
guarded(
    DMove, R+2, C+1, R, C, Col, T;
    DMove, R+1, C+2, R, C, Col, T;
    DMove, R-1, C+2, R, C, Col, T;
    DMove, R-2, C+1, R, C, Col, T;
    DMove, R-2, C-1, R, C, Col, T;
    DMove, R-1, C-2, R, C, Col, T;
    DMove, R+1, C-2, R, C, Col, T;
    DMove, R+2, C-1, R, C, Col, T) :-
    
    ichessman(DMove, knight, Col, R, C, T).

dynamicMove(R, C, R', C', T) :- chessman(_, _, R, C, T), guarded(_, R', C', R, C, _, T), row(R'), col(C').
{move(R, C, R', C', T-1) : dynamicMove(R, C, R', C', T-1)} =1 :- time(T). 

chessman(P, Col, R', C', T+1) :- 
    chessman(P, Col, R, C, T), 
    move(R, C, R', C', T).

chessman(P, Col, R, C, T+1) :- 
    chessman(P, Col, R, C, T), 
    move(R0, C0, R1, C1, T),
    (R, C) != (R0, C0), 
    (R, C) != (R1, C1).

ichessman(DMove, P, Col, R', C', T) :- 
    DMove = dynamicMove(R, C, R',C',T-1),
    dynamicMove(R,C, R',C',T-1),
    chessman(P, Col, R, C, T-1).

ichessman(DMove, P, Col, R, C, T) :- 
    DMove = dynamicMove(R0, C0, R1,C1,T-1),
    dynamicMove(R0,C0, R1,C1,T-1),
    chessman(P, Col, R, C, T-1),
    (R, C) != (R0, C0), 
    (R, C) != (R1, C1).

check(DMove, Col, T) :-
    DMove = dynamicMove(R0, C0, R',C',T-1),
    dynamicMove(R0,C0, R',C',T-1),
    ichessman(DMove, king, Col, RK, CK, T),
    enemy(Col, Ecol),
    guarded(DMove, RK, CK, _, _, ECol, T).

% #show chessman/5.
% #show move/5.
% #show ichessman/6.
% #show guarded/7.
#show check/3.