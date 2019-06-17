(* vim: set ft=ocaml sw=2 ts=2: *)

(** primes.mli
    A module to calculate prime numbers *)


let sieve _limit =
  []


let is_prime n =
  if n <= 1 then false else
    let rec loop i =
      if i > (n/2) then true else
      if n mod i = 0 then false else loop (i + 1)
    in
    loop 2


let is_prime_z n =
  let limit = Z.div n (Z.of_int 2) in
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

