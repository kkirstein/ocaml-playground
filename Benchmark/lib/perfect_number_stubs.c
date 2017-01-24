/* vim: set ft=c sw=2 ts=2: */

/* perfect_number_stubs.c
 * code stubs for perfect number calculation in C
 * to be called by OCaml */

#include <stdio.h>

#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>

/** c implementation of perfect number predicate */
int is_perfect(int n) {
  int sum = 0;
  for(int i = 1; i < n; i++) {
    if(n % i == 0) sum += i;
  }

  return (sum == n);
}

/** predicate to check whether a number is perfect */
CAMLprim value is_perfect_c(value ml_n) {
  CAMLparam1(ml_n);
  CAMLlocal1(res);

  int n = Int_val(ml_n);
  res = Val_bool(is_perfect(n));
  CAMLreturn(res);
}

/** Create a list of perfect numbers upto given limit n */
CAMLprim value perfect_numbers_c(value ml_n) {
  CAMLparam1(ml_n);
  CAMLlocal2(res_list, cons);

  res_list = Val_emptylist;

  int n = Int_val(ml_n);

  #pragma omp for
  for(int i = (n-1); i > 1; i--) {
    if (is_perfect(i)) {
      cons = caml_alloc(2, 0);
      Store_field(cons, 0, Val_int(i));
      Store_field(cons, 1, res_list);
      res_list = cons;
    }
  }

  CAMLreturn(res_list);
}
