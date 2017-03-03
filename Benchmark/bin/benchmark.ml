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
let () = Lwt_main.run begin
  let open Lwt in
  Lwt_io.printl "Fibonacci numbers" >>= fun () ->
  Lwt_io.printl "=================" >>= fun () ->

  lwt_time_it Fibonacci.fib_naive 35 >>= fun res ->
  Lwt_io.printf "fib_naive(35) = %d (Elapsed time %.3fs)\n"
    res.result res.elapsed >>= fun () ->
  lwt_time_it Fibonacci.fib 35 >>= fun res ->
  Lwt_io.printf "fib(35) = %s (Elapsed time %.3fs)\n"
    (Big_int.string_of_big_int res.result) res.elapsed >>= fun () ->
  lwt_time_it Fibonacci.fib 1000 >>= fun res ->
  Lwt_io.printf "fib(1000) = %s (Elapsed time %.3fs)\n"
    (Big_int.string_of_big_int res.result) res.elapsed >>= fun () ->
  Lwt_io.printl "" >>= fun () ->

  Lwt_io.printl "Perfect numbers" >>= fun () ->
  Lwt_io.printl "===============" >>= fun () ->
  lwt_time_it Perfect_number.perfect_numbers pn_limit >>= fun res ->
  Lwt_io.printf "perfect_numbers(%d) = %s (Elapsed time %.3fs)\n"
    pn_limit (string_of_int_list res.result) res.elapsed >>= fun () ->
  lwt_time_it Perfect_number.perfect_numbers_c pn_limit >>= fun res ->
  Lwt_io.printf "perfect_numbers_c(%d) = %s (Elapsed time %.3fs)\n"
    pn_limit (string_of_int_list res.result) res.elapsed >>= fun () ->
  Lwt_io.printf "Starting worker on ports (%s) .."
    (string_of_int_list (worker_ports num_worker)) >>= fun () ->
  Lwt_list.iter_s (fun el -> return_unit) (worker_ports num_worker) >>= fun () ->
  Lwt_io.printl " done." >>= fun () ->
  lwt_time_it (Perfect_number.perfect_numbers_zmq (worker_ports num_worker)) pn_limit >>= fun res ->
  bind res.result (fun r -> Lwt_io.printf "perfect_numbers_zmq(%d) = %s (Elapsed time %.3fs)\n"
    pn_limit (string_of_int_list r) res.elapsed) >>= fun () ->

  Lwt_io.printl "" >>= fun () ->
  Lwt_io.printl "Mandelbrot set" >>= fun () ->
  Lwt_io.printl "==============" >>= fun () ->
  lwt_time_it (fun _ -> Mandelbrot.mandelbrot 640 480 (-0.5) 0.0 (4.0/.640.)) () >>= fun res ->
  Lwt_io.printf "mandelbrot(640x480) (Elapsed time %.3fs)\n" res.elapsed >>= fun () ->
  lwt_time_it (fun _ -> Mandelbrot.mandelbrot 1920 1200 (-0.5) 0.0 (4.0/.1200.)) () >>= fun res ->
  Lwt_io.printf "mandelbrot(1920x1200) (Elapsed time %.3fs)\n" res.elapsed >>= fun () ->
  return (Image.write_ppm res.result "mandelbrot_640_480.ppm") >>= fun () ->

  Lwt_io.printl "" >>= fun () ->

  Lwt_io.printl "Press ENTER to continue.." >>= fun () ->
  Lwt_io.read_char Lwt_io.stdin >>= fun c -> Lwt.return_unit
end
