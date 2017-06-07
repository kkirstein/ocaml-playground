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
(*$= is_perfect & ~printer:string_of_bool
  false (is_perfect 1)
  false (is_perfect 2)
  true (is_perfect 6)
  false (is_perfect 7)
  false (is_perfect 27)
  true (is_perfect 28)
  false (is_perfect 29)
*)

(* C version of predicate to check for a perfect number *)
external is_perfect_c: int -> bool = "is_perfect_c"
(*$= is_perfect_c & ~printer:string_of_bool
  false (is_perfect_c 1)
  false (is_perfect_c 2)
  true (is_perfect_c 6)
  false (is_perfect_c 7)
  false (is_perfect_c 27)
  true (is_perfect_c 28)
  false (is_perfect_c 29)
*)


(*$inject
  let pp_list_of_int l = String.concat " " (List.map string_of_int l)
*)

(* generate a list of perfect numbers until given upper limit *)
let perfect_numbers n =
  let rec loop i =
    if i = n then [] else
    if is_perfect i then i :: loop (i+1) else loop (i+1)
  in
  loop 1
(*$= perfect_numbers as pn & ~printer:pp_list_of_int
  [6; 28] (pn 100)
*)

(* generate a list of perfect numbers until given upper limit,
 * use C version of predicate *)
let perfect_numbers_c n =
  let rec loop i =
    if i = n then [] else
    if is_perfect_c i then i :: loop (i+1) else loop (i+1)
  in
  loop 1
(*$= perfect_numbers_c as pn & ~printer:pp_list_of_int
  [6; 28] (pn 100)
*)

(*
external perfect_numbers_c: int -> int list = "perfect_numbers_c"
(* -disabled- $= perfect_numbers_c as pn & ~printer:pp_list_of_int
  [6; 28] (pn 100)
*)
*)
