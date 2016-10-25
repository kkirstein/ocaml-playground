(* vim: set ft=ocaml sw=2 ts=2: *)

(* color_map.ml
 * A package for image color maps
 *)

val plan9 : Image.pixel_color array
(** Plan9 is a 256-color palette that partitions the 24-bit RGB space
 * into 4×4×4 subdivision; with 4 shades in each subcube.
 *)

