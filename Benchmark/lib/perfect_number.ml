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

let rec range ?(step=1) a b =
  if a > b then []
  else a :: range ~step (a+step) b
(*$= range & ~printer:pp_list_of_int
  (range 0 2) [0; 1; 2]
  (range 1 5) [1; 2; 3; 4; 5]
  (range 1 1) [1]
  (range 1 0) []
  (range ~step:2 2 8) [2; 4; 6; 8]
  (range ~step:2 1 7) [1; 3; 5; 7]
  (range ~step:2 1 8) [1; 3; 5; 7]
*)

let permute_range a b =
  let rec loop f r =
    match (f, r) with
    | ([], _) -> []
    | (_, []) -> []
    (* | (f1 :: f2 :: ft, r1 :: r2 :: rt) -> f1 :: r2 :: (loop ft rt) *)
    | (fh :: ft, rh :: rt) -> fh :: rh :: (loop ft rt)
  in
  loop (range ~step:2 (a+1) b) (List.rev (range ~step:2 a (b-1)))
(*$= permute_range & ~printer:pp_list_of_int
  (permute_range 1 8) [2; 7; 4; 5; 6; 3; 8; 1]
*)

(*
let perfect_numbers_2 n =
  let nums = permute_range 1 n in
  Parmap.parmap ~ncores:4 ~chunksize:1 (fun i -> (i, is_perfect i)) (Parmap.L nums)
  |> List.filter (fun (_, p) -> p)
  |> List.map fst
  |> List.sort compare
(*$= perfect_numbers_2 as pn & ~printer:pp_list_of_int
    (List.sort compare (pn 100)) [6; 28]
*)
*)
