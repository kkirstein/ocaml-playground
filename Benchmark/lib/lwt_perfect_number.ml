(* vim: set ft=ocaml sw=2 ts=2: *)

(* perfect_number.ml
 * A package to calculate Perfect numbers with asynchronous workers
*)

(* calculate perfect numbers by sending requests to a list
  * of workers. Communication is done by ZMQ *)

open Lwt.Infix

(* print_list
 * A helper function to print a list of int
*)
let print_int_list l =
  List.iter (Printf.printf "%d ") l
let string_of_int_list l =
  String.concat " " (List.map string_of_int l)

(* a simple console logger with controlled verbosity *)
let lwt_verbose ?(verbose=true) msg =
  if verbose then Lwt_io.printl msg else Lwt.return_unit

(* TCP ports for sending & receiving *)
let send_port = 5555
let recv_port = 5556

let start_worker send_port recv_port num_worker =
  let rec loop n =
    if n > 0 then
      let exe_dir = Sys.executable_name |> Filename.dirname in
      let worker_path = Filename.concat exe_dir "pn_worker" in
      let cmd_line = match Sys.os_type with
        | "Unix"	  -> String.concat " " [worker_path;
                                         (string_of_int send_port);
                                         (string_of_int recv_port); "&"]
        | "Cygwin"  -> String.concat " " [worker_path;
                                          (string_of_int send_port);
                                          (string_of_int recv_port); "&"]
        | "Win32"	  -> "start /B " ^ worker_path ^ ".exe " ^
                       (string_of_int send_port) ^ (string_of_int recv_port)
        | _         -> failwith "Unsupport system, cannot start workers"
      in
      Lwt_unix.system cmd_line >>= fun _ -> loop (n - 1)
    else Lwt.return_unit
  in
  loop num_worker

let stop_worker lwt_sock num_worker =
  let rec loop num = match num with
    | 0 -> Lwt.return_unit
    | n -> Zmq_lwt.Socket.send lwt_sock "end" >>= fun () -> loop (n - 1)
  in
  loop num_worker

let send_data sock nmax =
  let rec loop n =
    if n > nmax then Lwt.return_unit
    else Zmq_lwt.Socket.send sock (string_of_int n) >>= fun () ->
      loop (n + 1)
  in
  loop 1

let recv_data sock nmax =
  let rec loop n acc =
    if n > nmax then (* lwt_verbose ~verbose
        (Printf.sprintf "Result: %s" (string_of_int_list acc)) >>= fun () -> *)
      Lwt.return acc
    else Zmq_lwt.Socket.recv sock >>= fun ans ->
      (* lwt_verbose ~verbose ("Receiving: " ^ ans ^ "(" ^ (string_of_int n) ^ ")");
      Lwt.return ans >>= fun ans -> *)
      match String.split_on_char ':' ans with
      | "t" :: x :: [] -> let n = int_of_string x in loop (n + 1) (n :: acc)
      | "f" :: x :: [] -> let n = int_of_string x in loop (n + 1) acc
      | _         -> failwith "Invalid answer"
  in
  loop 1 []

(* let query_worker sockets nums =
   (* send requests *)
   Lwt_list.iter_s (fun (s, n) -> Zmq_lwt.Socket.send s (string_of_int n))
    (List.combine sockets nums) >>= fun () ->
  Lwt_list.map_s (fun s -> Zmq_lwt.Socket.recv s) sockets >>= fun res ->
  List.combine res nums |>
  List.filter (fun (r, _) -> r = "true") |>
  List.split |> snd |> Lwt.return *)

let perfect_numbers_zmq num_worker n =
  let z = Zmq.Context.create () in
  let send_sock = Zmq.Socket.create z Zmq.Socket.push
  and recv_sock = Zmq.Socket.create z Zmq.Socket.pull in
  Zmq.Socket.bind send_sock ("tcp://127.0.0.1:" ^ (string_of_int send_port));
  Zmq.Socket.bind recv_sock ("tcp://127.0.0.1:" ^ (string_of_int recv_port));
  let lwt_send = Zmq_lwt.Socket.of_socket send_sock
  and lwt_recv = Zmq_lwt.Socket.of_socket recv_sock in
  start_worker send_port recv_port num_worker >>= fun () ->
  let sender = send_data lwt_send n
  and receiver = recv_data lwt_recv n in
  sender >>= fun () ->
  receiver >>= fun res -> begin
    stop_worker lwt_send num_worker >>= fun () -> Lwt.return res
  end >>= fun res ->
  Zmq.Socket.close send_sock;
  Zmq.Socket.close recv_sock;
  Zmq.Context.terminate z;
  Lwt.return res

