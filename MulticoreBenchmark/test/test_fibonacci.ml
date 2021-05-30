(* vim: set ft=ocaml sw=2 ts=2: *)

open Tasks.Fibonacci

(* Testable types *)
let z_type = Alcotest.testable (Fmt.of_to_string Z.to_string) (=)

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
  let () = Alcotest.(check z_type) "fib 0" (Z.of_int 0) (fib 0) in
  let () = Alcotest.(check z_type) "fib 1" (Z.of_int 1) (fib 1) in
  let () = Alcotest.(check z_type) "fib 2" (Z.of_int 1) (fib 2) in
  let () = Alcotest.(check z_type) "fib 3" (Z.of_int 2) (fib 3) in
  let () = Alcotest.(check z_type) "fib 4" (Z.of_int 3) (fib 4) in
  let () = Alcotest.(check z_type) "fib 0" (Z.of_int 0) (fib 0) in
  let () = Alcotest.(check z_type) "fib 10" (Z.of_int 55) (fib 10) in
  let () = Alcotest.(check z_type) "fib 20" (Z.of_int 6765) (fib 20) in
  Alcotest.(check z_type) "fib 30" (Z.of_int 832040) (fib 30)

(* Test set *)
let test_set = [
  "test fib_naive", `Quick, test_fib_naive;
  "test fib", `Quick, test_fib
]

