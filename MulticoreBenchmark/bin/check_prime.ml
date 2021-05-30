(* vim: set ft=ocaml sw=2 ts=2: *)

(* check_prime.ml
 * A command-line tool to check prime numbers
*)

open Tasks

let () =
  let test_number = Primes.test_number in
  let tic = Unix.time () in
  Printf.printf "Checking whether %s is prime .." (Z.to_string test_number);
  flush_all ();
  let res = Primes.is_prime_z test_number in
  let toc = Unix.time () in
  Printf.printf "%s (Elapsed %fs).\n" (string_of_bool res) (toc -. tic);

