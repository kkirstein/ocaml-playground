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
let print_int_list l =
  List.iter (Printf.printf "%d ") l
let string_of_int_list l =
  String.concat " " (List.map string_of_int l)

let lwt_newline () =
  Lwt_io.printl ""


(* some config params *)
let pn_limit = 10000
let prime_limit = 100000
let num_worker = 4
let rec worker_ports ?(base=5550) num =
  match num with
  | 0 -> []
  | _ -> (base + num) :: worker_ports ~base (num - 1)


(* main entry point *)
let bench enable_pn_worker = Lwt_main.run begin
    let open Lwt in
    let%lwt () = Lwt_io.printl "Fibonacci numbers"
    and () = Lwt_io.printl "=================" in

    let%lwt res_fib_naive = lwt_time_it Tasks.Fibonacci.fib_naive 35
    and res_fib = lwt_time_it Tasks.Fibonacci.fib 35
    and res_fib_2 = lwt_time_it Tasks.Fibonacci.fib 1000
    in
    Lwt_io.printf "fib_naive(35) = %d (Elapsed time %.3fs)\n"
      res_fib_naive.result res_fib_naive.elapsed >>= fun () ->
    Lwt_io.printf "fib(35) = %s (Elapsed time %.3fs)\n"
      (Big_int.string_of_big_int res_fib.result) res_fib.elapsed >>= fun () ->
    Lwt_io.printf "fib(1000) = %s (Elapsed time %.3fs)\n"
      (Big_int.string_of_big_int res_fib_2.result) res_fib_2.elapsed >>= fun () ->
    Lwt_io.printl "" >>= fun () ->
    Lwt_io.flush Lwt_io.stdout >>= fun () ->

    let%lwt () = Lwt_io.printl "Prime numbers"
    and () = Lwt_io.printl     "=============" in
    let%lwt res_primes = lwt_time_it Tasks.Primes.find_primes prime_limit
    in
    Lwt_io.printf "find_primes(%d): %d primes (Elapsed time %.3fs)\n"
      prime_limit (List.length res_primes.result) res_primes.elapsed >>= fun () ->
    Lwt_io.printl "" >>= fun () ->
    Lwt_io.flush Lwt_io.stdout >>= fun () ->


    let%lwt () = Lwt_io.printl "Perfect numbers"
    and () = Lwt_io.printl "===============" in

    let%lwt res_pn_1 = lwt_time_it Tasks.Perfect_number.perfect_numbers pn_limit
    and res_pn_2 = lwt_time_it Tasks.Perfect_number.perfect_numbers_c pn_limit
    in
    let%lwt () = Lwt_io.printf "perfect_numbers(%d) = %s (Elapsed time %.3fs)\n"
        pn_limit (string_of_int_list res_pn_1.result) res_pn_1.elapsed
    and () = Lwt_io.printf "perfect_numbers_c(%d) = %s (Elapsed time %.3fs)\n"
        pn_limit (string_of_int_list res_pn_2.result) res_pn_2.elapsed
    in

    let%lwt () = match enable_pn_worker with
      | Some num_worker ->
        lwt_time_it ~tfun:Unix.gettimeofday
          (Tasks.Lwt_perfect_number.perfect_numbers_zmq num_worker) pn_limit >>= fun res ->
        bind res.result (fun r -> Lwt_io.printf "perfect_numbers_zmq(%d) = %s (Elapsed time %.3fs)\n"
                            pn_limit (string_of_int_list r) res.elapsed)
      | None            -> return_unit
    in

    Lwt_io.printl "" >>= fun () ->
    Lwt_io.flush Lwt_io.stdout >>= fun () ->


    Lwt_io.printl "Mandelbrot set" >>= fun () ->
    Lwt_io.printl "==============" >>= fun () ->
    lwt_time_it (fun _ -> Tasks.Mandelbrot.mandelbrot 640 480 (-0.5) 0.0 (4.0/.640.)) () >>= fun res ->
    Lwt_io.printf "mandelbrot(640x480) (Elapsed time %.3fs)\n" res.elapsed >>= fun () ->
    lwt_time_it (fun _ -> Tasks.Mandelbrot.mandelbrot 1920 1200 (-0.5) 0.0 (4.0/.1200.)) () >>= fun res ->
    Lwt_io.printf "mandelbrot(1920x1200) (Elapsed time %.3fs)\n" res.elapsed >>= fun () ->
    return (Tasks.Image.write_ppm res.result "mandelbrot_1920_1200.ppm")
  end


(* cmdliner options *)
let enable_pn_worker =
  let doc = "Use multiple workers to calculate perfect numbers" in
  Arg.(value & opt ~vopt:(Some 4) (some int) None & info ["enable-pn-worker"] ~docv:"PN_WORKER" ~doc)

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
  Term.(const bench $ enable_pn_worker),
  Term.info  "benchmark" ~version:"0.1.0" ~doc ~man


(* start main *)
let () =
  match Term.eval cmd with
  | `Error _  -> exit 1
  | _         -> exit 0
