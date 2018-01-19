(* vim: set ft=ocaml sw=2 ts=2: *)

(* lwt_time_it.ml
 * A module to support asynchronous timing test of function calls
*)

(* async version of time_it, utilizing Lwt *)
let lwt_time_it ?(tfun=Sys.time) action arg =
  Lwt.return (Time_it.time_it ~tfun action arg)
