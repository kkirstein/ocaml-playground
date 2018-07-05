(* vim: set ft=ocaml sw=2 ts=2: *)

(* perfect_number.ml
 * A package to calculate Perfect numbers with asynchronous workers
*)

(* calculate perfect numbers by sending requests to a list
  * of workers. Communication is done by ZMQ *)
let start_worker port =
  (* let (>>=) = Lwt.(>>=) in *)
  let cmd_line = match (Sys.unix, Sys.cygwin, Sys.win32) with
    | (true, _, _)	-> "./pn_worker " ^ (string_of_int port) ^ " &"
    | (_, true, _)	-> "./pn_worker " ^ (string_of_int port) ^ " &"
    | (_, _, true)	-> "start /B pn_worker.exe " ^ (string_of_int port)
    | (_, _, _)     -> failwith "Unsupport system, cannot start workers" in
  (* Lwt_io.printl cmd_line >>= fun () -> *)
  Lwt_unix.system cmd_line

let stop_worker sockets =
  Lwt_list.iter_s (fun s -> Zmq_lwt.Socket.send s "end") sockets

let query_worker sockets nums =
  let open Lwt in
  (* send requests *)
  Lwt_list.iter_s (fun (s, n) -> Zmq_lwt.Socket.send s (string_of_int n))
    (List.combine sockets nums) >>= fun () ->
  Lwt_list.map_s (fun s -> Zmq_lwt.Socket.recv s) sockets >>= fun res ->
  List.combine res nums |>
  List.filter (fun (r, _) -> r = "true") |>
  List.split |> snd |> return

let perfect_numbers_zmq worker n =
  let open Lwt in
  let z = Zmq.Context.create () in
  let num_worker = List.length worker in
  let sockets = List.map (fun _ -> Zmq.Socket.create z Zmq.Socket.req) worker in
  List.iter2
    (fun sock port -> Zmq.Socket.connect sock ("tcp://127.0.0.1:" ^ (string_of_int port)))
    sockets worker;
  let lwt_sockets = List.map (fun s -> Zmq_lwt.Socket.of_socket s) sockets in
  let data = Listx.part (Listx.range 1 n) num_worker in
  Lwt_list.map_s (fun d -> query_worker lwt_sockets d) data >>= fun res ->
  List.flatten res |> return >>= fun res ->
  ignore(stop_worker lwt_sockets); return res >>= fun res ->
  List.iter Zmq.Socket.close sockets;
  Zmq.Context.terminate z;
  return res
