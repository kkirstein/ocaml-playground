(* vim: set ft=ocaml sw=2 ts=2: *)

(* benchmark.ml
 * A set of micro-benchmarks for the OCaml
 * programming language
*)

open Time_it
open Cmdliner

(* print_list
 * A helper function to print a list of int
*)
let print_int_list out_channel l =
  List.iter (Printf.printf "%d ") l
let string_of_int_list l =
  String.concat " " (List.map string_of_int l)

let lwt_newline () =
  Lwt_io.printl ""


(* some config params *)
let pn_limit = 10000
let num_worker = 4
let rec worker_ports ?(base=5550) num =
  match num with
  | 0 -> []
  | _ -> (base + num) :: worker_ports ~base (num - 1)


(* main entry point *)
let bench = begin
  print_endline "Fibonacci numbers";
  print_endline "=================";

  let res_fib_naive = time_it Fibonacci.fib_naive 35
  and res_fib = time_it Fibonacci.fib 35
  and res_fib_2 = time_it Fibonacci.fib 1000
  in
  Printf.printf "fib_naive(35) = %d (Elapsed time %.3fs)\n"
    res_fib_naive.result res_fib_naive.elapsed;
  Printf.printf "fib(35) = %s (Elapsed time %.3fs)\n"
    (Big_int.string_of_big_int res_fib.result) res_fib.elapsed;
  Printf.printf "fib(1000) = %s (Elapsed time %.3fs)\n"
    (Big_int.string_of_big_int res_fib_2.result) res_fib_2.elapsed;
  print_endline "";

  print_endline "Perfect numbers";
  print_endline "===============";

  let res_pn_1 = time_it Perfect_number.perfect_numbers pn_limit
  and res_pn_2 = time_it Perfect_number.perfect_numbers_c pn_limit
  in
  Printf.printf "perfect_numbers(%d) = %s (Elapsed time %.3fs)\n"
    pn_limit (string_of_int_list res_pn_1.result) res_pn_1.elapsed;
  Printf.printf "perfect_numbers_c(%d) = %s (Elapsed time %.3fs)\n"
    pn_limit (string_of_int_list res_pn_2.result) res_pn_2.elapsed;


  print_endline "";

  print_endline "Mandelbrot set";
  print_endline "==============";
  let res_mandel_1 = time_it (fun _ -> Mandelbrot.mandelbrot 640 480 (-0.5) 0.0 (4.0/.640.)) ()
  and res_mandel_2 = time_it (fun _ -> Mandelbrot.mandelbrot 1920 1200 (-0.5) 0.0 (4.0/.1200.)) ()
  in
  Printf.printf "mandelbrot(640x480) (Elapsed time %.3fs)\n" res_mandel_1.elapsed;
  Printf.printf "mandelbrot(1920x1200) (Elapsed time %.3fs)\n" res_mandel_2.elapsed;
  Image.write_ppm res_mandel_1.result "mandelbrot_640_480.ppm";
end

(* cmdliner options *)
let cmd =
  let doc = "A set of benchmarks, implemented in OCaml" in
  let man = [
    `S "DESCRIPTION";
    `P "$(tname) executes a small number of (micro-) benchmarks.
        This command-line tool alse serves as a demonstrator
        for various programming techniques in the OCaml programming
        language.";
    `P "If $(b,PN_WORKER) is given, perfect numbers are additionally
        calculated by starting multiple worker processes in parallel.
        Communication is done via ZMQ.";
    `P "The benchmark results are written to STDOUT"]
  in
  Term.(const bench),
  Term.info  "benchmark" ~version:"0.1.0" ~doc ~man


(* start main *)
let () =
  match Term.eval cmd with
  | `Error _  -> exit 1
  | _         -> exit 0
