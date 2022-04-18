---
layout: page
title: Bindings and scopes
---

# Bindings and scopes
{: .no_toc .mb-2 }

- TOC
{:toc}

## Readings

- [Pre-recorded lecture](https://www.youtube.com/playlist?list=PLeIbBi3CwMZx-ypmoxWNxo_OqegclNVAO)
- Chapter 10 of the textbook
- [Introduction to Programming Languages](https://en.wikibooks.org/wiki/Introduction_to_Programming_Languages) entry on scope.

## Overview

- Binding and scopes.
  - Extending the basic expression language with let binders.
  - Evaluating expressions with let binders.
  - Static and dynamic scoping
  - Examples.

- Finite sets in SML
  - Implementing finite sets using lists.
  - Free and bound variables.
  - Closed expressions.

## Binding symbols to values in SML

``` ocaml
val a = 5;
a+3;

fun square x = x*x;
fun double x = x+x;

let val b = 5 in b + 3 end;
b;
```

## Extending our expression language to build states.

We will also use a single datatype containing constants of
different values and make primitive operations on these values
interpretable according to the primitive. For example:

- `3 + 5` would be `Prim("+", IConst 3, IConst 5)`
- `x and y` would be `Prim("and", Var "x", Var "y")`

Thus the expression language would be:

``` ocaml
datatype expr =
         IConst of int
         (* Catch-all for all binary primitive operations *)
         | Prim2 of string * expr * expr
         | Var of string
         (* an operator to bind a variable to a value in an expression *)
         | Let of string * expr * expr;
```

The equivalent expression for the SML expression

``` ocaml
let val z = 17 in z + z end
```

would be

``` ocaml
val e1 = Let("z", IConst 17, Prim2("+", Var "z", Var "z"));
```

## Evaluation of expressions with variables and bindings

``` ocaml
exception FreeVar;

fun lookup [] id = raise FreeVar
  | lookup ((k:string, v)::t) id = if k = id then v else lookup t id;

fun eval (e:expr) (st: (string * expr) list) : int =
    case e of
        (IConst i) => i
      | (Var v) => eval (lookup st v) st
      | (Prim2(f, e1, e2)) =>
        let
            val v1 = (eval e1 st);
            val v2 = (eval e2 st) in
        case f of
            ("+") => v1 + v2
          | ("-") => v1 - v2
          | ("*") => v1 * v2
          | ("/") => v1 div v2
          | _ => raise Match
        end
      | (Let(x, e1, e2)) => (* i.e., let val x = e1 in e2 end *)
        let val v = eval e1 st; (* evaluate e1 in the input state *)
            val st' = (x, IConst v) :: st in (* update the state *)
                eval e2 st'               (* evaluate e2 with new state*)
        end
      | _ => raise Match;

e1;
eval e1 [];
```

### Examples

- The equivalent expression and evaluation for the SML expression
``` ocaml
let val z = 5 - 4 in 100 * z end
```
would be
``` ocaml
val e2 = Let("z", Prim2("-", IConst 5, IConst 4),
             Prim2("*", IConst 100, Var "z"));
eval e2 [];
```

- The equivalent expression and evaluation for the SML expression
``` ocaml
(20 + (let val z = 17 in z + 2 end)) + 30
```
would be
``` ocaml
val e3 = Prim2("+", Prim2("+", IConst 20,
                        Let("z", IConst 17, Prim2("+", Var "z", IConst 2))),
              IConst 30);
eval e3 [];
```

- The equivalent expression and evaluation for the SML expression
``` ocaml
2 * (let val x = 3 in x + 4 end)
```
would be
``` ocaml
val e4 = Prim2("*", IConst 2, Let("x", IConst 3, Prim2("+", Var "x", IConst 4)));
eval e4 [];
```

- The equivalent expression and evaluation for the SML expression
``` ocaml
let val z = 17 in (let val z = 22 in 100 * z end) + z end
```
would be
``` ocaml
val e5 = Let("z", IConst 17,
             Prim2("+", Let("z", IConst 22, Prim2("*", IConst 100, Var "z")),
                  Var "z"));
eval e5 [];
```

- The equivalent expression and evaluation for the SML expression
``` ocaml
let val x = 5 in let val y = 2 * x in let val x = 3 in x + y end end end
```
would be

``` ocaml
val e6 = Let("x", IConst 5,
             Let("y",
                 Prim2("*", IConst 2, Var "x"),
                 Let("x", IConst 3,
                     Prim2("+", Var "x", Var "y"))));
eval e6 [];
```

The evaluation of `e6` is `13` because the value associated with `y` is defined
as soon as it is bound. This is because the scope of `y` is determined
statically, thus the evaluation of its value must be done eagerly. If our
language had a dynamic scope on the other hand the above expression should
evaluate to `9`, since the value to be used for `x` in the definition of `y`
would be determined at the moment `y` is evaluated.

## Evaluation with dynamic scoping

``` ocaml
fun eval (e:expr) (st: (string * expr) list) : int =
    case e of
        (IConst i) => i
      | (Var v) => eval (lookup st v) st
      | (Prim2(f, e1, e2)) =>
        let
            val v1 = (eval e1 st);
            val v2 = (eval e2 st) in
        case f of
            ("+") => v1 + v2
          | ("-") => v1 - v2
          | ("*") => v1 * v2
          | ("/") => v1 div v2
          | _ => raise Match
        end
      | (Let(x, e1, e2)) => eval e2 ((x, IConst (eval e1 st))::st)
      (* We'd achieve dynamic scoping by replacing the above with

      | (Let(x, e1, e2)) => eval e2 ((x, e1)::st)

      *)
      | _ => raise Match;

e6;
eval e6 [];
```

## Evaluating expressions with free variables

To evaluate an expression with free variables we need to start the evaluation
function with a valuation to these variables.

``` ocaml
val e7 = Let("y", IConst 49, Prim2("*", Var "x", Prim2("+", IConst 3, Var "y")));
eval e7 [];
eval e7 [("x", IConst 0)];
eval e7 [("x", IConst 1)];
```

## Checking whether expressions are closed (no free variables)

We will now determine whether expressions are *closed*, i.e., they do not
contain free variables. Only closed expressions can be evaluated without an
initial valuation.

To do this we will first define set operations in SML, then how to compute the
set of free variables of an expression, then write a function that checks
whether that set is empty, in which case the expression will be closed.

### Finite sets in SML

A set can be implemented as a list with no duplicate elements.

- Set membership
`isIn x s is true iff x occurs in s`
``` ocaml
(*  *)
fun isIn x s =
    case s of
        [] => false
      | (h::t) => if x = h then true else isIn x t;
```
- Set union

`(union s1 s2)` takes two lists representing sets and yields a list representing
their union, i.e., a list without duplicates consisting of all the elements of
`s1` and all the elements of `s2`.

``` ocaml
fun union s1 s2 =
    case s1 of
        [] => s2
      | (h::t) => if isIn h s2 then union t s2 else union t (h::s2);
```
- Set difference
`(diff s1 s2)` takes two lists representing sets and
returns a list representing their difference (i.e., returns a list
without duplicates consisting of all elements of `s1` that are not in
`s2`).

``` ocaml
fun diff s1 s2 =
    case s1 of
        [] => []
      | (h::t) => if isIn h s2 then diff t s2 else h::(diff t s2);
```

- Tests

``` ocaml
val s1 = ["x1", "x2"];
isIn "x1" s1;
isIn "y" s1;

val s2 = ["x2", "x3"];

union s1 s2;
diff s1 s2;
```

### Computing the set of free variables

The free variables of an expression are all the variables that are
 *not* bound.

``` ocaml
fun freeVars e : string list =
    case e of
        IConst _ => []
      | (Var v) => [v]
      | (Prim2(_, e1, e2)) => union (freeVars e1) (freeVars e2)
      | (Let(v, e1, e2)) =>
        let val v1 = freeVars e1;
            val v2 = freeVars e2
        in
            union v1 (diff v2 [v]) (* let binds x in e2 but not in e1 *)
        end
      | _ => raise Match;

e1;
freeVars e1;
e2;
freeVars e2;
e3;
freeVars e3;

e7;
freeVars e7;
eval e7 [];
```

### Checking closedness

We can now define the method that checks whether an expression is closed:

``` ocaml
fun closed e = (freeVars e = []);
closed e1;
closed e7;
```

We can now define a method that only evaluates closed expressions

``` ocaml
exception NonClosed;

fun run e =
    if closed e then
        eval e []
    else
        raise NonClosed;

run e1;
run e7;
```

## Generalizing the expression language for Booleans

``` ocaml
datatype expr =
         IConst of int
         | BConst of bool
         (* Catch-all for all binary primitive operations *)
         | Prim2 of string * expr * expr
         (* Catch-all for all unary primitive operations *)
         | Prim1 of string * expr
         | Ite of expr * expr * expr
         | Var of string
         (* an operator to bind a variable to a value in an expression *)
         | Let of string * expr * expr;

fun intToBool 1 = true
  | intToBool 0 = false
  | intToBool _ = raise Match;

fun boolToInt true = 1
  | boolToInt false = 0;

fun eval (e:expr) (st: (string * expr) list) : int =
    case e of
        (IConst i) => i
      | (BConst b) => boolToInt b
      | (Var v) => eval (lookup st v) st
      | (Prim2(f, e1, e2)) =>
        let
            val v1 = (eval e1 st);
            val v2 = (eval e2 st) in
        case f of
            ("+") => v1 + v2
          | ("-") => v1 - v2
          | ("*") => v1 * v2
          | ("/") => v1 div v2
          | ("and") => boolToInt ((intToBool v1) andalso (intToBool v2))
          | ("or") => boolToInt ((intToBool v1) orelse (intToBool v2))
          | _ => raise Match
        end
      | (Prim1("not", e1)) => boolToInt (not (intToBool (eval e1 st)))
      | (Ite(c, t, e)) => if (intToBool (eval c st)) then eval t st else eval e st
      | (Let(x, e1, e2)) => eval e2 ((x, IConst (eval e1 st))::st)
      (* We'd achieve dynamic scoping by replacing the above with

      | (Let(x, e1, e2)) => eval e2 ((x, e1)::st)

      *)
      | _ => raise Match;
```
