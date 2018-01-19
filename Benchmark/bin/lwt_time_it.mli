(* vim: set ft=ocaml sw=2 ts=2: *)

(* lwt_time_it.mli
 * A module to support asynchronous timing test of function calls
*)

(** Calls the given function and returns its result and elapsed time in seconds
  * wrapped in a Lwt thread *)
val lwt_time_it : ?tfun:(unit -> float) -> ('a -> 'b) -> 'a -> 'b Time_it.t Lwt.t
