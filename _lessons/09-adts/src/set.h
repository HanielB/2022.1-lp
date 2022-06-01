#define INT_BITS 32

typedef struct
{
  unsigned* vector;
  unsigned size;
} set;


void new(set*, unsigned);

void add(set*, unsigned);

void del(set*, unsigned);

int contains(set*, unsigned);
