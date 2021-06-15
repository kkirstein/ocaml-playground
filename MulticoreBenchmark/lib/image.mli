(* vim: set ft=ocaml sw=2 ts=2: *)

(* image.mli
 * A package for image data containers
 *)

type pixel_color = { r : int; g : int; b : int }
(** RGB pixel color *)

val color_black : pixel_color

val color_white : pixel_color

type image = private {
  width : int;
  height : int;
  data : (int, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t;
}
(** Data container for image data *)

val make : ?color:pixel_color -> int -> int -> image
(** Constructor for image data *)

val set_pixel : image -> int -> int -> pixel_color -> unit
(** Set color value for single pixel *)

val get_pixel : image -> int -> int -> pixel_color
(** Get color value of single pixel *)

val map : (int -> int -> pixel_color) -> image -> image
(** [map f img] applies [f] to all pixels of given image [img]. *)

val par_map :
  pool:Domainslib.Task.pool -> (int -> int -> pixel_color) -> image -> image
(** [par_map ~pool f img] is the parallel version of {!map}. *)

val write_ppm : image -> string -> unit
(** Write given image data to bitmap file *)
