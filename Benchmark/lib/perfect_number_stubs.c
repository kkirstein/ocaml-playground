/* vim: set ft=c sw=2 ts=2: */

/* perfect_number_stubs.c
 * code stubs for perfect number calculation in C
 * to be called by OCaml */

#include <stdio.h>

#include <caml/mlvalues.h>
#include <caml/memory.h>

CAMLprim value is_perfect_c(value caml_n) {
  CAMLparam1(caml_n);
  CAMLlocal1(res);

  int sum = 0;
  int n = Int_val(caml_n);
  for(int i = 1; i < n; i++) {
    if(n % i == 0) sum += i;
  }

  res = Val_bool(sum == n);
  CAMLreturn(res);
}
