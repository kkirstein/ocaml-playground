(* vim: set ft=ocaml sw=2 ts=2: *)

(** primes.mli
    A module to calculate prime numbers *)

let sieve n =
  let rec range_by_2 start stop =
    if start < stop then start :: range_by_2 (start + 2) stop else []
  in
  let limit = int_of_float (sqrt (float_of_int n)) in
  let rec loop i l =
    if i < limit then loop (i+1) (List.filter (fun el -> el mod i <> 0 || el = i) l) else l
  in
  2 :: (loop 2 (range_by_2 3 n))


let sieve_z n =
  let z_2 = Z.of_int 2 in
  let rec range_by_2 start stop =
    if start < stop then start :: range_by_2 (Z.add start z_2) stop else []
  in
  let limit = Z.sqrt n in
  let rec loop i l =
    if i < limit then
      loop (Z.succ i) (List.filter (fun el -> (Z.rem el i) <> Z.zero || el = i) l)
    else l
  in
  z_2 :: (loop z_2 (range_by_2 (Z.of_int 3) n))


let is_prime n =
  let limit = int_of_float (sqrt (float_of_int n)) in
  if n <= 1 then false else
    let rec loop i =
      if i > limit then true else
      if n mod i = 0 then false else loop (i + 1)
    in
    loop 2


let is_prime_z n =
  let limit = Z.sqrt n in
  if n <= Z.one then false else
    let rec loop i =
      if i > limit then true else
      if Z.rem n i = Z.zero then false else loop (Z.succ i)
    in
    loop (Z.of_int 2)


let find_primes limit =
  Listx.range 1 limit |> List.filter is_prime


let find_primes_z limit =
  let rec range start stop =
    if start < stop then start :: (range (Z.succ start) stop) else []
  in
  range Z.one limit |> List.filter is_prime_z

