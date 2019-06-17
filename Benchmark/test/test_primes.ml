(* vim: set ft=ocaml sw=2 ts=2: *)

open Tasks.Primes

(* Testable types *)
let z_type = Alcotest.testable (Fmt.of_to_string Z.to_string) (=)

(* The tests *)
let test_is_prime () =
  Alcotest.(check bool) "is_prime 1" false (is_prime 1);
  Alcotest.(check bool) "is_prime 2" true (is_prime 2);
  Alcotest.(check bool) "is_prime 3" true (is_prime 3);
  Alcotest.(check bool) "is_prime 4" false (is_prime 4);
  Alcotest.(check bool) "is_prime 5" true (is_prime 5);
  Alcotest.(check bool) "is_prime 6" false (is_prime 6)
(* ---------------------- *)
let test_is_prime_z () =
  Alcotest.(check bool) "is_prime 1" false (is_prime_z (Z.of_int 1));
  Alcotest.(check bool) "is_prime 2" true (is_prime_z (Z.of_int 2));
  Alcotest.(check bool) "is_prime 3" true (is_prime_z (Z.of_int 3));
  Alcotest.(check bool) "is_prime 4" false (is_prime_z (Z.of_int 4));
  Alcotest.(check bool) "is_prime 5" true (is_prime_z (Z.of_int 5));
  Alcotest.(check bool) "is_prime 6" false (is_prime_z (Z.of_int 6))
(* ---------------------- *)
let test_find_primes () =
  Alcotest.(check (list int)) " find_primes 19" [2; 3; 5; 7; 11; 13; 17] (find_primes 19);
  Alcotest.(check (list int)) " find_primes 20" [2; 3; 5; 7; 11; 13; 17; 19] (find_primes 20);
  Alcotest.(check int) " find_primes 10000" 1229 (List.length (find_primes 10000))
(* ---------------------- *)
let test_find_primes_z () =
  Alcotest.(check (list z_type)) " find_primes_z 19"
    (List.map Z.of_int [2; 3; 5; 7; 11; 13; 17])
    (find_primes_z (Z.of_int 19));
  Alcotest.(check (list z_type)) " find_primes_z 20"
    (List.map Z.of_int [2; 3; 5; 7; 11; 13; 17; 19])
    (find_primes_z (Z.of_int 20));
  Alcotest.(check int) " find_primes_z 10000"
    1229
    (List.length (find_primes_z (Z.of_int 10000)))

(* Test set *)
let test_set = [
  "is_prime", `Quick, test_is_prime;
  "is_prime_z", `Quick, test_is_prime_z;
  "find_primes", `Quick, test_find_primes;
  "find_primes_z", `Quick, test_find_primes_z
]