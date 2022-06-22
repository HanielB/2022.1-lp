change(e, w).
change(w, e).

move([X,X,Goat,Cabbage], wolf, [Y,Y,Goat,Cabbage]) :- change(X,Y).
move([X,Wolf,X,Cabbage], goat, [Y,Wolf,Y,Cabbage]) :- change(X,Y).
move([X,Wolf,Goat,X], cabbage, [Y,Wolf,Goat,Y]) :- change(X,Y).
move([X,Wolf,Goat,Cabbage], nothing, [Y,Wolf,Goat,Cabbage]) :- change(X,Y).

oneEq(X, X, _).
oneEq(X, _, X).
%% goat eats cabbage if alone
%% wolf eats goat if alone

%% if man is on the same bank as cabbage/goat and in the same bank as
%% wolf/goat, then the former enforces that goat does not eat cabbage
%% and the latter that wolf does not eat goat.
safe([Man, Wolf, Goat, Cabbage]) :-
  oneEq(Man,Goat,Cabbage),
  oneEq(Man,Wolf,Goat).

solution([e,e,e,e], []).
solution(Config, [Move|Rest]) :-
  move(Config,Move,NextConfig),
  safe(NextConfig),
  solution(NextConfig, Rest).
