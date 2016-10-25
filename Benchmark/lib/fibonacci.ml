(* vim: set ft=ocaml sw=2 ts=2: *)

(* fibonacci.ml
 * A package to calculate Fibonacci numbers
 *)

(* naive recursive implementation *)
let rec fib_naive n =
  if n < 2 then n else fib_naive (n-1) + fib_naive (n-2)

(*$= fib_naive & ~printer:string_of_int
  (fib_naive 0) 0
  (fib_naive 1) 1
  (fib_naive 2) 1
  (fib_naive 3) 2
  (fib_naive 4) 3
  (fib_naive 10) 55
  (fib_naive 20) 6765
  (fib_naive 30) 832040
*)


(* optimized recursive implementation *)
let fib n =
  let rec fib_aux n a b =
    if n = 0 then a else fib_aux (n-1) b (Big_int.add_big_int a b)
  in
  fib_aux n Big_int.zero_big_int Big_int.unit_big_int

(*$T fib
  (Big_int.eq_big_int (fib 0) (Big_int.big_int_of_int 0))
  (Big_int.eq_big_int (fib 1) (Big_int.big_int_of_int 1))
  (Big_int.eq_big_int (fib 2) (Big_int.big_int_of_int 1))
  (Big_int.eq_big_int (fib 3) (Big_int.big_int_of_int 2))
  (Big_int.eq_big_int (fib 4) (Big_int.big_int_of_int 3))
  (Big_int.eq_big_int (fib 10) (Big_int.big_int_of_int 55))
  (Big_int.eq_big_int (fib 20) (Big_int.big_int_of_int 6765))
  (Big_int.eq_big_int (fib 30) (Big_int.big_int_of_int 832040))
*)
