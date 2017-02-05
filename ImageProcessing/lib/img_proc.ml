(* vim: set ft=ocaml sw=2 ts=2: *)

(* image_processing.ml
 * Module for basic image processing functions
*)

open Bigarray


(* color mode of image data *)
type color_mode =
	| RGB

(* buffer for image data *)
type 'kind buffer = ('a, 'b, c_layout) Array1.t
  constraint 'kind = ('a, 'b) kind

(* basic type for image data *)
type 'kind t = {
  width: int;
  height: int;
  channels: int;
	cmode: color_mode;
  data: 'kind buffer;
}




