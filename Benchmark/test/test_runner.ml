(* vim: set ft=ocaml sw=2 ts=2: *)

let () = Alcotest.run "Benchmark" [
    "Fibonacci", Test_fibonacci.test_set
  ]

