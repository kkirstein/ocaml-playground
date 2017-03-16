(* vim: set ft=ocaml sw=2 ts=2: *)

(* perfect_number.ml
 * A package to calculate Perfect numbers
*)

(* predicate to check for a perfect number *)
let is_perfect n =
  let rec loop i sum =
    if n = i then sum = n else
    if n mod i = 0 then loop (i+1) (sum+i) else loop (i+1) sum
  in
  if n > 0 then loop 1 0 else failwith "n must be > 0"
(*$= is_perfect & ~printer:string_of_bool
  false (is_perfect 1)
  false (is_perfect 2)
  true (is_perfect 6)
  false (is_perfect 7)
  false (is_perfect 27)
  true (is_perfect 28)
  false (is_perfect 29)
*)

(* C version of predicate to check for a perfect number *)
external is_perfect_c: int -> bool = "is_perfect_c"
(*$= is_perfect_c & ~printer:string_of_bool
  false (is_perfect_c 1)
  false (is_perfect_c 2)
  true (is_perfect_c 6)
  false (is_perfect_c 7)
  false (is_perfect_c 27)
  true (is_perfect_c 28)
  false (is_perfect_c 29)
*)


(*$inject
  let pp_list_of_int l = String.concat " " (List.map string_of_int l)
*)

(* generate a list of perfect numbers until given upper limit *)
let perfect_numbers n =
  let rec loop i =
    if i = n then [] else
    if is_perfect i then i :: loop (i+1) else loop (i+1)
  in
  loop 1
(*$= perfect_numbers as pn & ~printer:pp_list_of_int
  [6; 28] (pn 100)
*)

(* generate a list of perfect numbers until given upper limit,
 * use C version of predicate *)
let perfect_numbers_c n =
  let rec loop i =
    if i = n then [] else
    if is_perfect_c i then i :: loop (i+1) else loop (i+1)
  in
  loop 1
(*$= perfect_numbers_c as pn & ~printer:pp_list_of_int
  [6; 28] (pn 100)
*)

(*
external perfect_numbers_c: int -> int list = "perfect_numbers_c"
(* -disabled- $= perfect_numbers_c as pn & ~printer:pp_list_of_int
  [6; 28] (pn 100)
*)
*)

(* calculate perfect numbers by sending requests to a list
  * of workers. Communication is done by ZMQ *)
let start_worker port =
	let (>>=) = Lwt.(>>=) in
	let cmd_line = match (Sys.unix, Sys.cygwin, Sys.win32) with
		| (true, _, _)	-> "./pn_worker " ^ (string_of_int port) ^ " &"
		| (_, true, _)	-> "./pn_worker " ^ (string_of_int port) ^ " &"
		| (_, _, true)	-> "start /B pn_worker.exe " ^ (string_of_int port) in
	Lwt_io.printl cmd_line >>= fun () ->
  Lwt_unix.system cmd_line

let stop_worker sockets =
  Lwt_list.iter_s (fun s -> Lwt_zmq.Socket.send s "end") sockets

let query_worker sockets nums =
  let open Lwt in
  (* send requests *)
  Lwt_list.iter_s (fun (s, n) -> Lwt_zmq.Socket.send s (string_of_int n))
    (List.combine sockets nums) >>= fun () ->
  Lwt_list.map_s (fun s -> Lwt_zmq.Socket.recv s) sockets >>= fun res ->
  List.combine res nums |>
  List.filter (fun (r, _) -> r = "true") |>
  List.split |> snd |> return

let perfect_numbers_zmq worker n =
  let open Lwt in
  let z = ZMQ.Context.create () in
  let num_worker = List.length worker in
  let sockets = List.map (fun _ -> ZMQ.Socket.create z ZMQ.Socket.req) worker in
  List.iter2
    (fun sock port -> ZMQ.Socket.connect sock ("tcp://127.0.0.1:" ^ (string_of_int port)))
    sockets worker;
  let lwt_sockets = List.map (fun s -> Lwt_zmq.Socket.of_socket s) sockets in
  let data = Listx.part (Listx.range 1 n) num_worker in
  Lwt_list.map_s (fun d -> query_worker lwt_sockets d) data >>= fun res ->
  List.flatten res |> return >>= fun res ->
  ignore(stop_worker lwt_sockets); return res >>= fun res ->
  List.iter ZMQ.Socket.close sockets;
  ZMQ.Context.terminate z;
  return res
