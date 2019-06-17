(* vim: set ft=ocaml sw=2 ts=2: *)

(** fibonacci.mli
    A package to calculate Fibonacci numbers *)

val fib_naive : int -> int
(** [fib_naive n] naive recursive implementation, which calculates
    the Fibonacci number for [n] *)


val fib : int -> Z.t
(** [fib_naive n] optimized recursive implementation, which calculates
    the Fibonacci number for [n] *)
