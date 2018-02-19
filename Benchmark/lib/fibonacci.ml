(* vim: set ft=ocaml sw=2 ts=2: *)

(* fibonacci.ml
 * A package to calculate Fibonacci numbers
 *)

(* naive recursive implementation *)
let rec fib_naive n =
  if n < 2 then n else fib_naive (n-1) + fib_naive (n-2)


(* optimized recursive implementation *)
let fib n =
  let rec fib_aux n a b =
    if n = 0 then a else fib_aux (n-1) b (Big_int.add_big_int a b)
  in
  fib_aux n Big_int.zero_big_int Big_int.unit_big_int

