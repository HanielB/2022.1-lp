---
layout: page
title: Pattern matching
---

# Pattern matching
{: .no_toc .mb-2 }

- TOC
{:toc}

## Readings

- [Pre-recorded lecture](https://www.youtube.com/playlist?list=PLeIbBi3CwMZwDfs__URUz4wudPCuDuIS2)
- [Pattern matching](http://en.wikipedia.org/wiki/Pattern_matching/) article

## Introduction

- Previously we saw basic elements of ML
- Now we will see how to build programs
- We build programs in ML using functions:

  - How to get the first character of a list?

    ``` ocaml
    fun firstChar s = hd (explode s);
    firstChar "abc";
    ```
  - How does ML find the type of the function?
    - type inference

- Every function in SML takes exactly one parameter:

  ``` ocaml
  fun quot(a,b) = a div b;

  quot (6,2);

  val pair = (6,2);

  quot pair;
  ```

- Functions are commonly written using pattern matching

  - A pattern is a expression that can be matched against other expression **of
    the same type** by instantiating its variables (sometimes called
    "wildcards").

    ``` ocaml
      fun firstChar s = hd (explode s)
    ```

    The pattern here is itself a variable of type string, which means that s
    can be matched against any expression that is a string.

    ``` ocaml
      firstChar "abc"
    ```

    This works because we can build the substitution s -> "abc", thus
    evaluating

    ``` ocaml
      hd (explode s){s -> "abc"} = hd (explode "abc")
    ```

    - However we can write any expression a pattern. For example:

    ``` ocaml
        fun f (a, b) = a * b;
    ```
      can be applied to any pair of integers.

    - However

       ``` ocaml
fun f (0, a) = a*1;
       ```

      can only be applied to pairs of integers where the first element is a
      constant equal to 0. Any expression that is *not* like that will not be
      succesfully matched against the pattern, impossibilatating the application
      of f to it.

       ``` ocaml
       f (0, 1);
       f (1, 1);
       ```

    - Note we cannot define

       ``` ocaml
       fun f (0.0, a) = a*1;
       ```

      This pattern from the previous one in that it's a tuple `real * int`
      rather than `int * int`. The constant in the pattern is not of an equality
      type, which impossibilitates the matching algorithm of working, as it
      relies on comparing that the constant value in the respective positions
      are equal.

- Patterns can be used more generally. For example

  ``` ocaml
  val (x, y) = (4, "asdf");
  val (x, y) = ([2,3,4], ("dcc024", 3.14));
  val [x, y, z] = [1,2,3];
  ```

- Note that above we are using the type constructiors (of tuples) to *decompose*
  an expression and refer to subexpressions. Another example:

  ``` ocaml
  fun f (x::xs) = x;

  f [1,2,3];
  ```

- We do not need to name elements of the pattern that we do not care about:

  ``` ocaml
fun f (x::_) = x;
  ```

  - Note this pattern matches againts any expression that (x::xs) does, except
    that we are not naming the tail of list.

- How to implement a function that returns the second element of a list?

  ``` ocaml
fun f (_::x::_) = x;
  ```

- Which patterns have we seen so far?
  - A variable is a pattern that matches anything, and binds to it.
  - A `_` is a pattern that matches anything.
  - A constant (of an equality type) is a pattern that matches
    only that constant.
  - A tuple of patterns is a pattern that matches any tuple of the
    right size, whose contents match the sub-patterns.
  - A list of patterns is a pattern that matches any list of the
    right size, whose contents match the sub-patterns.
  - A cons `::` of patterns is a pattern that matches any nonempty
    list whose head and tail match the sub-patterns.

# Functions with multiple patterns

- A function may have many patterns:

``` ocaml
fun f 0 = "zero"
  | f 1 = "one"
```

- A common way of making sure one covers all matching cases is adding a
  "catch-all" case:

``` ocaml
fun f 0 = "zero"
  | f 1 = "one"
  | f _ = "whatever"
```

- Note that the above could be written via conditional expressions:

``` ocaml
fun f n = if n = 0 then "zero" else if n = 1 then "one" else "whatever";
```
- How to write the factorial function using pattern matching?

``` ocaml
fun fact 0 = 1
  | fact n = n * fact (n-1);
```

- How to write the reverse function?

``` ocaml
fun rev nil = nil
  | rev (h::t) = rev t @ [h];
```

- A function to sum up the elements of a list

``` ocaml
fun sum [] = 0
  | sum (h::t) = h + sum t;
```

- A function that takes a pair of elements, and returns true if they are the
  same?

  One might be tempted to write

  ``` ocaml
  fun f (a,a) = true
    | f (a,_) = false;
  ```

  but note this will yield a `duplicate variable in pattern` error. This is
  because SML, in order to facilitate its pattern matching, forbids reusing the
  same variable. Why do you think this is so?

  - A correct way of defining the requested function would be

  ``` ocaml
  fun f (a, b) = if a = b then true else false;
  ```

  Note however that this is much more verbose then necessary. It's pointless to
  define a conditional expression who returns true if the condition holds and
  false otherwise. This can be written much more clearly as

  ``` ocaml
  fun f (a, b) = a = b;
  ```

- Another useful construct in SML is defining local variables a `let` block:

``` ocaml
let val x = 1 val y = 2 in x + y end;
```
Where note that x and y are not defined outside of the let block.

- How to write a function that converts days to miliseconds?

``` ocaml
fun days2ms days =
  let
    val hours = days * 24.0
    val minutes = hours * 60.0
    val seconds = minutes * 60.0
  in
    seconds * 1000.0
  end;
```

- How to write a function to compute the n-th Fibonacci number?

``` ocaml
fun fib 0 = 0
  | fib 1 = 1
  | fib n = fib (n-1) + fib (n-2) ;
```
  - Note this solution is not optimal. The computation of `fib (n-2)` will be
    repeated for both `fib n` and `fib (n-1)`, for any `n` bigger than 1.

  - How to make it more efficient?
