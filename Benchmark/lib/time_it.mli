(* vim: set ft=ocaml sw=2 ts=2: *)

(* time_it.ml
 * A module to support timing test of simple function calls
*)

(** Basic type to hold result and elapsed time of a function call *)
type 'a t = {
  elapsed: float;
  result: 'a
}

(** Calls the given function and returns its result and elpaed time in seconds *)
val time_it : ?tfun:(unit -> float) -> ('a -> 'b) -> 'a -> 'b t
