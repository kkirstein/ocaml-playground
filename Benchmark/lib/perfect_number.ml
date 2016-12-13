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
  (is_perfect 1) false
  (is_perfect 2) false
  (is_perfect 6) true
  (is_perfect 7) false
  (is_perfect 27) false
  (is_perfect 28) true
  (is_perfect 29) false
*)

(* async predicate to check for a perfect number *)
let lwt_is_perfect n = Lwt.map is_perfect (Lwt.return n)
(*$= lwt_is_perfect
  (lwt_is_perfect 1) Lwt.return_false
  (lwt_is_perfect 2) Lwt.return_false
  (lwt_is_perfect 6) Lwt.return_true
  (lwt_is_perfect 7) Lwt.return_false
  (lwt_is_perfect 27) Lwt.return_false
  (lwt_is_perfect 28) Lwt.return_true
  (lwt_is_perfect 29) Lwt.return_false
*)
let lwt_is_perfect_val n =
  Lwt.map (fun x -> if is_perfect x then Some x else None) (Lwt.return n)
(*$= lwt_is_perfect_val
  (lwt_is_perfect_val 1) Lwt.return_none
  (lwt_is_perfect_val 2) Lwt.return_none
  (lwt_is_perfect_val 6) (Lwt.return_some 6)
  (lwt_is_perfect_val 7) Lwt.return_none
  (lwt_is_perfect_val 27) Lwt.return_none
  (lwt_is_perfect_val 28) (Lwt.return_some 28)
  (lwt_is_perfect_val 29) Lwt.return_none
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
  (pn 100) [6; 28]
*)

