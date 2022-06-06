#include <stdlib.h>

#define INT_BITS 32
#define CAPACITY 60

#include "set-bitset.h"

void new(set* s)
{
  s->vector = (unsigned*)malloc((1 + (CAPACITY / INT_BITS)) * sizeof(unsigned));
  s->size = (1 + (CAPACITY / INT_BITS));
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
