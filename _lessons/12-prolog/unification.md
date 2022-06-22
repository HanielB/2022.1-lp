---
layout: page
title: Unification and Resolution
---

# Unification and Resolution
{: .no_toc .mb-2 }

- TOC
{:toc}

## Readings

- [Pre-recorded lecture](https://www.youtube.com/playlist?list=PLeIbBi3CwMZyH6P_Jboge8kSvUXUCeORz)
- [Writing on the board]({{ site.baseurl }}{% link _lessons/12-prolog/unification.png %}) during class
- [Tutorial sobre unificação em Prolog](http://www.amzi.com/AdventureInProlog/a10unif.php) (faça os exercícios)
- [Unification in first-order logic](https://en.wikipedia.org/wiki/Unification_(computer_science)#Syntactic_unification_of_first-order_terms)
- [Occurs check](https://en.wikipedia.org/wiki/Occurs_check)
- [Resolution](https://en.wikipedia.org/wiki/Resolution_(logic))
- [SLD Resolution](https://en.wikipedia.org/wiki/SLD_resolution)

### Recommended readings

- [LeanCop](http://www.leancop.de/), a first-order logic theorem prover in
  Prolog that fits into a business card.

## Unification

The concept of unification comes from first-order logic: given two terms `s` and
`t`, to *unify* them means to find a *substitution* `σ` over their free
variables such that `sσ = tσ`. A substitution unifying two terms is called a
*unifier* for them.

Some examples of unification queries in Prolog terms:

``` prolog
?- a = b.
?- f(X, b) = f(a, Y).
?- f(X, b) = g(X, b).
?- a(X, X, b) = a(b, X, X).
?- a(X, X, b) = a(c, X, X).
?- a(X, f) = a(X, f).
```

For each one, if there is a substitution for the varibales of terms that makes
them equal, we have that substitution as a result, otherwise we have `false`.
For example, in the first query the terms `a` and `b` have no variables. Since
they are not equal, it's impossible to unify them and the result is `false`.

## A unification algorithm

A unification algorithm to solve the unification problem can be relatively
straightforward. Starting with a *unification pair* `<s, t>` and an empty substitution :

1. if `s` is `f(s1, ..., sn)` and `t` is `g(t1, ..., tn)`, no unification is possible
2. if `s` is `f(s1, ..., sn)` and `t` is `f(t1, ..., tn)`, unify `<s1, t1>`, ..., `<sn, tn>`
3. if `s` is a variable `X`, then add to the substitution `{X = t}`
4. if `t` is a variable `X`, then add to the substitution `{X = s}`

## Most general unifier

There may exist many unifiers for a given unification problem. An important
concept is that of the *most general unifier* (mgu). Given two terms `s` and
`t`, their most general unifier `σ` is a unifier such that if there exists
another unifier `θ` for these terms then `θ=σρ`, for some substitution `ρ`. This is to say: `θ` is a specialization of `σ`

Consider the unification problem

``` prolog
?- parent(X, Y) = parent(kim, Y).
```

and assume it has these two solutions: `{X = kim}` and `{X = kim, Y = holly}` in
the current context. The most general unifier is the first substitution, since
every other unifier (like the second substitution here) necessarily will be also
instantiating `Y` and is thus a specialization of the mgu, which only
instantiates `X`.

## Occurs check

The algorithm above has a serious issue: it can lead to bogus
solutions. Consider the unification pair `<X, f(X)>`. With the above algorithm
the solution would be `{X = f(X)}`, which does not solve the unification
problem, since applying this substitution transforms `X` into `f(X)` but `f(X)`
into `f(f(X))`.

To avoid this, unification algorithms implement another rule, the *occurs
check*. It tests whether the variable to be made equal to a term occurs in this
term. So in this example the occurs check would fail since `X` occurs in `f(X)`.

In Prolog however this test is ommitted (not in all interpreters, though) for
reasons of ecciciency: checking whether a variable occurs in a term has
complexity linear in the size of the term. So for example:

``` prolog
?- f(X) = f(f(X)).
```

can yield the solution `X = f(X)`. One can avoid this wrong behavior using the
binary predicate `unify_with_occurs_check`, which performs the correct (but more
expensive) unification algorithm. So for example:

``` prolog
?- unify_with_occurs_check(f(X), f(f(X))).
```

yields `false`.

## Resolution

The other central component of how a Prolog program runs is
*resolution*. Resolution is an inference rule such that, given two *clauses*
(i.e., disjunctions) containing complementary unifiable *literals* (i.e., an
atom or its negation), produces a new clause by taking the literals of the two
clauses, except for the complementary ones, and applying the unifier on
them. For example


```
q(X) v ~p(X)           p(f(Y)) v r(Z)
-------------------------------------- RESOLUTION_σ
        q(f(Y)) v r(Z)
```
in which `σ` is `{X = f(Y)}`, which unifies `~p(X)` and `p(fY)`.

Prolog programs are composed of facts, rules and queries. We view them as
clauses in the following way:

- A fact is a clause in itself, with the respective fact being the only literal
  in the clause (known as a *unit clause*).

- A rule has the shape `G :- P`, meaning that if `P` holds so does `G`. Since
  this has the shape of an implication `P ⇒ G`, it's equivalent to write as `~P
  v G`, which is a clause. Note that `~P v G` can always be transformed into a
  clause with [conjunctive normal
  form](https://en.wikipedia.org/wiki/Conjunctive_normal_form) (CNF)
  transformation.

- A query is an arbitrary formula that can be turned into a clause with CNF
  transformation.

### Refutations

When writing a query in Prolog we want to know if the facts and the rules of
your program allow that query to hold, i.e., whether the facts `F` the rules `R`
together entail the query `Q`. This can be written as a logical formula `(F ∧ R)
⇒ Q`, which is equivalent to `(F ∧ R) v ~Q ⇒ false`. Showing that a series of
formulas together imply false is called a *refutation proof*.

Using resolution, facts, rules and queries, a Prolog computation works in the
following manner:

1. Negate the query.
2. Using the negation of the query, the facts and the rules, apply resolution
   until the empty clause (equivalent to `false`) is derived.

Let's consider again the example with the [parent.pl]({{ site.baseurl }}{% link
_lessons/12-prolog/parent.pl %}) program and the query

``` prolog
?- parent(margaret,X), parent(X, holly).
```

The negation of this query is the clause `not(parent(margaret,X)); not(parent(X,
holly))`. Considering the first literal `not(parent(margaret,X))`, there are two candidate resolutions:

1.
```
not(parent(margaret,X)); not(parent(X,holly))        parent(margaret, kent).
---------------------------------------------------------------------------- RESOLUTION_{X = kent}
                 not(parent(kent,holly))
```

2.
```
not(parent(margaret,X)); not(parent(X,holly))        parent(margaret, kim).
---------------------------------------------------------------------------- RESOLUTION_{X = kim}
                 not(parent(kim,holly))
```

The first resolution results in a clause on which we can apply no other
resolutions. However we can do another resolution with the second one:

3.
```
not(parent(kim,holly))        parent(kim, holly).
------------------------------------------------- RESOLUTION_{}
                 false
```

Since we derive `false` we have built a refutation for the negation of the
query, which means that he query is valid.

### Another example

Consider again the definition of `append` (for short, let's use the `@` symbol):

``` prolog
@([], L, L).
@([H|Ta], B, [H|Tc]) :- @(Ta, B, Tc).
```

How do we build a refutation for the query `@(X, Y, [1, 2])`?
