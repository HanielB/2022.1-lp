#include <stdlib.h>

#define INT_BITS 32

#include "set.h"

void new(set* s, unsigned capacity)
{
  s->vector = (unsigned*)malloc((1 + (capacity / INT_BITS)) * sizeof(unsigned));
  s->size = capacity;
}

void add(set* s, unsigned e)
{
  unsigned index = e / INT_BITS;
  unsigned offset = e % INT_BITS;
  unsigned bit = 1 << offset;
  s->vector[index] |= bit;
}

void del(set* s, unsigned e)
{
  unsigned index = e / INT_BITS;
  unsigned offset = e % INT_BITS;
  unsigned bit = 1 << offset;
  s->vector[index] &= ~bit;
}

int contains(set* s, unsigned e)
{
  unsigned index = e / INT_BITS;
  unsigned offset = e % INT_BITS;
  unsigned bit = 1 << offset;
  return s->vector[index] & bit;
}
