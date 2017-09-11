(* vim: set ft=ocaml sw=2 ts=2: *)

(* benchmark.ml
 * A set of micro-benchmarks for the OCaml
 * programming language
*)

open Lwt_time_it
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
let bench enable_pn_worker = Lwt_main.run begin
    let open Lwt in
    let%lwt () = Lwt_io.printl "Fibonacci numbers"
    and () = Lwt_io.printl "=================" in

    let%lwt res_fib_naive = lwt_time_it Fibonacci.fib_naive 35
    and res_fib = lwt_time_it Fibonacci.fib 35
    and res_fib_2 = lwt_time_it Fibonacci.fib 1000
    in
    Lwt_io.printf "fib_naive(35) = %d (Elapsed time %.3fs)\n"
      res_fib_naive.result res_fib_naive.elapsed >>= fun () ->
    Lwt_io.printf "fib(35) = %s (Elapsed time %.3fs)\n"
      (Big_int.string_of_big_int res_fib.result) res_fib.elapsed >>= fun () ->
    Lwt_io.printf "fib(1000) = %s (Elapsed time %.3fs)\n"
      (Big_int.string_of_big_int res_fib_2.result) res_fib_2.elapsed >>= fun () ->
    Lwt_io.printl "" >>= fun () ->
    Lwt_io.flush Lwt_io.stdout >>= fun () ->

    let%lwt () = Lwt_io.printl "Perfect numbers"
    and () = Lwt_io.printl "===============" in

    let%lwt res_pn_1 = lwt_time_it Perfect_number.perfect_numbers pn_limit
    and res_pn_2 = lwt_time_it Perfect_number.perfect_numbers_c pn_limit
    in
    let%lwt () = Lwt_io.printf "perfect_numbers(%d) = %s (Elapsed time %.3fs)\n"
        pn_limit (string_of_int_list res_pn_1.result) res_pn_1.elapsed
    and () = Lwt_io.printf "perfect_numbers_c(%d) = %s (Elapsed time %.3fs)\n"
        pn_limit (string_of_int_list res_pn_2.result) res_pn_2.elapsed
    in

    let%lwt () = if enable_pn_worker then begin
      (* Lwt_io.printf "Starting worker on ports (%s) .."
        (string_of_int_list (worker_ports num_worker)) >>= fun () -> *)
      Lwt_list.map_s Lwt_perfect_number.start_worker (worker_ports num_worker) >>= fun _ ->
      (* Lwt_io.printl " done." >>= fun () -> *)
      lwt_time_it (Lwt_perfect_number.perfect_numbers_zmq (worker_ports num_worker)) pn_limit >>= fun res ->
      bind res.result (fun r -> Lwt_io.printf "perfect_numbers_zmq(%d) = %s (Elapsed time %.3fs)\n"
                          pn_limit (string_of_int_list r) res.elapsed)
    end
    else return_unit
    in

      Lwt_io.printl "" >>= fun () ->
      Lwt_io.flush Lwt_io.stdout >>= fun () ->


      Lwt_io.printl "Mandelbrot set" >>= fun () ->
      Lwt_io.printl "==============" >>= fun () ->
      lwt_time_it (fun _ -> Mandelbrot.mandelbrot 640 480 (-0.5) 0.0 (4.0/.640.)) () >>= fun res ->
      Lwt_io.printf "mandelbrot(640x480) (Elapsed time %.3fs)\n" res.elapsed >>= fun () ->
      lwt_time_it (fun _ -> Mandelbrot.mandelbrot 1920 1200 (-0.5) 0.0 (4.0/.1200.)) () >>= fun res ->
      Lwt_io.printf "mandelbrot(1920x1200) (Elapsed time %.3fs)\n" res.elapsed >>= fun () ->
      return (Image.write_ppm res.result "mandelbrot_640_480.ppm")
  end


(* cmdliner options *)
let enable_pn_worker =
  let doc = "Use multiple workers to calculate perfect numbers" in
  Arg.(value & flag & info ["enable-pn-worker"] ~docv:"PN_WORKER" ~doc)

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
