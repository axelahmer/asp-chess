% testing:
%#const set_of_pieces = (king;queen;rook;bishop;knight;pawn).
#const t = 5.

file(1..8).
rank(1..8).
time(1..t).

board(T) :- {square(F,R,P,T)}, file(F), rank(R), time(T).

{square(F,R,P) : P = piece(A,B) }=1 :- file(F), rank(R).

piece((king;queen;rook;bishop;knight;pawn),(white;black)).


% sebastians queen example from week 1:

% row(1..n).  col(1..n).  % in logic programming
% cell(I, J) :- row(I), col(J).

% {queen(I,J): cell(I, J)} = 8.

% % no horizontal or vertical attacks
% :- queen(I, J), queen(I, J2), J != J2.
% :- queen(I, J), queen(I2, J), I != I2.

% % no diagonals attacks
% :- queen(I1, J1), queen(I2, J2), 
%   (I1, J1) != (I2, J2), diagonal(I1, J1, I2, J2).

% diagonal(I1, J1, I2, J2) :- 
% cell(I1, J1), cell(I2, J2), 
% |I2-I1| = |J2-J1|.



% closed knight tour program:

% xchessboard(1..n).
% ychessboard(1..m).
% time(1..n*m+1).
% xypos(X,Y) :- xchessboard(X), ychessboard(Y).
% fromTO(X1,Y1,X2,Y2) :- xypos(X1,Y1), xypos(X2,Y2),
% |X1-X2| = 1, |Y1-Y2| = 2.
% fromTO(X1,Y1,X2,Y2) :- xypos(X1,Y1), xypos(X2,Y2),
% |X1-X2| = 2, |Y1-Y2| = 1.
% 1 { position(I,X,Y) : xypos(X,Y) } 1 :- time(I).
% :- time(I), time(I+1), xypos(X1,Y1), xypos(X2,Y2),
% position(I,X1,Y1), position(I+1,X2,Y2), not
% fromTO(X1,Y1,X2,Y2).
% :- time(I1-1), time(I2), I1 < I2, xypos(X,Y),
% position(I1,X,Y), position(I2,X,Y).
% :- position(1,X,Y), X+Y>2.
% :- position(n*m+1,X,Y), X+Y>2.