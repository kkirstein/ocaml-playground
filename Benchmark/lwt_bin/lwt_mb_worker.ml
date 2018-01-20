(* vim: set ft=ocaml sw=2 ts=2: *)

(* pn_worker.ml
 * A worker executable to check for perfect numbers
 * comunication is done via zeroMQ messages
*)

open Tasks.Mandelbrot
open Cmdliner

(* worker function *)
let main verbose in_port out_port =
  Lwt_main.run begin
    Lwt.return_unit
  end

(* cmdliner options *)
let verbose =
  let doc = "Print status information to STDOUT" in
  Arg.(value & flag & info ["verbose"] ~docv:"VERBOSE" ~doc)

let in_port =
  let doc = "Port on which worker is listening for input." in
  Arg.(required & pos 0 (some int) None & info [] ~docv:"INPUT_PORT" ~doc)

let out_port =
  let doc = "Port on which worker is sending the results." in
  Arg.(required & pos ~rev:true 0 (some int) None & info [] ~docv:"OUTPUT_PORT" ~doc)

let cmd =
  let doc = "Starts a worker process to calculate a line of a Mandelbrot set" in
  let man = [
    `S "DESCRIPTION";
    `P "$(tname) reads coordinate infos from the given $(v,INPUT_PORT)
        and calcuates the respective pixel values (RGB). The result
        is sent to the given $(v,OUTPUT_PORT). Communication
        with the worker is done via ZMQ, enabling an asynchronous and parallel
        execution.";
    `P "If $(b,VERBOSE) is given, status information of the worker is
        printed to STDOUT."]
  in
  Term.(const main $ verbose $ in_port $ out_port),
  Term.info "mb_worker" ~version:"0.1.0" ~doc ~man

(* main entry point *)
let () =
  match Term.eval cmd with
  | `Error _  -> exit 1
  | _         -> exit 0

