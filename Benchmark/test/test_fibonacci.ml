(* vim: set ft=ocaml sw=2 ts=2: *)

open Tasks.Fibonacci

(* Testable types *)
let bigint = Alcotest.testable (Fmt.of_to_string Big_int.string_of_big_int) Big_int.eq_big_int

(* The tests *)
let test_fib_naive () =
  let () = Alcotest.(check int) "fib 0" 0 (fib_naive 0) in
  let () = Alcotest.(check int) "fib 1" 1 (fib_naive 1) in
  let () = Alcotest.(check int) "fib 2" 1 (fib_naive 2) in
  let () = Alcotest.(check int) "fib 3" 2 (fib_naive 3) in
  let () = Alcotest.(check int) "fib 4" 3 (fib_naive 4) in
  let () = Alcotest.(check int) "fib 10" 55 (fib_naive 10) in
  let () = Alcotest.(check int) "fib 20" 6765 (fib_naive 20) in
  Alcotest.(check int) "fib 30" 832040 (fib_naive 30)
(* ---------------------- *)
let test_fib () =
  let open Big_int in
  let () = Alcotest.(check bigint) "fib 0" (big_int_of_int 0) (fib 0) in
  let () = Alcotest.(check bigint) "fib 1" (big_int_of_int 1) (fib 1) in
  let () = Alcotest.(check bigint) "fib 2" (big_int_of_int 1) (fib 2) in
  let () = Alcotest.(check bigint) "fib 3" (big_int_of_int 2) (fib 3) in
  let () = Alcotest.(check bigint) "fib 4" (big_int_of_int 3) (fib 4) in
  let () = Alcotest.(check bigint) "fib 0" (big_int_of_int 0) (fib 0) in
  let () = Alcotest.(check bigint) "fib 10" (big_int_of_int 55) (fib 10) in
  let () = Alcotest.(check bigint) "fib 20" (big_int_of_int 6765) (fib 20) in
  Alcotest.(check bigint) "fib 30" (big_int_of_int 832040) (fib 30)

(* Test set *)
let test_set = [
  "test fib_naive", `Quick, test_fib_naive;
  "test fib", `Quick, test_fib
]

