
ancestor(X, Y) :- parent(Z, Y), ancestor(X, Z).
ancestor(X, Y) :- parent(X, Y).

parent(kim, holly).
parent(margaret, kim).
parent(margaret, kent).
parent(esther, margaret).
parent(herbert, margaret).
parent(herbert, jean).
parent(kent, jean).

grandparent(GP, GC) :- parent(P, GC), parent(GP, P).

greatGrandParent(GGP, GGC) :- parent(P, GGC), grandparent(GGP, P).

sibling(X, Y) :- parent(P, X), parent(P, Y), not(X=Y).
