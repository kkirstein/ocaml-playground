(* vim: set ft=ocaml sw=2 ts=2: *)

(* image.mli
 * A package for image data containers
 *)

type pixel_color = { r : int; g : int; b : int }
(** RGB pixel color *)

val color_black : pixel_color
val color_white : pixel_color


type image = private { width : int; height : int; data : pixel_color array }
(** Data container for image data *)

val make : ?color:pixel_color -> int -> int -> image
(** Constructor for image data *)

val set_color : image -> int -> int -> pixel_color -> unit
(** Set color value for single pixel *)

val map : (int -> int -> pixel_color) -> image -> image
(** Map given function to all pixels of image *)

val write_ppm : image -> string -> unit
(** Write given image data to bitmap file *)

