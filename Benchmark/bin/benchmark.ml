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
let print_int_list l = List.iter (Printf.printf "%d ") l

let string_of_int_list l = String.concat " " (List.map string_of_int l)

let lwt_newline () = Lwt_io.printl ""

(* some config params *)
let pn_limit = 10000

let prime_limit = 100000

let num_worker = 4

let rec worker_ports ?(base = 5550) num =
  match num with 0 -> [] | _ -> (base + num) :: worker_ports ~base (num - 1)

(* main entry point *)
let bench enable_pn_worker =
  Lwt_main.run
    (let open Lwt in
    (* Fibonacci *)
    Lwt_io.printl "Fibonacci numbers" >>= fun () ->
    Lwt_io.printl "=================" >>= fun () ->
    lwt_time_it Tasks.Fibonacci.fib_naive 35 >>= fun res_fib_naive ->
    Lwt_io.printf "fib_naive(35) = %d (Elapsed time %.3fs)\n"
      res_fib_naive.result res_fib_naive.elapsed
    >>= fun () ->
    lwt_time_it Tasks.Fibonacci.fib 35 >>= fun res_fib ->
    Lwt_io.printf "fib(35) = %s (Elapsed time %.3fs)\n"
      (Z.to_string res_fib.result)
      res_fib.elapsed
    >>= fun () ->
    lwt_time_it Tasks.Fibonacci.fib 1000 >>= fun res_fib ->
    Lwt_io.printf "fib(1000) = %s (Elapsed time %.3fs)\n"
      (Z.to_string res_fib.result)
      res_fib.elapsed
    >>= fun () ->
    Lwt_io.printl "" >>= fun () ->
    Lwt_io.flush Lwt_io.stdout >>= fun () ->
    (* Primes *)
    Lwt_io.printl "Prime numbers" >>= fun () ->
    Lwt_io.printl "=============" >>= fun () ->
    lwt_time_it Tasks.Primes.find_primes prime_limit >>= fun res_primes ->
    Lwt_io.printf "find_primes(%d): %d primes (Elapsed time %.3fs)\n"
      prime_limit
      (List.length res_primes.result)
      res_primes.elapsed
    >>= fun () ->
    lwt_time_it Tasks.Primes.find_primes_z (Z.of_int prime_limit)
    >>= fun res_primes_z ->
    Lwt_io.printf "find_primes_z(%d): %d primes (Elapsed time %.3fs)\n"
      prime_limit
      (List.length res_primes_z.result)
      res_primes_z.elapsed
    >>= fun () ->
    lwt_time_it Tasks.Primes.sieve prime_limit >>= fun res_sieve ->
    Lwt_io.printf "sieve(%d): %d primes (Elapsed time %.3fs)\n" prime_limit
      (List.length res_sieve.result)
      res_sieve.elapsed
    >>= fun () ->
    lwt_time_it Tasks.Primes.sieve_z (Z.of_int prime_limit)
    >>= fun res_sieve_z ->
    Lwt_io.printf "sieve_z(%d): %d primes (Elapsed time %.3fs)\n" prime_limit
      (List.length res_sieve_z.result)
      res_sieve_z.elapsed
    >>= fun () ->
    Lwt_io.printl "" >>= fun () ->
    Lwt_io.flush Lwt_io.stdout >>= fun () ->
    (* Perfect Numbers *)
    Lwt_io.printl "Perfect numbers" >>= fun () ->
    Lwt_io.printl "===============" >>= fun () ->
    lwt_time_it Tasks.Perfect_number.perfect_numbers pn_limit >>= fun res_pn ->
    Lwt_io.printf "perfect_numbers(%d) = %s (Elapsed time %.3fs)\n" pn_limit
      (string_of_int_list res_pn.result)
      res_pn.elapsed
    >>= fun () ->
    lwt_time_it Tasks.Perfect_number.perfect_numbers_c pn_limit
    >>= fun res_pn ->
    Lwt_io.printf "perfect_numbers_c(%d) = %s (Elapsed time %.3fs)\n" pn_limit
      (string_of_int_list res_pn.result)
      res_pn.elapsed
    >>= fun () ->
    (* Perfect Numbers (Worker) *)
    (match enable_pn_worker with
    | Some num_worker ->
        lwt_time_it ~tfun:Unix.gettimeofday
          (Tasks.Lwt_perfect_number.perfect_numbers_zmq num_worker)
          pn_limit
        >>= fun res ->
        bind res.result (fun r ->
            Lwt_io.printf "perfect_numbers_zmq(%d) = %s (Elapsed time %.3fs)\n"
              pn_limit (string_of_int_list r) res.elapsed)
    | None ->
        return_unit >>= fun () ->
        Lwt_io.printl "" >>= fun () -> Lwt_io.flush Lwt_io.stdout)
    >>= fun () ->
    (* Mandelbrot *)
    Lwt_io.printl "Mandelbrot set" >>= fun () ->
    Lwt_io.printl "==============" >>= fun () ->
    lwt_time_it
      (fun _ -> Tasks.Mandelbrot.mandelbrot 640 480 (-0.5) 0.0 (4.0 /. 640.))
      ()
    >>= fun res ->
    Lwt_io.printf "mandelbrot(640x480) (Elapsed time %.3fs)\n" res.elapsed
    >>= fun () ->
    lwt_time_it
      (fun _ -> Tasks.Mandelbrot.mandelbrot 1920 1200 (-0.5) 0.0 (4.0 /. 1200.))
      ()
    >>= fun res ->
    Lwt_io.printf "mandelbrot(1920x1200) (Elapsed time %.3fs)\n" res.elapsed
    >>= fun () ->
    return (Tasks.Image.write_png res.result "mandelbrot_1920_1200.png"))

(* cmdliner options *)
let enable_pn_worker =
  let doc = "Use multiple workers to calculate perfect numbers" in
  Arg.(
    value
    & opt ~vopt:(Some 4) (some int) None
    & info [ "enable-pn-worker" ] ~docv:"PN_WORKER" ~doc)

let cmd =
  let doc = "A set of benchmarks, implemented in OCaml" in
  let man =
    [
      `S "DESCRIPTION";
      `P
        "$(tname) executes a small number of (micro-) benchmarks.\n\
        \        This command-line tool alse serves as a demonstrator\n\
        \        for various programming techniques in the OCaml programming\n\
        \        language.";
      `P
        "If $(b,PN_WORKER) is given, perfect numbers are additionally\n\
        \        calculated by starting multiple worker processes in parallel.\n\
        \        Communication is done via ZMQ.";
      `P "The benchmark results are written to STDOUT";
    ]
  in
  Cmd.v
    (Cmd.info "benchmark" ~version:"0.1.0" ~doc ~man)
    Term.(const bench $ enable_pn_worker)

(* start main *)
let () = exit (Cmd.eval cmd)
