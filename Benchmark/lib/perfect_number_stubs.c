/* vim: set ft=c sw=2 ts=2: */

/* perfect_number_stubs.c
 * code stubs for perfect number calculation in C
 * to be called by OCaml */

#include <caml/mlvalues.h>

CAMLprim value is_perfect_c(value n) {
  CAMLparam1(n);
  CAMLlocal1(res);

  int sum = 0;
  for(int i = 1; i < Int_val(n); i++) {
    if(n % i == 0) sum += i;
  }

  res = Val_bool(sum == Int_val(n));
  CAMLreturn(res);
}
