(* vim: set ft=ocaml sw=2 ts=2: *)

(** perfect_number.ml
    A package to calculate Perfect numbers *)


val is_perfect : int -> bool
(** [is_perfect n] checks whether [n] is a perfect number *)


(* val is_perfect_c : int -> bool *)
(** [is_perfect n] checks whether [n] is a perfect number
    (implemented in C) *)


val perfect_numbers : int -> int list
(** [perfect_numbers limit] generates a list of perfect numbers
    less-or-equal to [limit] *)


val perfect_numbers_par : Domainslib.Task.pool -> int -> int list
(** [perfect_numbers_par pool limit] generates a list of perfect numbers
    less-or-equal to [limit]. Parallel implementation, using the given pool
    of OCaml domains (aka threads) *)

(* val perfect_numbers_c : int -> int list *)
(** [perfect_numbers limit] generates a list of perfect numbers
    less-or-equal to [limit] (uses [is_perfect_c] instead of [is_perfect]) *)
