(* vim: set ft=ocaml sw=2 ts=2: *)

(* benchmark.ml
 * A set of micro-benchmarks for the OCaml
 * programming language
*)

open Time_it

(* print_list
 * A helper function to print a list of int
*)
let print_int_list out_channel l =
  List.iter (Printf.printf "%d ") l

(* some config params *)
let pn_limit = 10000

(* main entry point *)
let () =
  print_endline "Fibonacci numbers";
  print_endline "=================";

  let res = time_it Fibonacci.fib_naive 35 in
  Printf.printf "fib_naive(35) = %d (Elapsed time %.3fs)\n"
    res.result res.elapsed;
  let res = time_it Fibonacci.fib 35 in
  Printf.printf "fib(35) = %s (Elapsed time %.3fs)\n"
    (Big_int.string_of_big_int res.result) res.elapsed;
  let res = time_it Fibonacci.fib 1000 in
  Printf.printf "fib(1000) = %s (Elapsed time %.3fs)\n"
    (Big_int.string_of_big_int res.result) res.elapsed;
  print_newline ();

  print_endline "Perfect numbers";
  print_endline "===============";
  let res = time_it Perfect_number.perfect_numbers pn_limit in
  Printf.printf "perfect_numbers(%d) = %a (Elapsed time %.3fs)\n"
    pn_limit print_int_list res.result res.elapsed;
(*
Printf.printf "perfect_numbers_2(%d) = %a (Elapsed time %.3fs)\n"
  pn_limit
  print_int_list (Perfect_number.perfect_numbers_2 pn_limit)
  (time_it Perfect_number.perfect_numbers_2 pn_limit);
*)

  print_newline ();
  print_endline "Mandelbrot set";
  print_endline "==============";
  let res = time_it (fun _ -> Mandelbrot.mandelbrot 640 480 (-0.5) 0.0 (4.0/.640.)) () in
  Printf.printf "mandelbrot(640x480) (Elapsed time %.3fs)\n" res.elapsed;
  let res = time_it (fun _ -> Mandelbrot.mandelbrot 1920 1200 (-0.5) 0.0 (4.0/.1200.)) () in
  Printf.printf "mandelbrot(1920x1200) (Elapsed time %.3fs)\n" res.elapsed;
  Image.write_ppm res.result "mandelbrot_640_480.ppm";

  print_newline ();

  print_endline "Press ENTER to continue..";
  ignore(read_line ()); ()
;;
