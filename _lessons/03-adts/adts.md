---
layout: page
title: Algebraic data types
---

# Algebraic data types
{: .no_toc .mb-2 }

- TOC
{:toc}

## Readings

- [Pre-recorded lecture](https://www.youtube.com/playlist?list=PLeIbBi3CwMZzlXW1WrTxseddFxgmoC3-C)
- Chapter 6 of the textbook
- [Introduction to programming languages, chapter 7](https://en.wikibooks.org/wiki/Introduction_to_Programming_Languages/Algebraic_Data_Types)
- [ADTs introduction slide]({{ site.baseurl }}{% link _lessons/03-adts/adts.pdf %})


## Creating our own types

- Defining a type `day` for days of the week

``` ocaml
datatype day = M | Tu | W | Th | F | Sa | Su;
```

The keyword `datatype` is used to declare an *algebraic data type* (ADT),
defined by a series of *constructors*, which establish how to elements of the
type can be built.

The *algebraic* terminology is used because an ADT can be seen as a [term
algebra](https://en.wikipedia.org/wiki/Term_algebra), with constructors as the
operations to generate the terms for the algebra.

- As we define functions over primitive types, we can define over new types:

``` ocaml
fun isWeekend x = x = Sa orelse x = Su;
```

- ADTs naturally model unions

``` ocaml
datatype element = I of int | F of real;

fun getReal (F x) = x
  | getReal (I x) = real x;
```

Note that above the constructors of `element` are functions:

``` ocaml
I : int -> element
F : real -> element
```

They take values of types `int` and `real` and *construct* values of type
`element`.

## Defining a Boolean algebra

The Boolean algebra as two values, `True` and `False`, and operations for
conjunction (`AND`), disjunction (`OR`), and complement (`NOT`).

We can define a type whose elements correspond to those of a Boolean algebra.

``` ocaml
datatype Proposition =
     True
    | False
    | Not of Proposition
    | And of Proposition * Proposition
    | Or of Proposition * Proposition;
```

Note that `Proposition`'s definition is *inductive*, i.e., with `True` and
`False` as the base elements all other elements are built via applications of
the constructors `Not`, `And`, `Or` over elements of `Proposition`. For example:

``` ocaml
val prop0 = True;
val prop1 = Not prop0;
val prop2 = Or (prop0, prop1);
```

And so on.

We can define an evaluation function that build a correspondence between
elements of `Proposition` and SML's Boolean values `true` and `false`:

``` ocaml
fun eval True = true
  | eval False = false
  | eval (Not x) = not (eval x)
  | eval (And (x,y)) = (eval x) andalso (eval y)
  | eval (Or (x,y)) = (eval x) orelse (eval y);

eval prop2;
```

## Defining a binary tree

An ADT that represents a binary tree with internal nodes labeled with integer
values and non-labeled leaves:

``` ocaml
datatype btree =
         Leaf
         | Node of (btree * int * btree);

val e = Leaf
val t3 = Node(e,3,e)
val t5 = Node (e, 5, e)
val t9 = Node (t3,9,t5)
val t4 = Node(t9,4,e)
```

Note that `t4` corresponds to

```
      (4)
      / \
    (9) ()
    / \
   /   \
 (3)   (5)
 / \   / \
() () () ()
```

- A helper function to build elements of `btree`

``` ocaml
fun newTree n = Node (Leaf, n, Leaf);

newTree 10
```

- How to extract the value of the root node of some `t : btree` if `t` is a
  non-empty tree?


``` ocaml
fun rootValue (Node (_, v, _)) =  v;

t3
rootValue t3

rootValue e
```

- How to extract the left subtree of some `t : btree` if `t` is a
  non-empty tree?

``` ocaml
fun leftChild (Node (t, _, _)) = t

t3
leftChild t3

t9
leftChild t9
```
- A function that returns `true` iff an integer `n` occurs in some `t : btree`?

``` ocaml
fun occurs _ (Leaf) = false
  | occurs n (Node (t1, m, t2)) = (m = n) orelse (occurs n t1) orelse (occurs n t2)

t4
occurs 10 t4
occurs 9 t4
```

- A function that "inserts" an integer `n` in some `t : btree` so that all nodes
  to the left have a smaller or equal value?

``` ocaml
fun insert n (Leaf) = newTree n
  | insert n (Node (t1, m, t2)) =
    if (n < m) then
        Node (insert n t1, m, t2)
    else
        Node (t1, m, insert n t2)
```

Which gives us:

``` ocaml
val s = Node (Leaf, 3, Node (Leaf, 6, Leaf))
```

```
  (3)
 /   \
()   (6)
    /   \
   ()   ()
```

``` ocaml
val s1 = insert 4 s
```
```
  (3)
 /   \
()   (6)
    /   \
  (4)   ()
 /   \
()   ()
```

``` ocaml
val s2 = insert 5 s1
```
```
  (3)
 /   \
()   (6)
    /   \
  (4)   ()
 /   \
()   (5)
    /   \
   ()   ()
```

- How to collect all labels in `t : btree` into a list?

``` ocaml
fun traverse (Leaf) = []
  | traverse (Node (t1, m, t2)) =
    let val l1 = traverse t1;
        val l2 = traverse t2
    in
        l1 @ [m] @ l2
    end;
```

# Exercises

Given an ADT

```ocaml
datatype btree = L of int | Node of btree * int * btree;
```

- Write a function `size : btree -> int` that computes the number of internal
  nodes in a tree.


<details>
<summary>Solution</summary>
<p>

{{
"```ocaml
fun size (L(_)) = 0
  | size (Node(t1, _, t2)) = (size t1) + 1 + (size t2);

size (Node(Node(L(0),1,L(2)), 3, Node(L(4),5,Node(L(6),7,L(8)))));
```"
| markdownify}}

</p>
</details>

- Write a function `mirror : btree -> btree` which takes a tree `t` and returns
the *mirror image* of `t`, that is, the tree obtained from `t` by swapping every
left subtree with its corresponding right subtree.  For example,

```
mirror (Node (Node (L 0, 1, L 1),
              3,
              Node (L 0, 4, Node (L 1, 7, L 2))) )
```

is

```
       Node (Node (Node (L 2, 7, L 1), 4, L 0),
             3,
             Node (L 1, 1, L 0),
             )
```

<details><summary>Solution</summary>
<p>

{{
"```ocaml
fun mirror (L n) = L n
  | mirror (Node (t1, n, t2)) = Node (mirror t2, n, mirror t1);

mirror (Node (Node (L 0, 1, L 1),
              3,
              Node (L 0, 4, Node (L 1, 7, L 2))) );
```"
| markdownify}}

</p>
</details>
