
row(1..n).
col(1..n).
time(1..k).
itime(1..k+1).
color(white).
color(black).
enemy(white, black).
enemy(black, white).

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

numLMoves(T,N):-
    time(T),
    color_to_move(T,Col),
    {legalMove(_,_,_,_,T)} = N.


% chessman that moved
ichessman(DMove, P, Col, R',C',T+1) :- 
    itime(T+1),
    dynamicMove(R,C,R',C',T),
    DMove = dynamicMove(R,C,R',C',T),
    chessman(P,Col,R,C,T).
    % if it's white to move at time T then only evaluates the successor to the move picked
    % move(R,C,R',C',T):color_to_move(T, white).

% add to the set of chessmen at t+1 all the men who have not moved.
ichessman(DMove, P, Col, R, C, T+1) :-
    itime(T+1),
    dynamicMove(R0, C0, R1, C1, T),
    DMove = dynamicMove(R0, C0, R1, C1, T),
    (R, C) != (R0, C0), % the chessman cannot be the one who moved
    (R, C) != (R1, C1), % the chessman cannot be the one being taken
    chessman(P, Col, R, C, T),
    color(Col).
    % move(R0, C0, R1, C1, T):color_to_move(T, white).


% for all time before a checkmate there must be a move made.
{move(R,C,R',C',T) : legalMove(R,C, R',C',T)}=1 :- % , row(R), col(C), row(R'), col(C')
    time(T),
    % color_to_move(T, black),
    T<N : checkmate(N).

% real chessmen are created for the selected dynamicMove. 
chessman(P, Col, R', C', T) :- 
    time(T),
    move(DMove, T-1),
    ichessman(DMove, P, Col, R', C', T).

% helper predicate to extract the previous concrete DMove
move(dynamicMove(MR, MC, MR', MC',T), T) :- 
    % dynamicMove(MR, MC, MR', MC',T),
    move(MR, MC, MR', MC',T).

% a piece can never move such that its king is in check the next timestep
legalMove(R, C, R', C', T) :- 
    dynamicMove(R, C, R', C', T), 
    not check(dynamicMove(R, C, R', C', T), Col, T+1), 
    time(T),
    color_to_move(T,Col),
    not chessman(_,Col,R',C',T).

dynamicMove(R, C, R', C', T) :- 
    color_to_move(T,Col), 
    chessman(_,Col,R,C,T), 
    guarded(DMove,R',C',R,C,_,T), 
    row(R'), col(C'),
    itime(T),
    move(DMove, T-1).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CONSTRAINTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% it cannot be the case that there is more than 1 chessman on a square
:-  ichessman(DMove,P,Col,R,C,T),
    ichessman(DMove,P',Col',R',C',T),
    (P,Col)!=(P',Col'), % different piece
    (DMove, R,C)==(DMove, R',C'), % same location
    itime(T).

guarded(R',C',R,C,Col,T) :-
    time(T),
    move(DMove, T-1),
    guarded(DMove, R',C',R,C,Col,T).

check(Col, T) :-
    time(T),
    move(DMove, T-1),
    check(DMove,Col,T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INIT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ichessman(dynamicMove(0,0,0,0,0), P, Col, R, C, 1)  :- chessman(P, Col, R, C, 1).
dynamicMove(0,0,0,0,0).
move(0,0,0,0,0).

piece(knight;bishop;rook;queen).

% 2 kings: 1 white, 1 black
{chessman(king, black, Row, Col, 1) : row(Row), col(Col)} = 1.
{chessman(king, white, Row, Col, 1) : row(Row), col(Col)} = 1.
0{chessman(Piece, white, Row, Col, 1) : row(Row), col(Col), piece(Piece)}w.
0{chessman(Piece, black, Row, Col, 1) : row(Row), col(Col), piece(Piece)}b.

#show chessman/5.
#show move/5.
% #show ichessman/6.
% #show check/3.
#show checkmate/1.
#show guarded/6.
% #show guarded/7.
% #show color_to_move/2.
#show check/2.
% #show check/3.
#show checkmate/1.
#show numDMoves/2.
% #show dynamicMove/5.
#show numLMoves/2.
