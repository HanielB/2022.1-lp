---
layout: page
title: Memory management
---

# Memory management
{: .no_toc .mb-2 }

- TOC
{:toc}

## Readings

- Chapters 12 and 13 of textbook.
- [Class notes]({{ site.baseurl }}{% link _lessons/08-memory/memory.pdf %}) on memory management.
- [Numerous memory management techniques](http://www.ibm.com/developerworks/linux/library/l-memory/)
- [Garbage collection](http://en.wikipedia.org/wiki/Garbage_collection_(computer_science))
- [Valgrind](http://en.wikipedia.org/wiki/Valgrind)

## Topics covered

- Memory management. Static and dynamic memory management. Stack and heap.

- Memory management for the heap. Placement, splitting, coalescing.

- Errors from wrong memory use. Memory leaks and dangling pointers.

- Garbage collection. Mark and sweep. Copying collector. Reference counting.

## Stack vs Heap

Another example (other than the one in the beginning of the slides in the
Readings) to showcase the difference between stack and heap memories. Consider
the following modified version of that example:

``` c++
#include <iostream>
int global_var = 7;
void foo(int** ptr)
{
  *ptr = (int*)malloc(5 * sizeof(int));
  int auto_var = 9;
  (*ptr)[0] = global_var;
  (*ptr)[1] = auto_var;
}
int main()
{
  int* ptr;
  std::cout << "Global var : " << global_var << std::endl;
  foo(&ptr);
  ptr[2] = ptr[1] + global_var;
  std::cout << "Pointer    : [" << ptr[0] << ", " << ptr[1] << ", " << ptr[2]
            << "]" << std::endl;
}
```

Note that the pointer declared in `main` and passed, by reference, to `foo`, is
made to point to a memory location, in the heap, allocated (first command of
`foo`) in the scope of `foo`. The allocated memory is used both in the scope of
`foo` and in that of `main` (after `foo` is called).

The usage of the heap-allocated memory in a scope different than the one in
which it was declared as well as allocated indicates how the heap can be used
globally, i.e., independently from the stack scopes.
