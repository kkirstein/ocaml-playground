(* vim: set ft=ocaml sw=2 ts=2: *)

(* perfect_number.ml
 * A package to calculate Perfect numbers
*)

(* predicate to check for a perfect number *)
let is_perfect n =
  let rec loop i sum =
    if n = i then sum = n else
    if n mod i = 0 then loop (i+1) (sum+i) else loop (i+1) sum
  in
  if n > 0 then loop 1 0 else failwith "n must be > 0"


(* C version of predicate to check for a perfect number *)
external is_perfect_c: int -> bool = "is_perfect_c"


(* generate a list of perfect numbers until given upper limit *)
let perfect_numbers n =
  let rec loop i =
    if i = n then [] else
    if is_perfect i then i :: loop (i+1) else loop (i+1)
  in
  loop 1


(* generate a list of perfect numbers until given upper limit,
 * use C version of predicate *)
let perfect_numbers_c n =
  let rec loop i =
    if i = n then [] else
    if is_perfect_c i then i :: loop (i+1) else loop (i+1)
  in
  loop 1

