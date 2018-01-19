(* vim: set ft=ocaml sw=2 ts=2: *)

(* lwt_time_it.mli
 * A module to support asynchronous timing test of function calls
*)

(** Basic type to hold result and elapsed time of a function call *)
type 'a t = {
  elapsed: float;
  result: 'a
}

(** Calls the given function and returns its result and elapsed time in seconds
  * wrapped in a Lwt thread *)
val lwt_time_it : ?tfun:(unit -> float) -> ('a -> 'b) -> 'a -> 'b t Lwt.t
