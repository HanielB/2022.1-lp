myappend([], L, L).
myappend([Head|TailA], B, [Head|TailC]) :- myappend(TailA, B, TailC).

mymember(X, [X|_]).
mymember(X, [_|Y]) :- member(X, Y).
