#include <stdio.h>
#include <klee/klee.h>

const int values[8] = {0, 1, 8, 27, 64, 125, 216, 343};
const int array2[5] = {27, 64, 125, 216, 343};
const int array_non_literal[5];
float const_float = 3.14;

int foo(unsigned k) { return values[k] * values[k - 1]; }

int main(int argc, char *argv[]) {
  int a;
  klee_make_symbolic(&a, sizeof(a), "a");
  int f = foo(a);
  return (f * a) / f;
}
