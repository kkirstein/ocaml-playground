(* vim: set ft=ocaml sw=2 ts=2: *)

(* image.mli
 * A package for image data containers
 *)

type pixel_color = { r : int; g : int; b : int }
(** RGB pixel color *)

val color_black : pixel_color
val color_white : pixel_color


(** Data container for image data *)
type image = private { width : int; height : int;
                       data : (int, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t }


(** Constructor for image data *)
val make : ?color:pixel_color -> int -> int -> image


(** Set color value for single pixel *)
val set_pixel : image -> int -> int -> pixel_color -> unit


(** Get color value of single pixel *)
val get_pixel : image -> int -> int -> pixel_color


(** Map given function to all pixels of image *)
val map : (int -> int -> pixel_color) -> image -> image


(** Write given image data to bitmap file *)
val write_ppm : image -> string -> unit

(** Write given image data to PNG file *)
val write_png : image -> string -> unit

