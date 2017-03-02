(* vim: set ft=ocaml sw=2 ts=2: *)

(* pn_worker.ml
 * A worker executable to check for perfect numbers
 * comunication is done via zeroMQ messages
*)

open Perfect_number

let default_port = 5555
let usage = "Usage: pn_worker [port]"

(* receiver loop *)
let rec recv_loop s =
  let open Lwt in
  Lwt_zmq.Socket.recv s >>= fun req ->
    match req with
    | "end" -> Lwt.return_unit
    | n     -> let num = int_of_string n in
                Lwt_io.printlf "Received: %d" num >>= fun () ->
                Lwt_zmq.Socket.send s (string_of_bool (is_perfect num)) >>= fun () -> recv_loop s

(* main entry point *)
let () =
  (* check input argument *)
  let port = match Array.length Sys.argv with
    | 1 -> default_port
    | 2 -> int_of_string Sys.argv.(1)
    | _ -> failwith usage in

  Lwt_main.run begin
    let open Lwt in
    let z = ZMQ.Context.create () in
    let socket = ZMQ.Socket.create z ZMQ.Socket.rep in
    ZMQ.Socket.bind socket ("tcp://127.0.0.1:" ^ (string_of_int port));
    Lwt_io.printlf "Listening on port: %d\n" port >>= fun () ->
    let lwt_socket = Lwt_zmq.Socket.of_socket socket in
    recv_loop lwt_socket
  end
