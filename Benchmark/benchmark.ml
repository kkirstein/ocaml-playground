(* vim: set ft=ocaml sw=2 ts=2: *)

(* benchmark.ml
 * A set of micro-benchmarks for the OCaml
 * programming language
 *)

(* time_it
 * A helper function to measure function execution times
 *)
let time_it action arg =
  let start_time = Sys.time () in
  ignore (action arg);
  let finish_time = Sys.time () in
  finish_time -. start_time;;

(* print_list
 * A helper function to print a list of int
 *)
let print_int_list out_channel l =
  List.iter (Printf.printf "%d ") l

(* main entry point *)
let () =
  print_endline "Fibonacci numbers";
  print_endline "=================";

  Printf.printf "fib_naive(35) = %d (Elapsed time %fs)\n" (Fibonacci.fib_naive 35) (time_it Fibonacci.fib_naive 35);
  Printf.printf "fib(35) = %s (Elapsed time %fs)\n" (Big_int.string_of_big_int (Fibonacci.fib 35)) (time_it Fibonacci.fib 35);
  Printf.printf "fib(1000) = %s (Elapsed time %fs)\n" (Big_int.string_of_big_int (Fibonacci.fib 1000)) (time_it Fibonacci.fib 1000);
  print_newline ();

  print_endline "Perfect numbers";
  print_endline "===============";
  Printf.printf "perfect_numbers(10000) = %a (Elapsed time %fs)\n" print_int_list (Perfect_number.perfect_numbers 10000) (time_it Perfect_number.perfect_numbers 10000);

  print_newline ();

  print_endline "Mandelbrot set";
  print_endline "==============";
  Printf.printf "mandelbrot(640x480) (Elapsed time %fs)\n" (time_it (Mandelbrot.mandelbrot 640 480 (-0.5) 0.0) (4.0/.640.));
  Printf.printf "mandelbrot(1920x1200) (Elapsed time %fs)\n" (time_it (Mandelbrot.mandelbrot 1920 1200 (-0.5) 0.0) (4.0/.1200.));
  Image.write_ppm (Mandelbrot.mandelbrot 640 480 (-0.5) 0.0 (4.0/.480.)) "mandelbrot_640_480.ppm";

  print_newline ();

  print_endline "Press ENTER to continue..";
  ignore(read_line ()); ()
;;
