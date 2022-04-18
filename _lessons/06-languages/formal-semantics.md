---
layout: page
title: Formal semantics
---

# Formal semantics
{: .no_toc .mb-2 }

- TOC
{:toc}

## Readings

- [Pre-recorded lecture: Operational semantics](https://youtube.com/playlist?list=PLeIbBi3CwMZziVG93gcNT__X_xmmtM8ir)
- [Pre-recorded lecture: Lambda calculus](https://youtube.com/playlist?list=PLeIbBi3CwMZxFVZX1yGTiGiJO7gWd4YJ5)
- [Operational semantics](http://www.cs.uiowa.edu/~slonnegr/plf/Book/Chapter8.pdf), Sections Seções 8.5 (you can ignore "completeness and consistency") and 8.6.
- [Introduction to Programming Languages](https://en.wikibooks.org/wiki/Introduction_to_Programming_Languages), entry on semantics.

- [The lambda calculus](http://www.cs.uiowa.edu/~slonnegr/plf/Book/Chapter5.pdf), Sections 5.1, 5.2 (pag. 139 to 159).

### Recommended readings

- [Semantics with applications: an appetizer](https://www.springer.com/gp/book/9781846286919), Chapters 1 and 2.
- [A bit on the history of computing](http://www.people.cs.uchicago.edu/~soare/History/turing.pdf), Chapters 1-3.
- [A Minimalistic Verified Bootstrapped Compiler](https://popl21.sigplan.org/details/CPP-2021/6/A-Minimalistic-Verified-Bootstrapped-Compiler-Proof-Pearl-):
  A recent paper on writing a simple compiler with a full formal semantics that is *verified correct*, i.e., proves that the x86 assembly code it produces is equivalent to the original code.

## Overview

- *Syntax* defines what the programs we write look like, while *semantics*
  defines their meaning.

- The semantics of a language `L1` can be defined via a interpreted for `L1` in
  another language `L2` with a well-defined semantics.

  - Note this is the approach we've taken with our [expression language]({{
    site.baseurl }}{% link _lessons/06-languages/ast-evals.md %}), using SML as
    the interpreter language.

  - However, how do we define the semantics of `L2`?

- There are formal notations to define the semantics of programming languages. A
  common way is with *operational semantics*:
  - Specifies, step by step, what happens while a program is executed.

- [Writing on the board (in recording) for operational semantics]({{ site.baseurl }}{% link _lessons/06-languages/formal-semantics.png %})
- [Writing on the board (in recording) for lambda calculus]({{ site.baseurl }}{% link _lessons/06-languages/lambda-calculus.png %})

## Operational semantics

- The specification of an execution is step is given by *inference rules*

- *Judgements* for writing inference rules:
  - Premises are written above the line.
  - Conclusion below the line.
  - Label by the lines denote the rule name
  - Arrows represent how expressions are evaluated.

- Considering the expressions in the basic version of our [previously defined language]({{ site.baseurl }}{% link _lessons/06-languages/ast-evals.md %}), their semantics is:

```
 E1 -> v1      E2 -> v2              E1 -> v1      E2 -> v2
------------------------ EvPlus     -------------------------- EvMinus
Plus(E1, E2) -> v1 + v2             Minus(E1, E2) -> v1 - v2

------------- EvIConst
IConst n -> n
```

- The above establishes how expressions built with `IConst`, `Plus` and `Minus`
are evaluated, i.e., in terms of the semantics of the arithmetic functions `+`,
`-`.
    - Note this is not dependent on a programming language but on arithmetic
      itself.

### Big step and small step semantics

- The above is often called "big step semantics" (also "natural semantics")
- There is also "small step semantics", in which a rule does only one
  computation ("one step") at a time:

```
          E1 -> E1'                             E1 -> E1'
-----------------------------EvPlus1      ---------------------------------EvMinus1
Plus(E1, E2) -> Plus(E1', E2)             Minus(E1, E2) -> Minus(E1', E2)

          E2 -> E2'                             E2 -> E2'
-----------------------------EvPlus2      ---------------------------------EvMinus2
Plus(E1, E2) -> Plus(E1, E2')             Minus(E1, E2) -> Minus(E1, E2')


---------------EvIConst
IConst n -> n

-----------------------EvPlusV   -------------------------EvMinusV
Plus(v1, v2) -> v1 + v2           Minus(v1, v2) -> v1 - v2
```

### How to define the semantics of `Ite`?

- Let's go back to use big step semantics.
- Since `Ite` relies on Boolean expressions, we must define their semantics as well.

 ```
 E1 -> v1      E2 -> v2              E1 -> v1      E2 -> v2
------------------------EvAnd     --------------------------EvMinus
And(E1, E2) -> v1 ∧ v2               Or(E1, E2) -> v1 v v2

                                    E -> v
-------------EvBConst             ---------------EvNot
BConst n -> n                       Not(E) -> ¬v1
```

- Now we can define the rules for `Ite`
```
E1 -> true       E2 -> v2                E1 -> false      E3 -> v3
-------------------------EvIteT   or     --------------------------EvIteF
  Ite(E1, E2, E3) -> v2                   Ite(E1, E2, E3) -> v3
```

Note that the above rules rely on Boolean logic itself.

### Evaluation as derivation trees

- Evaluating an expression corresponds to bulding a *derivation tree*
  - the root of the tree is the evaluation of the original expression
  - the premises must be roots of subtrees justifying their evaluations and so on

- The derivation tree below corresponds to the evaluotion of `Plus(IConst 0, Minus(IConst 3, IConst 2))`

```
                       -------------EvIConst  -------------EvIConst
                       IConst 3 -> 3          IConst 2 -> 2
-------------EvIConst  --------------------------------------EvMinus
IConst 0 -> 0          Minus(IConst 3, IConst 2) -> 3 - 2 = 1
--------------------------------------------------------------EvPlus
  Plus(IConst 0, Minus(IConst 3, IConst 2)) -> 0 + 1 = 1
```

### Static vs dynamic semantics

- Static semantics: program meaning known at compilation time.
  - Type errors
  - Use of undefined variables

- Dynamic semantics: program meaning known at run time
  - Memory management errors can be very hard to detect statically.

#### Program equivalence

- With a formal semantics we can reason statically about programs
- We can for example possibly prove that two programs are equivalent
  - To say that two programs `P1` and `P2` are equivalent:
  ```
P1 -> v iff P2 -> v
  ```
  i.e., they produce the same value *when they produce some value*. Such proofs
  can be done in general via induction on the derivation trees that can be built
  with the inference rules used to evaluate the expression.

- Let's consider the following program equivalence problem, for programs in our
  expression language with the above semantics. Prove that

```
Ite(c,e1,e2) = Ite(Not(c),e2,e1)
```
  for *any* expression `c`, `e1`, `e2` (of the correct types for the constructor `Ite`).


- Since `c` is a Boolean expression, it can be evaluated either to `true` or to
  `false`. We consider each case:
  - Case 1: `c -> true`

    The derivation of `P1` will be:
```
...            ...
---------      --------
c -> true       e1 -> v
------------------------EvIteT
  Ite(c, e1, e2) -> v
```

    Since `c -> true`, we know that
```
...
---------
c -> true
----------------EvNot
Not(c) -> false
```

thus the derivation of `P2` will be
```
...
---------
c -> true                  ....
----------------EvNot    --------
Not(c) -> false           e1 -> v
----------------------------------EvIteF
  Ite(Not(c), e2, e1) -> v
```

  - Case 2: `c -> false`
  Try it yourself. :)
<details>
<summary>Solution</summary>
<p>

{{
"
The derivation of `P1` will be:
```
...            ...
---------      --------
c -> false      e2 -> v
------------------------EvIteF
  Ite(c, e1, e2) -> v
```
Since `c -> false`, we know that
```
...
---------
c -> false
----------------EvNot
Not(c) -> false
```

thus the derivation of `P2` will be
```
...
---------
c -> false                  ....
----------------EvNot    --------
Not(c) -> true           e2 -> v
----------------------------------EvIteT
  Ite(Not(c), e2, e1) -> v
```"
| markdownify}}

</p>
</details>


- In all generality one needs to consider as well the non-terminating executions:
```
P1 -> stuck iff P2 -> stuck
```
  for some notion of "stuck".


## The Lambda Calculus

- The lambda calculus is a notation to describe computations

  - It offers a precise formal semantics for programming languages.

- The [Church-Turing thesis](https://en.wikipedia.org/wiki/Church%E2%80%93Turing_thesis):

  - The lambda calculus is as powerful as Turing machines.

  - In other words, these are equivalent models of computation, i.e., of
    defining *algorithms*.

  - Turing and Church indepedently proved, in 1936, that:
    - program termination is undecidable (with Turing machines)
    - program equivalence is undecidable (with lambda calculus)

  - Thus both showed that the
    [*Entscheidungsproblem*](https://en.wikipedia.org/wiki/Entscheidungsproblem),
    to David Hilbert's dismay, is unsolvable.
    - There are undecidable problems. There are problems which we *cannot*
    solve, for every instance of the problem, with algorithms.

  - Both built on Kurt Gödel's [incompleteness
    theorems](https://en.wikipedia.org/wiki/G%C3%B6del%27s_incompleteness_theorems),
    which first showed the limits of mathematical logic.

### Notation

The lambda calculus consists of writing λ-expressions and reducing
them. Intuitively it is a notation for writing functions and their applications.

A λ-expression is either:
- a variable
```
x
```

- an abstraction ("a function")
```
λx . x
```
in which the variable after the lambda is called its *bound variable* and the
expression after the dot its *body*.

- an application ("of a function to an argument")
```
(λx . x) z
```

in which the right term is the argument of the application. When written without
parenthesis assume left-associativity.

This means that λ-expressions follow the syntax:

```
<expr> ::= <name>
         | (\lambda <name> . <expr>)
         | (<expr> <expr>)
```

Expressions can be manipulated via reductions. Intuitively they correspond to
computing with functions.

### Beta (β-reduction)

- Captures the idea of function application.
- It is defined via substitution:
  - an application is β-reduced via the replacement, in the body of the
  abstraction, of all occurrences of the bound variable by the argument of the
  application.

- Consider the example application above:
```
(λx . x) z
=>_β
z
```

Intuitively `(λx . x)` corresponds to the *identity function*: whatever
expression it is applied to will be the result of the application.

### Alpha (α-conversion)

- Renames bound variables.
```
(λx . x)
=>_α
(λy . y)
```

- Expressions that are only different in the names of their bound variables are
  called *α-equivalent*.
  - Intuitevely, the names of the bound variables do not change the meaning of the function.
  - For example, both `(λx . x)` and `(λy . y)` correspond to the identity function.

### Free and bound variables

- Not all renaming is legal.
```
(λx . (λy . y x))
=>_α
(λy . (λy . y y))
```
- This renaming changes what the function computes, as `x` was renamed to a
  variable, `y`, that was *not free* in the body of the expression.
  - As an example, consider the following SML code:

  ``` ocaml
  val y = 1
  fun f1 x = y + x
  fun f2 z = y + z
  fun f3 y = y + y
  ```
  You will note that `f1` and `f2` are equivalent, while `f1` and `f3` are not.


- Free variables are those that are *not* bound by any lambda prefix enclosing it.
  ```
  (λw . z w)
  ```
   - In the body of the expression `w` is bound while `z` is free.

### Capture-avoiding substitutions

- To avoid the above issue, α-conversion must be applied with *capture-avoiding*
  substitutions:
  - When recursively traversing the expression to apply the substitution, if the
    range of the substitution contains a variable that is bound in an
    abstraction, rename the bound variable so that the free variable is not
    *captured*.
  - In the above example, to do a substitution of `x` by `y` on `(λ x . (λ y . y x))`, written
  ```
  (λx . (λy . y x))[x:=y]
  ```

  we will do `(λ y . y x)[x:=y]`. Since `y` is bound in the expression in which
  we are doing the substitution, we rename the bound variable to avoid capture:
  ```
  (λy . y x) =>_α (λz . z x)
  ```

   Now we can do `(λz . z x)[x:= y]` so that the variable `x`, which is free
   in this expression, remains so after substitution. Thus we obtain:
   ```
   (λx . (λy . y x))
   =>_α
   (λy . (λz . z y))
   ```
   which are equivalent functions.

- The same principle applies to β-reduction: it is applied with capture-avoiding
  substitutions to avoid issues with capture.

### Encodings

- With λ-expressions and β-reduction we can do *all computation*. Every
  algorithm that exists.
- The caveat: you must first encode in λ-expressions whatever you mean.

### Numbers (Church numerals)

- Encodings are about conventions. We agree on the meaning of something and build accordingly.
- A number is a function that takes a function `s` plus a constant `z`. The number `N` corresponds to `N` applications of `s` to `z`.

```
Zero  = λs. λz. z
One   = λs. λz. s z
Two   = λs. λz. s (s z)
Three = λs. λz. s (s (s z))
...
```
#### The successor function

```
SUCC = λn. λy. λx. y (n y x)
```

- If we apply the successor function to `Zero` we must obtain `One`:
```
SUCC Zero =
  (λn.λy.λx.y(nyx))(λs.λz.z) =>_β
  λy.λx.y((λs.λz.z)yx) =>_β
  λy.λx.yx =
One
```
- Similarly, we should obtain that `SUCC One = Two`
```
SUCC One =
  (λn.λy.λx.y(nyx))(λs.λz.sz) =>_β
  λy.λx.y((λs.λz.sz)yx) =>_β
  λy.λx.y(yx) =
Two
```
And so on. One can prove via induction that `Succ N` is always equal to the
corresponding natural number of `N` plus one.

#### Addition

```
ADD = λm.λn.λx.λy.m x (n x y)
```

- Again we can see the expected behavior with examples:
```
ADD Two Three =
 (λm.λn.λx.λy.m x (n x y)) Two Three =>_β
 λx.λy.Two x (Three x y) =>_β
 λx.λy.Two x (x (x (x y))) =>_β
 λx.λy.(λs.λz.s (s z)) x (x (x (x y))) =>_β
 λx.λy.x (x (x (x (x y)))) =
Five
```
- Note that addition can be defined in terms of the successor function
- Summing `n` with `m` corresponds to applying the successor function `n` times to `m`.
  - Our number encoding is precisely "number `N` is applying function `s` to constant `z` `N` times", i.e.,
  ```
  ADD = λm. λn. m SUCC n
  ```

- Rephrasing the above example:
```
ADD Two Three =
 Two SUCC Three =
  (λs.λz.s (s z)) SUCC Three =>_β
  (λz. SUCC (SUCC z)) Three =>_β
  SUCC (SUCC Three) =>_β
  SUCC Four =>_β
Five
```
The above is enough to encode
[Presburger arithmetic ](https://en.wikipedia.org/wiki/Presburger_arithmetic).
- One can encode anything we are used to do with computers.

Note that all complexity lies in *how to encode*. Once the encoding is done,
computation is merely doing β-reduction.


### Boolean algebra (Church Booleans)

```
T  = λx.λy.x
F = λx.λy.y
AND   = λx.λy.xyF
OR    = λx.λy.xTy
NOT   = λx.xFT
```

- Try it yourself

```
AND T F = ?
```

<details>
<summary>Solution</summary>
<p>

{{
"```
AND T F =
(λx.λy.xyF) T F =>_β
T F F =
(λx.λy.x) F F =>_β F
```"
| markdownify}}

</p>
</details>

```
OR F T = ?
```
<details>
<summary>Solution</summary>
<p>

{{
"```
OR F T
(λx.λy.xTy) F T =>_β
F T T =
(λx.λy.y) T T =>_β T
```"
| markdownify}}

</p>
</details>

```
NOT T = ?
```

<details>
<summary>Solution</summary>
<p>

{{
"```
NOT T
(λx.xFT) T =>_β
T F T =
(λx.λy.x) F T =>_β F
```"
| markdownify}}

</p>
</details>



<!-- ### Eta (η-reduction) -->

<!-- - Captures the idea of *extensionality*: functions are equal if and only if they -->
<!--   always produce the same result on all arguments. -->

<!-- - The intuition is that an abstraction can be lifted when its application -->
<!--   corresponds to the application of the expression within it -->

<!-- ``` -->
<!-- (λ x . f x) -->
<!-- =>_η -->
<!-- f -->
<!-- ``` -->
<!-- if `f` does not contain `x` free. -->
