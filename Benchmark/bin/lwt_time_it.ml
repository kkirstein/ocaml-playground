(* vim: set ft=ocaml sw=2 ts=2: *)

(* lwt_time_it.ml
 * A module to support asynchronous timing test of function calls
*)

(* a struct to hold both the timing information and result
   of a function call *)
type 'a t = {
  elapsed: float;
  result: 'a
}

(* the work-horse function *)
let time_it ?(tfun=Sys.time) action arg =
  let start_time = tfun () in
  let res = action arg in
  let finish_time = tfun () in
  {elapsed = finish_time -. start_time; result = res}

(* async version of time_it, utilizing Lwt *)
let lwt_time_it ?(tfun=Sys.time) action arg =
  Lwt.return (time_it ~tfun action arg)
