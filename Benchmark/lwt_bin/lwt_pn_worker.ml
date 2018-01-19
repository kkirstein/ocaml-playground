(* vim: set ft=ocaml sw=2 ts=2: *)

(* pn_worker.ml
 * A worker executable to check for perfect numbers
 * comunication is done via zeroMQ messages
*)

open Perfect_number
open Cmdliner

let default_port = 5555
(* let usage = "Usage: pn_worker [port]" *)

(* a simple console logger with controlled verbosity *)
let lwt_verbose ?(verbose=true) msg =
  if verbose then Lwt_io.printl msg else Lwt.return_unit

(* receiver loop *)
let rec recv_loop ~verbose s p =
  let open Lwt in
  Lwt_zmq.Socket.recv s >>= fun req ->
  match req with
  | "end" ->  lwt_verbose ~verbose (Printf.sprintf "%d: Stopping\n" p)
  | n     ->  let res = (int_of_string n) |> is_perfect in
    (if res then lwt_verbose ~verbose (Printf.sprintf "%d: %s" p n)
     else return_unit) >>= fun () ->
    Lwt_zmq.Socket.send s (string_of_bool res) >>= fun () ->
    recv_loop ~verbose s p

(* receive/send loop *)
let main verbose port =
  Lwt_main.run begin
    let open Lwt in
    let z = ZMQ.Context.create () in
    let socket = ZMQ.Socket.create z ZMQ.Socket.rep in
    ZMQ.Socket.bind socket ("tcp://127.0.0.1:" ^ (string_of_int port));
    lwt_verbose ~verbose (Printf.sprintf "Listening on port: %d\n" port) >>= fun () ->
    let lwt_socket = Lwt_zmq.Socket.of_socket socket in
    recv_loop ~verbose lwt_socket port >>= fun () ->
    ZMQ.Socket.close socket;
    ZMQ.Context.terminate z |> return
  end

(* cmdliner options *)
let verbose =
  let doc = "Print status information to STDOUT" in
  Arg.(value & flag & info ["verbose"] ~docv:"VERBOSE" ~doc)

let port =
  let doc = "Port on which worker is listening for input. Default: " ^
            (string_of_int default_port) in
  Arg.(value & pos ~rev:true 0 int default_port & info [] ~docv:"PORT" ~doc)

let cmd =
  let doc = "Starts a worker process to calculate perfect numbers" in
  let man = [
    `S "DESCRIPTION";
    `P "$(tname) checks wheter a given number is perfect.contents
        This means that all its factors sum up to itself. Communication
        with the worker is done via ZMQ, enabling a asynchronous and parallel
        execution.";
    `P "If $(b,VERBOSE) is given, status information of the worker is
        printed to STDOUT."]
  in
  Term.(const main $ verbose $ port),
  Term.info "pn_worker" ~version:"0.1.0" ~doc ~man

(* main entry point *)
let () =
  match Term.eval cmd with
  | `Error _  -> exit 1
  | _         -> exit 0
