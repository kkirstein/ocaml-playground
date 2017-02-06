(* vim: set ft=ocaml sw=2 ts=2: *)

(* image_processing.ml
 * Module for basic image processing functions
*)

open Bigarray


(* color mode of image data *)
type color_mode =
	| RGB
  | Gray

(* buffer to hold pixel data *)
type ('a, 'b) image_buffer =
  ('a, 'b, c_layout) Genarray.t

(* low-level image data type *)
type ('a, 'b) image = {
  width: int;
  height: int;
  channels: int;
  cmode: color_mode;
  data: ('a, 'b) image_buffer
}

(* high-level image data type *)
type t =
  | Int of (int, int8_unsigned_elt) image
  | Float of (float, float32_elt) image

(* some accessor functions *)
let width img =
  match img with
    | Int img'    -> img'.width
    | Float img'  -> img'.width
let height img =
  match img with
    | Int img'    -> img'.height
    | Float img'  -> img'.height
let channels img =
  match img with
    | Int img'    -> img'.channels
    | Float img'  -> img'.channels


(* convert RGB image to grayscale *)
let convert_color_rgb_gray img =
  match img with
    | Int img'    -> begin
      let buf = array3_of_genarray img'.data in
      let new_buf = Array2.create Bigarray.Int8_unsigned c_layout img'.width img'.height in
      (for x = 0 to img'.height do
        for y = 0 to img'.width do
        let (r, g, b) = Array3.(get buf x y 0, get buf x y 1, get buf x y 2) in
        Array2.set new_buf x y
          (int_of_float (0.299*.(float_of_int r) +. 0.587*.(float_of_int g) +. 0.114*.(float_of_int b)))
        done
      done);
      Int {width = img'.width; height = img'.height; channels = 1; cmode = Gray;
        data = genarray_of_array2 new_buf}
      end
    | Float img'  -> begin
      let buf = array3_of_genarray img'.data in
      let new_buf = Array2.create Bigarray.Float32 c_layout img'.width img'.height in
      (for x = 0 to img'.height do
        for y = 0 to img'.width do
        let (r, g, b) = Array3.(get buf x y 0, get buf x y 1, get buf x y 2) in
        Array2.set new_buf x y (0.299*.r +. 0.587*.g +. 0.114*.b)
        done
      done);
      Float {width = img'.width; height = img'.height; channels = 1; cmode = Gray;
        data = genarray_of_array2 new_buf}
    end

(* convert grayscale image to RGB *)
let convert_color_gray_rgb img =
  ()

(* convert RGB image to HSV *)
let convert_color_rgb_hsv img =
  ()

(* convert HSV image to RGB *)
let convert_color_hsv_rgb img =
    ()

(** convert color mode to given destination mode
 * the image data is copied into a new image struct *)
let convert_color ~src_mode ~dest_mode img =
  match (src_mode, dest_mode) with
  | (RGB, Gray) -> convert_color_rgb_gray img
  | _           -> failwith "The given color conversion is not supported."
