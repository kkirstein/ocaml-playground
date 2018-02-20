(* vim: set ft=ocaml sw=2 ts=2: *)

open Tasks.Perfect_number

(* Testable types *)


(* The tests *)
let test_is_perfect () =
  let () = Alcotest.(check bool) "is_perfect 1" false (is_perfect 1) in
  let () = Alcotest.(check bool) "is_perfect 2" false (is_perfect 2) in
  let () = Alcotest.(check bool) "is_perfect 6" true (is_perfect 6) in
  let () = Alcotest.(check bool) "is_perfect 7" false (is_perfect 7) in
  let () = Alcotest.(check bool) "is_perfect 27" false (is_perfect 27) in
  let () = Alcotest.(check bool) "is_perfect 28" true (is_perfect 28) in
  Alcotest.(check bool) "is_perfect 29" false (is_perfect 29)
(* ---------------------- *)
let test_is_perfect_c () =
  let () = Alcotest.(check bool) "is_perfect_c 1" false (is_perfect_c 1) in
  let () = Alcotest.(check bool) "is_perfect_c 2" false (is_perfect_c 2) in
  let () = Alcotest.(check bool) "is_perfect_c 6" true (is_perfect_c 6) in
  let () = Alcotest.(check bool) "is_perfect_c 7" false (is_perfect_c 7) in
  let () = Alcotest.(check bool) "is_perfect_c 27" false (is_perfect_c 27) in
  let () = Alcotest.(check bool) "is_perfect_c 28" true (is_perfect_c 28) in
  Alcotest.(check bool) "is_perfect_c 29" false (is_perfect_c 29)
(* ---------------------- *)
let test_perfect_numbers () =
  Alcotest.(check (list int)) "perfect_numbers" [6; 28] (perfect_numbers 100)
(* ---------------------- *)
let test_perfect_numbers_c () =
  Alcotest.(check (list int)) "perfect_numbers_c" [6; 28] (perfect_numbers_c 100)


(* Test set *)
let test_set = [
  "test is_perfect", `Quick, test_is_perfect;
  "test is_perfect_c", `Quick, test_is_perfect_c;
  "test perfect_numbers", `Quick, test_perfect_numbers;
  "test perfect_numbers_c", `Quick, test_perfect_numbers_c
]


