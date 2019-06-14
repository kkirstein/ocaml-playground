(* vim: set ft=ocaml sw=2 ts=2: *)

open Tasks.Primes

(* Testable types *)


(* The tests *)
let test_is_prime () =
  Alcotest.(check bool) "is_prime 1" false (is_prime 1);
  Alcotest.(check bool) "is_prime 2" true (is_prime 2);
  Alcotest.(check bool) "is_prime 3" true (is_prime 3);
  Alcotest.(check bool) "is_prime 4" false (is_prime 4);
  Alcotest.(check bool) "is_prime 5" true (is_prime 5);
  Alcotest.(check bool) "is_prime 6" false (is_prime 6)
(* ---------------------- *)
let test_find_primes () =
  Alcotest.(check (list int)) " find_primes 19" [2; 3; 5; 7; 11; 13; 17] (find_primes 19);
  Alcotest.(check (list int)) " find_primes 20" [2; 3; 5; 7; 11; 13; 17; 19] (find_primes 20);
  Alcotest.(check int) " find_primes 10000" 1229 (List.length (find_primes 10000))

(* Test set *)
let test_set = [
  "is_prime", `Quick, test_is_prime;
  "find_primes", `Quick, test_find_primes
]