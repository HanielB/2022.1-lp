---
layout: page
title: Higher-order functions
---

# Higher-order functions
{: .no_toc .mb-2 }

- TOC
{:toc}

## Readings

- [Pre-recorded lecture](https://www.youtube.com/playlist?list=PLeIbBi3CwMZyLPWOzBEkBu15ng1F2eIvX)
- Chapter 11 of the textbook
- [Introduction to Programming Languages](https://en.wikibooks.org/wiki/Introduction_to_Programming_Languages), entries on Higher-Order functions.


## Higher-order functions

- The order of a function is defined in terms of the order of their parameter and return types.

  f0 : A                           (Order 1, constant function)
  f1 : A1 x ... x An -> A          (Order 1, function with constant parameters and return)
  f2 : (A1 -> A2) x A3 x ... -> A  (Order 2, function with order 1 parameter)
  f2 : A1 x ... x An -> (A -> A)   (Order 2, function with order 1 return)
  ...

- Functions are "first-class values". Functions with functional
  parameters or return values are higher-order functions.

  Examples of functional variables

  Examples of ananymous functions

- Currying

  Functions may be partially applied, yielding other functions.

  Naturally simulate arity higher than one.

- Examples

```ocaml
val a = 10;

fun f x = x + a;
f 5;

val h = f;
f 5;
h 5;

fun g x = 2 * x;

val p = (f,g);

val l = [f,g];

fun app (f,x) = f x;
app (hd l, 5);
```

## Anonymous functions

```ocaml
val f2 = fn x => ~x;

f2 3;
(fn x => ~x) 3;
```

## Multiple arguments

``` ocaml
fun f0 (x,y) = x + y;
f0(1,2);

fun f1 x = fn y => x + y;
f1 1 2;
```

## Currying

Function application is left-associative, so

  ``` ocaml
  f 1 2 is actually (f 1) 2
  ```

and `(f1 1)` above corresponds to

``` ocaml
(fn y => 1 + y)
```
- Examples

``` ocaml
f1 1;

val add1 = f1 1;
add1 2;
add1 5;

fun f2 x = fn y => fn z => x + y + z;
f2 1 2 3;
f2 3 4 5;

fun f3 x y z = x + y + z;
f3 1 2 3;
f3 3 4 5;

f2;
f3;
```

## Combinators

``` ocaml
fun compose f g x = f (g x);

fun f x = x + a;
fun g x = 2 * x;
val l = [f,g];
hd (tl l) 5;

compose hd tl l 5;
(compose hd tl l) 5;
```

## Map

``` ocaml
map;

map ~ [1,2,3];

map (fn x => ~x) [1,2,3];

map (fn x => x ^ " ") ["a", "b", "c"];

fun mymap _ [] = []
  | mymap f (h::t) = (f h) :: (mymap f t);

mymap ~ [1,2,3];

mymap (fn x => x + 1) [1,2,3];
mymap add1 [1,2,3];
mymap ((fn x => fn y => x + y) 1) [1,2,3];

mymap (op +) [(1,2),(3,4),(5,6)];

map (op +);
```

## Fold (left)

``` ocaml
foldl (op +) 0 [1,2,3];

foldl;

fun add (x,y) = x + y;
foldl add 0 [1,2,3];
foldl (fn (x,y) => x + y) 0 [1,2,3];

foldl (op ^) "" ["a","b","c"];
```

- What is going on?

``` ocaml
("c" ^ ("b" ^ ("a" ^ "")))

foldl ^ ""           ("a"::"b"::"c"::[])
foldl ^ ("a" ^ "")   ("b"::"c"::[])
foldl ^ "a"          ("b"::"c"::[])
foldl ^ ("b" ^ "a")  ("c"::[])
foldl ^ "ba"         ("c"::[])
foldl ^ ("c" ^ "ba") []
foldl ^ "cba"        []
"cba"
```

- Defining our own `foldl`

``` ocaml
fun myfoldl _ acc [] = acc
  | myfoldl f acc (h::t) = myfoldl f (f h acc) t;

myfoldl (fn x => fn y => x ^ y) "" ["a","b","c"];
```

## Fold (right)

```ocaml
foldr;
foldr (fn (x,y) => x ^ y) "" ["a","b","c"];
```

- What is going on?

``` ocaml
("a" ^ ("b" ^ ("c" ^ "")))

foldr ^ ""           ("a"::"b"::"c"::[])
"a" ^ (foldr ^ "" ("b"::"c"::[]))
"a" ^ ("b" ^ (foldr ^ "" ("c"::[]))
"a" ^ ("b" ^ ("c" ^ (foldr ^ "" []))
"a" ^ ("b" ^ ("c" ^ ""))
"abc"
```

- Defining our own `foldr`

``` ocaml
fun myfoldr _ acc [] = acc
  | myfoldr f acc (h::t) = f h (myfoldr f acc t);

myfoldr (fn x => fn y => x ^ y) "" ["a","b","c"];

fun concat l = foldr (op ^) "" l;
concat ["a","b","c"];

fun concatReverse l = foldl (op ^) "" l;
concatReverse ["a","b","c"];

fun append l1 l2 = foldr (op ::) l2 l1;
append [1,2] [3,4];

fun reverse l = foldl (op ::) [] l;
reverse [1,2,3];
```

## Filter

``` ocaml
fun filter _ [] = []
  | filter p (h::t) = if p h then h::(filter p t) else filter p t;

fun pos x = x > 0;
pos 1;
pos ~1;

filter pos [1,~2,3,~4];

foldr (fn (x,y) => if pos x then x::y else y) [] [1,~2,3,~4];

fun otherfilter p l = foldr (fn (x,y) => if p x then x::y else y) [] l;
otherfilter pos [1,~2,3,~4];
```
