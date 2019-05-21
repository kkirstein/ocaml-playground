(* vim: set ft=ocaml sw=2 ts=2: *)

(* pn_worker.ml
 * A worker executable to check for perfect numbers
 * comunication is done via zeroMQ messages
*)

open Tasks.Perfect_number
open Cmdliner

let default_in_port = 5555
let default_out_port = 5556
(* let usage = "Usage: pn_worker [port]" *)

(* a simple console logger with controlled verbosity *)
let lwt_verbose ?(verbose=true) msg =
  if verbose then Lwt_io.printl msg else Lwt.return_unit

(* receiver loop *)
let rec recv_loop ~verbose recv send =
  let open Lwt in
  Zmq_lwt.Socket.recv recv >>= fun req ->
  match req with
  | "end" ->  lwt_verbose ~verbose "Stopping\n"
  | n     ->  let res = if is_perfect (int_of_string n) 
                then "t:" ^ n
                else "f:" ^ n in
    lwt_verbose ~verbose ("Sending: " ^ res) >>= fun () ->
    Zmq_lwt.Socket.send send res >>= fun () ->
    recv_loop ~verbose recv send

(* receive/send loop *)
let main verbose in_port out_port =
  Lwt_main.run begin
    let open Lwt in
    let z = Zmq.Context.create () in
    let in_socket = Zmq.Socket.create z Zmq.Socket.pull
    and out_socket = Zmq.Socket.create z Zmq.Socket.push in
    Zmq.Socket.connect in_socket ("tcp://127.0.0.1:" ^ (string_of_int in_port));
    Zmq.Socket.connect out_socket ("tcp://127.0.0.1:" ^ (string_of_int out_port));
    lwt_verbose ~verbose (Printf.sprintf "Listening on port: %d\n" in_port) >>= fun () ->
    lwt_verbose ~verbose (Printf.sprintf "Sending to port: %d\n" out_port) >>= fun () ->
    let recv = Zmq_lwt.Socket.of_socket in_socket
    and send = Zmq_lwt.Socket.of_socket out_socket in
    recv_loop ~verbose recv send >>= fun () ->
    Zmq.Socket.close in_socket;
    Zmq.Socket.close out_socket;
    Zmq.Context.terminate z |> return
  end

(* cmdliner options *)
let verbose =
  let doc = "Print status information to STDOUT" in
  Arg.(value & flag & info ["verbose"] ~docv:"VERBOSE" ~doc)

let in_port =
  let doc = "Port on which worker is receiving input data." in
  Arg.(required & pos 0 (some int) None & info [] ~docv:"IN_PORT" ~doc)

let out_port =
  let doc = "Port on which worker is sending its data." in
  Arg.(required & pos 1 (some int) None & info [] ~docv:"OUT_PORT" ~doc)

let cmd =
  let doc = "Starts a worker process to calculate perfect numbers" in
  let man = [
    `S "DESCRIPTION";
    `P "$(tname) checks whether a given number is perfect.
        This means that all its factors sum up to itself. Communication
        with the worker is done via ZMQ, enabling a asynchronous and parallel
        execution.";
    `P "If $(b,VERBOSE) is given, status information of the worker is
        printed to STDOUT."]
  in
  Term.(const main $ verbose $ in_port $ out_port),
  Term.info "pn_worker" ~version:"0.2.0" ~doc ~man

(* main entry point *)
let () =
  match Term.eval cmd with
  | `Error _  -> exit 1
  | _         -> exit 0
