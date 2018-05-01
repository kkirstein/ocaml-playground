(* vim: set ft=ocaml sw=2 ts=2: *)

let () = Alcotest.run "Benchmark" [
    "Fibonacci", Test_fibonacci.test_set;
    "Perfect Number", Test_perfect_number.test_set;
    "Image", Test_image.test_set;
    "Mandelbrot Set", Test_mandelbrot.test_set
  ]

