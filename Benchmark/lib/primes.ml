(* vim: set ft=ocaml sw=2 ts=2: *)

(** primes.mli
    A module to calculate prime numbers *)


let sieve _limit =
  []


let is_prime n =
  match n with
  | 1 -> false
  | _ -> let rec loop i =
           if i > (n/2) then true else
           if n mod i = 0 then false else loop (i + 1)
    in
    loop 2


let find_primes limit =
  Listx.range 1 limit |> List.filter is_prime
