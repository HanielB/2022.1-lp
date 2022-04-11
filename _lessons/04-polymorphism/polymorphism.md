---
layout: page
title: Polymorphism
---

# Polymorphism
{: .no_toc .mb-2 }

- TOC
{:toc}

## Readings

- [Pre-recorded lecture](https://www.youtube.com/playlist?list=PLeIbBi3CwMZwmgIVh73e1zWAvMfxiuZkR)
- Chapter 8 of the textbook
- [Examples of polymorphism in C++ code](https://homepages.dcc.ufmg.br/~hbarbosa/teaching/ufmg/2020-1/lp/notes/05-polymorphism-c++.cpp)
- [Introduction to Programming Languages, entries on polymorphism](https://en.wikibooks.org/wiki/Introduction_to_Programming_Languages)


## Parametric types in SML

``` ocaml
datatype ilist = E | L of int * ilist;

val l = L(1, L(2, L(3, E)));

(* returns the first element of a non-empty ilist *)
fun first (L(h, _)) = h
  | first E = raise Match;

first l;
first E;
```

## Returning the rest of a non-empty ilist

``` ocaml
fun rest (L(_, t)) = t
  | rest E = raise Match;

rest l;

fun last E = raise Match
  | last (L(h, E)) = h
  | last (L(h, t)) = last t;

last l;
```

## A parametric list

``` ocaml
datatype 'a plist = E | L of 'a * 'a plist;

fun first (L(h, _)) = h
  | first E = raise Match;

fun rest (L(_, t)) = t
  | rest E = raise Match;

fun last E = raise Match
  | last (L(h, E)) = h
  | last (L(h, t)) = last t;

val l1 = L(1.0, L(2.0, E));
val l2 = L(1, L(2, E));

first l1;
first l2;

rest l1;
rest l2;

last l1;
last l2;

fun id x = x;
id l1;
id l2;

fun toTriple x y z = (x,y,z);
toTriple 1 2.0 (L(1,L(3,E)));
toTriple 1 2.0 (L(1,L(3,L(9,L(27,E)))));
```


## Overloading in SML

``` ocaml
val a = 1 + 2;

val b = 1.0 + 2.0;
```

## Equality-testable types

``` ocaml
type T0 = int * real;

type T1 = int * real;

fun foo (s1:T1) (s2:T0) = (#1 s1, #2 s2);

val x1:T0 = (1, 3.0);
val x2:T1 = (2, 4.0);

foo x1 x2;

val ll1 = L(x2,E);
val ll2 = L(x1, ll1);

first ll1;
first ll2;
```

## Paremeter coercion

``` ocaml
fun maxAux n E = n
  | maxAux n (L(h, t)) = if h > n then maxAux h t else maxAux n t;

fun max E = raise Match
  | max (L(h, t)) = maxAux h t;

fun inlinedMax E = raise Match
  | inlinedMax (L(h,t)) =
    let fun inlineMaxAux n E = n
          | inlineMaxAux n (L(h,t)) =
            if h > n then inlineMaxAux h t else inlineMaxAux n t;
    in
        inlineMaxAux h t
    end;

max l1;
max l2;

inlinedMax l1;
inlinedMax l2;

fun max (a,b) = if a > b then a else b;
```

## Examples of polymorphism in C++

```c++
#include <iostream>

template <class X> X max(X a, X b)
{
  return a > b ? a : b;
}

class MyInt
{
  friend std::ostream& operator<<(std::ostream& os, const MyInt& m)
  {
    os << m.data;
    return os;
  }

  friend bool operator>(MyInt& mi1, MyInt& mi2) { return mi1.data > mi2.data; }

 public:
  MyInt(int i) : data(i) {}

 private:
  const int data;
};

int main()
{
  std::cout << max<int>(5, 3) << std::endl;
  std::cout << max<char>('a', 'b') << std::endl;
  std::cout << max<MyInt>(MyInt(5), MyInt(3)) << std::endl;
}
```
