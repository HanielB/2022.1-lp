---
layout: page
title: Prolog Introduction
---

# Prolog Introduction
{: .no_toc .mb-2 }

- TOC
{:toc}

## Readings

- [Pre-recorded lecture](https://www.youtube.com/playlist?list=PLeIbBi3CwMZw3XQhb0hwQVSxamEJhF_TO)
- [Class notes]({{ site.baseurl }}{% link _lessons/12-prolog/prolog-intro.pdf %}) on Prolog Introduction.
- [A linguagem Prolog](http://en.wikipedia.org/wiki/Prolog)
- O manual [SWI Prolog](http://www.swi-prolog.org/pldoc/refman/). Vocês provavelmente usarão este ambiente de desenvolvimento.
- [Programação Lógica em Prolog](http://www.cs.uiowa.edu/~slonnegr/plf/Book/AppendixA.pdf).
- Prolog code: [parent.pl]({{ site.baseurl }}{% link _lessons/12-prolog/parent.pl %}), [list.pl]({{ site.baseurl }}{% link _lessons/12-prolog/list.pl %}), [riddle.pl]({{ site.baseurl }}{% link _lessons/12-prolog/riddle.pl %})


## Logic programming

Prolog is a logic programming language, i.e., its programs consist of of a *set*
of *facts* and *logic rules*. Computation happens by deriving new facts from
these rules. Since facts are a set, the order in which they are given is
irrelevant.

Prolog was developed in France in the early 1970s by Alain Colmeraeur and
Philippe Roussel. It was first intended for natural language processing, but
throughout the years has been applied in many other fields, as it is well-suited
for any application amenable to rule-based logical queries.

## Terms

Prolog statements are written using *terms*. A term is either:

- an atom: is an identifier, starting with lower case, without a predetermined
  meaning. E.g.: atom, x, y.
- a number: a float or integer string. E.g.: 123, -5.5.
- a variable: an identifier, starting with upper case, or an underscore. They
  are placeholders for arbitrary terms. E.g.: X, Var, _
- a composite term: an atom followed by a sequence of terms between
  parentheses. E.g.: x(Y, Z), x(y, Z).

## Facts

A fact is written as a term followed by a period: `parent(kim, holly).`

Writing a fact establishes that something *holds*, i.e., is true. In the above
`kim` and `holly` are atoms and `parent` is a *predicate*, a function that is
true when applied to `kim` and `holly`.

We can start writing a Prolog program by writing a series of facts:

``` prolog
parent(kim, holly).
parent(margaret, kim).
parent(margaret, kent).
parent(esther, margaret).
parent(herbert, margaret).
parent(herbert, jean).
```

A file with the above program, say `parent.pl`, can be loaded into `swipl`, a
Prolog interpreter, with

``` prolog
?- [parent].
```
which will evaluate the terms within it, letting the Prolog interpreter know that these facts hold.

## Queries

One can then interact with the interpreter with *queries*:

``` prolog
?- parent(kim, holly).
?- parent(kim, X).
?- parent(X, Y).
?- parent(Y, esther).
```

Note that in querying terms with variables the interpreter will *instantiate*
free variables with terms so that the *ground* predicate (one without variables)
holds. Pressing space or typing `;` (the symbol for disjunction) yields another
instantiation, if any.

``` prolog
?- parent(X,margaret).
X = esther ;
X = herbert.
```

Queries can be written as sequences of terms, conjunctively or disjunctively:

``` prolog
?- parent(margaret,X), parent(X, holly).
?- parent(margaret,X); parent(X, holly).
```

We can start getting creative: how to query whether `esther` has a great-grandchild?

``` prolog
?- parent(esther, C), parent(C, GC), parent(GC, GGC).
```

For this query to hold, all predicates must hold. For each to hold, the
variables must be assigned terms so that the respective ground predicate holds. There is only one way:

``` prolog
C = margaret,
GC = kim,
GGC = holly
```

## Rules

A rule specifies how new facts can be derived once some conditions are met.

``` prolog
greatGrandparent(GGP, GGC) :- parent(GGP, GP), parent(GP, P), parent(P, GGC).
```

The term to the left of `:-` is true if the term to the right is true. Rules can
be seen as definitions for predicates: the `greatGrandparent` predicate holds
for terms `GGP` and `GGC` when `GGP` has a child who has a child who is `GGC`.

Rules can be composed:

``` prolog
grandparent(GP, GC) :- parent(GP, P), parent(P, GC).
greatGrandparent(GGP, GGC) :- grandparent(GGP, P), parent(P, GGC).
```

Note that the order is irrelevant. The above is equivalent to

``` prolog
greatGrandparent(GGP, GGC) :- grandparent(GGP, P), parent(P, GGC).
grandparent(GP, GC) :- parent(GP, P), parent(P, GC).
```

Rules can be defined recursively:

``` prolog
ancestor(X, Y) :- parent(X, Y).
ancestor(X, Y) :- parent(Z, Y), ancestor(X, Z).
```

If we were to define a siblings predicate we could do:

``` prolog
sibling(X,Y) :- parent(P,X), parent(P, Y).
```

However note that `X` and `Y` can be instantiated to the same term, which does
not correctly model our intuition of when the `sibling` predicate should
hold. We can change it to:

``` prolog
sibling(X,Y) :- parent(P,X), parent(P, Y), not(X=Y).
```

## Lists

Prolog has built-in list terms. One write lists as terms separated by commas
within square brackets.

``` prolog
?- X = [1, haniel, true].
?- [1,2|X] = [1,2,3,4,5].
```

### Appending

We can define a predicate that appends two lists:

``` prolog
append([], L, L).
append([Head|TailA], B, [Head|TailC]) :- append(TailA, B, TailC).
```

The first rule (a fact) defines the base case, in which appending the empty list
to another list `L` is `L` itself. The second rule, from a non-empty list
`[Head|TailA]` and another list `B`, builds the list `[Head|TailC]` whose head
is the head of the first list and the tail is the result of appending the tail
of the first list with the second list.

``` prolog
?- append([1,2,3], [4,5,6], X).
?- append(X, Y, [1,2,3]).
```

### Membership

We can define a `member` predicate:

``` prolog
member(X, [X|_]).
member(X, [_|Y]) :- member(X, Y).
```

A term is part of a list if it's equal to its head (first rule), otherwise it's
necessary to search in its tail (second rule).

``` prolog
?- member(2, [1,2,3]).
?- member(2, [X,2,3]).
?- member(2, [1,X,3]).
?- member(4, [1,2,3]).
?- member(X, [1,2,3]).
?- member(1, X).
```

### Selection

We can define a `select` predicate such that `select(E, L1, L2)` is true if and only if
`L2` is the same as `L1`, minus an element `E`:

``` prolog
select(X, [X|L], L).
select(X, [H|L], [H|LR]) :- select(X, L, LR).
```

If the element is the head of the list, the result is its tail (first
rule). Otherwise the result is the selection of the elemen in the tail of the
list (second rule). If the list is empty the predicate is false.

``` prolog
?- select(2, [1,2,3], Z).
?- select(2, [1,3], Z).
?- select(X, [1,2,3], [2,3]).
?- select(X, [1,2,3], Y).
```

### Reverse

``` prolog
reverse([], []).
reverse([H|T], X) :- reverse(T, XAux), append(XAux, [H], X).
```

``` prolog
?- reverse([1, 2, 3], L).
```

What is the expected result of `?- reverse(L, [1, 2, 3]).`? The second argument
of the `reverse` predicate is the reverse of the first argument. Therefore for
this query to hold `L` must be the reverse of `[1, 2, 3]`.

### Permutation

We can define a predicate `perm` such that `perm(T, L)` is true iff `L` is a
permutation of the list `T`:

``` prolog
perm([], []).
perm(T, [H|LL]) :- select(H, T, L1), perm(L1, LL).
```

## Puzzle

How to use Prolog to solve the [Wolf, goat and
cabbage](https://en.wikipedia.org/wiki/Wolf,_goat_and_cabbage_problem) problem?
A detailed solution is available
[here](https://cseweb.ucsd.edu/classes/wi09/cse130/misc/prolog/goat_etc.html).
