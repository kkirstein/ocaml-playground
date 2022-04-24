(* vim: set ft=ocaml sw=2 ts=2: *)

(* pn_worker.ml
 * A worker executable to check for perfect numbers
 * comunication is done via zeroMQ messages
 *)

(* open Tasks.Mandelbrot *)
open Cmdliner

(* worker function *)
let main _verbose _in_port _out_port = Lwt_main.run Lwt.return_unit

(* cmdliner options *)
let verbose =
  let doc = "Print status information to STDOUT" in
  Arg.(value & flag & info [ "verbose" ] ~docv:"VERBOSE" ~doc)

let in_port =
  let doc = "Port on which worker is listening for input." in
  Arg.(required & pos 0 (some int) None & info [] ~docv:"INPUT_PORT" ~doc)

let out_port =
  let doc = "Port on which worker is sending the results." in
  Arg.(
    required
    & pos ~rev:true 0 (some int) None
    & info [] ~docv:"OUTPUT_PORT" ~doc)

let cmd =
  let doc = "Starts a worker process to calculate a line of a Mandelbrot set" in
  let man =
    [
      `S "DESCRIPTION";
      `P
        "$(tname) reads coordinate infos from the given $(b,INPUT_PORT)\n\
        \        and calcuates the respective pixel values (RGB). The result\n\
        \        is sent to the given $(b,OUTPUT_PORT). Communication\n\
        \        with the worker is done via ZMQ, enabling an asynchronous and \
         parallel\n\
        \        execution.";
      `P
        "If $(b,VERBOSE) is given, status information of the worker is\n\
        \        printed to STDOUT.";
    ]
  in
  Cmd.v
    (Cmd.info "mb_worker" ~version:"0.1.0" ~doc ~man)
    Term.(const main $ verbose $ in_port $ out_port)

(* main entry point *)
let () = exit (Cmd.eval cmd)
