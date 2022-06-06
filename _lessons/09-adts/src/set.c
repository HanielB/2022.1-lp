#include <stdlib.h>

#define CAPACITY 2

#include "set.h"

void new(set* s)
{
  s->vector = (unsigned*)malloc(CAPACITY * sizeof(unsigned));
  s->size = 0;
  s->capacity = CAPACITY;
}

void add(set* s, unsigned e)
{
  if (s->size == s->capacity) {
    s->capacity *= 2;
    s->vector = realloc(s->vector, s->capacity * sizeof(int));
  }
  s->vector[s->size++] = e;
}

void del(set* s, unsigned e)
{
  unsigned deleted = s->size;
  for (unsigned i = 0; i < s->size; ++i)
    if (s->vector[i] == e)
    {
      deleted = i;
      break;
    }
  if (deleted == s->size)
    return;
  for (unsigned i = deleted; i < s->size - 1; ++i)
    s->vector[i] = s->vector[i+1];
  s->size--;
}

int contains(set* s, unsigned e)
{
  for (unsigned i = 0; i < s->size; ++i)
    if (s->vector[i] == e)
      return 1;
  return 0;
}
