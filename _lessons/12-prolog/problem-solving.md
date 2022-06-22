---
layout: page
title: Problem solving with Prolog
---

# Problem solving with Prolog
{: .no_toc .mb-2 }

- TOC
{:toc}

## Readings

- [Pre-recorded lecture](https://youtube.com/playlist?list=PLeIbBi3CwMZyVoCL1iEY5WTG1Sz22aSs6)
- [99 Problems in Prolog](https://www.ic.unicamp.br/~meidanis/courses/mc336/2009s2/prolog/problemas/).
- Math in Prolog chapter from [Introduction to Programming
  Languages](https://en.wikibooks.org/wiki/Introduction_to_Programming_Languages).

## The `findall` predicate

How would we compute all the subsets of a set (represented as a list)?

``` prolog
subSet([], []).
subSet([H|T], [H|R]) :- subSet(T, R).
subSet([_|T], R) :- subSet(T, R).
```

The fact establishes that the empty set (i.e., the empty list) is a subset. The
first rule that a subset contains the first element of the set and possibly some
of the other elements. The third rule that ignoring one element of a set (the
head of the list), a subset will be contained in the set of the remaining
elements.

Thus for example

``` prolog
?- subSet([1,2],S).
S = [1, 2] ;
S = [1] ;
S = [2] ;
S = [].
```

in which the first unifier is built in a refutation based on two resolutions
with the rule `subSet([H|T], [H|R]) :- subSet(T, R).` and one with the fact
`subSet([], []).`; the second unifier based on one resolution with the first
rule, one with the second rule (`subSet([H|T], [H|R]) :- subSet(T, R).`), and
one with the fact; the third unifier based on one resolution with second rule,
one with the first rule, and one with the fact; and, finally, the last unifier
is based on two resolutions with the second rule and one with the fact.

How would we compute the power set of a set? The power set of a set is the set
of all of its subsets. So for this we would need to collect all the unifiers for
the second argument of `subSet` that make it hold. Luckily, Prolog has a useful
pre-defined predicate providing this, `findall`.

The predicate takes three arguments:
- a term `T`
- a predicate `P`
- a term `R`

The interpretation of `findall` is such that all the instantiations of `T`,
which would be generated in making `P` hold, are added to a list and unified
with `R`.

We can thus write a power set predicate as

``` prolog
powerSet(S, P) :- findall(SS, subSet(S, SS), P).
```

since for each possible way in which `subSet(S, SS)` can hold the respective
instantiation for `SS` will be accumulated in a list, which will be unifier with
`P` when all possibilities are exhausted.

### All the permutations of a list

``` prolog
perm([], []).
perm(List, [H|Perm]) :- select(H, List, Rest), perm(Rest, Perm).
```

Similarly to the power set, we can compute all the permutations of a list by
combining `findall` with `perm`:

``` prolog
allPerm(L, R) :- findall(P, perm(L, P), R).
```

## The eight-queens problem

The [eight-queens problem](https://en.wikipedia.org/wiki/Eight_queens_puzzle) is
a classic puzzle: how to place eight queens in an 8x8 chees board such that no
two queens threaten each other? Using Prolog we can solve this problem not
bothering how to actually solve them: it suffices to encode in Prolog the
restrictions for a possible solution and let its unification + resolution
machinery compute the solution for us.

From the chess rules, a solution for the eight-queens problem must be such no
two queens share the same row, column or diagonal.

### Representing a configuration of the board (and the column test)

A configuration of the board is where the eight queens are positioned in it. We
thus need eight positions to represent a configuration. Since queens cannot
share columns, there must be one queen in each column. We can start from that
when representing possible legal configurations.

Using a list of integers, from 1 to 8, with each position in a list representing
in which row the queen of the respective column is, we can represent a
configuration.

For example, `[4,2,7,3,6,8,5,1]` means that the queen in the first column is in
row 4, the queen in the second column in the row 2 and so on.

### The row test

Queens cannot share rows. Since we represent the row a queen is on in a
configuration with a number from 1 to 8, it must be the case that there are no
repetitions in a configuration and that all from 1 to 8 occur. This is to say
that a configuration must be a permutation of of the numbers from 1 to 8.

### The diagonal test

A queen placed at column `X` and row `Y` occupies two diagonals: one from
bottom-left to top-right and one from top-left to bottom-right. We name these
diagonals: the former is the diagonal `C = X - Y` and the latter is the diagonal
`D = X + Y`.

So we can define the diagonal test predicate as follows:

``` prolog
test([], _, _, _).
test([Y|Ys], X, Cs, Ds) :-
    C is X-Y, \+ member(C, Cs),
    D is X+Y, \+ member(D, Ds),
    X1 is X + 1,
    test(Ys, X1, [C|Cs], [D|Ds]).
```

which is such that given a configuration `Q` the predicate `test(Q, 1, [], []).`
holds, if, for each queen, its diagonals have not been previously occupied. The
predicate `\+` is true if and only if its argument cannot be shown to hold.

### Generating all possible configurations

All possible configurations of the board amount to all possible permutations of
a list. Thus we can build a solution to the eight queens problem by:

``` prolog
queen8(Q) :- perm([1,2,3,4,5,6,7,8], Q), test(Q, 1, [], []).
```

### How many solutions exist for the eight-queens problem?

How do we find all solutions? Or how de we count all solutions? We can rely
again on `findall`:

``` prolog
allQueen8(A) :- findall(Q, queen8(Q), A).
countAllQueen8(C) :- allQueen8(A), length(A, C).
```

- How would you write a Prolog solution for the N-queen problem?

## Sudoku

How would you solve [sudoku](https://en.wikipedia.org/wiki/Sudoku) in Prolog?
Check problem 97
[here](https://www.ic.unicamp.br/~meidanis/courses/mc336/2009s2/prolog/problemas/).

A solution is available
[here](https://www.swi-prolog.org/pldoc/man?section=clpfd-sudoku) using a
library in Prolog good for encoding combinatorial problems.
