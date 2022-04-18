---
layout: page
title: Syntax and semantics
---

# Syntax and semantics
{: .no_toc .mb-2 }

- TOC
{:toc}

## Readings

- [Pre-recorded lecture](https://www.youtube.com/playlist?list=PLeIbBi3CwMZzxem8S2aFUUqD5zkaWXYLB)
- Chapters 2, 3 of the textbook
- [Introduction to Programming Languages](https://en.wikibooks.org/wiki/Introduction_to_Programming_Languages), entries on syntax, grammars in practice, and interpreted programs.

## Languages

[Writing on the board in the recording](https://homepages.dcc.ufmg.br/~hbarbosa/teaching/ufmg/2020-1/lp/notes/07-syntax-semantics-writing.png)

## Abstract syntax trees

An algebraic datatype whose values correspond to abstract syntax trees of arithmetic expressions:

``` ocaml
datatype expr = IConst of int | Plus of expr * expr | Minus of expr * expr;
```

An integer constant expression:

``` ocaml
val e1 = IConst 17;
```

The expression `3 - 4`, whose AST is

```
  -
 / \
3  4
```
is the value

``` ocaml
val e2 = Minus(IConst 3, IConst 4);
```

The expression

```
       -
      / \
      +  6
     / \
    23  5
```

is

``` ocaml
val e3 = Minus(Plus(IConst 23, IConst 5), IConst 6);
```

## Evaluation

Evaluating arithmetic expressions.

``` ocaml
fun eval (IConst i) = i
  | eval (Plus(e1, e2)) = (eval e1) + (eval e2)
  | eval (Minus(e1, e2)) = (eval e1) - (eval e2);

e1;
eval e1;

e2;
eval e2;

e3;
eval e3;
```

Evaluating arithmetic expressions with a "cutoff subraction", i.e. one that
only produces non-negative results.

``` ocaml
fun eval2 (IConst i) = i
  | eval2 (Plus(e1, e2)) = (eval2 e1) + (eval2 e2)
  | eval2 (Minus(e1, e2)) =
    let val res = (eval2 e1) - (eval2 e2) in
        if res < 0 then
            0
        else
            res
    end;

e1;
eval2 e1;
e2;
eval2 e2;
e3;
eval2 e3;
```

Note that `expr + eval2` is a **different** language than `expr + eval`. Even
though their ASTs are the same their semantics differ.

## Extending expression language: Booleans

We can further extend our expression language to encompass Boolean expressions
and conditionals.

``` ocaml
datatype bexpr = BConst of bool | Not of bexpr | And of bexpr * bexpr | Or of bexpr * bexpr;

val b1 = BConst false;
val b2 = Not b1;
```

An evaluator for Boolean expressions:

``` ocaml
fun evalb (BConst b) = b
  | evalb (Not b) = not (evalb b)
  | evalb (And(b1, b2)) = (evalb b1) andalso (evalb b2)
  | evalb (Or(b1, b2)) = (evalb b1) orelse (evalb b2);

evalb b1;
evalb b2;
```

Abstract syntax tree for (conditional) arithmetic expressions:

``` ocaml
datatype aexpr =
         IConst of int
         | Plus of aexpr * aexpr
         | Minus of aexpr * aexpr
         | Ite of bexpr * aexpr * aexpr;

val e1 = IConst 17;
val e2 = Plus(e1, Minus(IConst 10, IConst 30));
val e3 = Ite(b1, e1, e2);
val e4 = Ite(b2, e1, e2);
```

An evaluator for (conditiotional) arithmetic expressions:

``` ocaml
fun evala (IConst i) = i
  | evala (Plus(e1, e2)) = (evala e1) + (evala e2)
  | evala (Minus(e1, e2)) = (evala e1) - (evala e2)
  | evala (Ite(c, t, e)) =  if (evalb c) then (evala t) else (evala e);

e1;
evala e1;
e2;
evala e2;
e3;
evala e3;
e4;
evala e4;
```

## Extending expression language: Variables

We can further expand our language to include *variables*.

``` ocaml
datatype aexpr =
         IConst of int
         | Plus of aexpr * aexpr
         | Minus of aexpr * aexpr
         | Ite of bexpr * aexpr * aexpr
         | Var of string;

val e1 = Var "x";
val e2 = Plus(IConst 17, e1);
```

To evaluate expressions with variables we need to be able to associate them
with values. To this we will need a notion of *state*, for example by means of an
*association list*, i.e.

``` ocaml
lists of type ('a * 'b) list
```

which can be seen as maps/dictionaries with keys of type `'a` and values of type
`'b`.

By building such lists from variable identifiers (strings) to values (IConst i)
we will be able to map variables to values and thus evaluate expressions with
variables.

``` ocaml
val state = [("x", IConst 3), ("y", IConst 78), ("z", IConst 676)];
```

We define a helper function to look for values in an association list:

``` ocaml
fun lookup [] id = raise Match
  | lookup ((k:string, v)::t) id = if k = id then v else lookup t id;

lookup state "x";
lookup state "z";
lookup state "w";
```

Evaluation now takes an expression and a state.

``` ocaml
fun eval (IConst i) _ = i
  | eval (Var x) state = eval (lookup state x) state
  | eval (Plus(e1, e2)) state = (eval e1 state) + (eval e2 state)
  | eval (Minus(e1, e2)) state = (eval e1 state) - (eval e2 state)
  | eval (Ite(c, t, e)) state = if (evalb c) then (eval t state) else (eval e state);


e1;
e2;
eval e1 state;
eval e2 state;
```

How to extend the language to allow bulding a state *during* evaluation?
