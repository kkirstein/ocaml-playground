(* vim: set ft=ocaml sw=2 ts=2: *)

(* benchmark.ml
 * A set of micro-benchmarks for the OCaml
 * programming language
 *)

open Domainslib

(* print_list
 * A helper function to print a list of int
 *)
let print_int_list l = List.iter (Printf.printf "%d ") l
let string_of_int_list l = String.concat " " (List.map string_of_int l)

type 'a time_res = { result : 'a; elapsed : float }

let time_it f arg =
  let tic = Unix.gettimeofday () in
  let result = f arg in
  let toc = Unix.gettimeofday () in
  { result; elapsed = toc -. tic }

(* some config params *)
let pn_limit = 10000
let prime_limit = 100000
let num_worker = Domain.recommended_domain_count ()

(* main entry point *)
let bench () =
  let pool = Task.setup_pool ~num_domains:num_worker () in

  print_newline ();
  print_endline ("Using " ^ string_of_int num_worker ^ " domains");
  print_newline ();

  print_endline "Fibonacci numbers";
  print_endline "=================";

  let res_fib_naive = time_it Tasks.Fibonacci.fib_naive 35
  and res_fib = time_it Tasks.Fibonacci.fib 35
  and res_fib_2 = time_it Tasks.Fibonacci.fib 1000 in
  Printf.printf "fib_naive(35) = %d (Elapsed time %.3fs)\n" res_fib_naive.result
    res_fib_naive.elapsed;
  Printf.printf "fib(35) = %s (Elapsed time %.3fs)\n"
    (Z.to_string res_fib.result)
    res_fib.elapsed;
  Printf.printf "fib(1000) = %s (Elapsed time %.3fs)\n"
    (Z.to_string res_fib_2.result)
    res_fib_2.elapsed;
  print_newline ();

  print_endline "Prime numbers";
  print_endline "=============";
  let res_primes = time_it Tasks.Primes.find_primes prime_limit in
  Printf.printf "find_primes(%d): %d primes (Elapsed time %.3fs)\n" prime_limit
    (List.length res_primes.result)
    res_primes.elapsed;
  let res_primes_z =
    time_it Tasks.Primes.find_primes_z (Z.of_int prime_limit)
  in
  Printf.printf "find_primes_z(%d): %d primes (Elapsed time %.3fs)\n"
    prime_limit
    (List.length res_primes_z.result)
    res_primes_z.elapsed;
  let res_sieve = time_it Tasks.Primes.sieve prime_limit in
  Printf.printf "sieve(%d): %d primes (Elapsed time %.3fs)\n" prime_limit
    (List.length res_sieve.result)
    res_sieve.elapsed;
  let res_sieve_z = time_it Tasks.Primes.sieve_z (Z.of_int prime_limit) in
  Printf.printf "sieve_z(%d): %d primes (Elapsed time %.3fs)\n" prime_limit
    (List.length res_sieve_z.result)
    res_sieve_z.elapsed;
  print_newline ();

  print_endline "Perfect numbers";
  print_endline "===============";

  let res_pn_1 = time_it Tasks.Perfect_number.perfect_numbers pn_limit in
  Printf.printf "perfect_numbers(%d) = %s (Elapsed time %.3fs)\n" pn_limit
    (string_of_int_list res_pn_1.result)
    res_pn_1.elapsed;
  let res_pn_2 =
    time_it (Tasks.Perfect_number.perfect_numbers_par pool) pn_limit
  in
  Printf.printf "perfect_numbers_par(%d) = %s (Elapsed time %.3fs)\n" pn_limit
    (string_of_int_list res_pn_2.result)
    res_pn_2.elapsed;
  let res_pn_3 =
    time_it (Tasks.Perfect_number.perfect_numbers_par2 pool) pn_limit
  in
  Printf.printf "perfect_numbers_par2(%d) = %s (Elapsed time %.3fs)\n" pn_limit
    (string_of_int_list res_pn_3.result)
    res_pn_3.elapsed;
  print_newline ();

  print_endline "Mandelbrot set";
  print_endline "==============";
  let res_mandel_1 =
    time_it
      (fun _ -> Tasks.Mandelbrot.mandelbrot 640 480 (-0.5) 0.0 (4.0 /. 640.))
      ()
  in
  Printf.printf "mandelbrot(640x480) (Elapsed time %.3fs)\n"
    res_mandel_1.elapsed;
  let res_mandel_2 =
    time_it
      (fun _ -> Tasks.Mandelbrot.mandelbrot 1920 1200 (-0.5) 0.0 (4.0 /. 1200.))
      ()
  in
  Printf.printf "mandelbrot(1920x1200) (Elapsed time %.3fs)\n"
    res_mandel_2.elapsed;
  let res_mandel_3 =
    time_it
      (fun _ -> Tasks.Mandelbrot.mandelbrot 1920 1200 (-0.5) 0.0 (4.0 /. 1200.))
      ()
  in
  Printf.printf "mandelbrot(1920x1200) (parallel) (Elapsed time %.3fs)\n"
    res_mandel_3.elapsed;

  Tasks.Image.write_ppm res_mandel_2.result "mandelbrot_1920_1200.ppm";
  print_newline ();
  Task.teardown_pool pool

(* start main *)
let () = bench ()
