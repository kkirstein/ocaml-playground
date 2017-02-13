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


(*$inject
  let string_of_cmode = function
    | RGB   -> "RGB"
    | Gray  -> "Gray"

  let img_pp img =
    match img with
    | Int i   -> Printf.sprintf "Int: {width: %d, height: %d, channels: %d, cmode: %s}"
                  i.width i.height i.channels (string_of_cmode i.cmode)
    | Float i -> Printf.sprintf "Float: {width: %d, height: %d, channels: %d, cmode: %s}"
                  i.width i.height i.channels (string_of_cmode i.cmode)
*)
(*$inject
  let img_rgb = {width = 180; height = 120; channels = 3; cmode = RGB;
                  data = Bigarray.Genarray.create Bigarray.Int8_unsigned Bigarray.C_layout [|120; 180; 3|]}
  let img_rgb_f = {width = 180; height = 120; channels = 3; cmode = RGB;
                  data = Bigarray.Genarray.create Bigarray.Float32 Bigarray.C_layout [|120; 180; 3|]}
 *)

(** check image for given color mode and number of channels
  * throws an exception if given constraints are violated *)
let check_int ?channels ?color_mode img =
  match img with
  | Int i   -> begin
    match channels, color_mode with
    | Some ch, Some cm  -> if ch <> i.channels then failwith "Wrong number of channels"
                            else if cm <> i.cmode then failwith "Wrong color mode"
                            else i
    | Some ch, None     -> if ch <> i.channels then failwith "Wrong number of channels"
                            else i
    | None, Some cm     -> if cm <> i.cmode then failwith "Wrong color mode"
                            else i
    | None, None ->  i
    end
  | _       -> failwith "Wrong data type, expected Int"
(*$= check_int
  img_rgb (check_int ~channels:3 ~color_mode:RGB (Int img_rgb))
  img_rgb (check_int ~color_mode:RGB (Int img_rgb))
  img_rgb (check_int ~channels:3 (Int img_rgb))
  img_rgb (check_int (Int img_rgb))
*)
(*$T check_int
  try ignore(check_int ~color_mode:Gray (Int img_rgb)); false with Failure _ -> true
  try ignore(check_int ~channels:2 (Int img_rgb)); false with Failure _ -> true
  try ignore(check_int (Float img_rgb_f)); false with Failure _ -> true
*)

let check_float ?channels ?color_mode img =
  match img with
  | Float i   -> begin
    match channels, color_mode with
    | Some ch, Some cm  -> if ch <> i.channels then failwith "Wrong number of channels"
                            else if cm <> i.cmode then failwith "Wrong color mode"
                            else i
    | Some ch, None     -> if ch <> i.channels then failwith "Wrong number of channels"
                            else i
    | None, Some cm     -> if cm <> i.cmode then failwith "Wrong color mode"
                            else i
    | None, None ->  i
    end
  | _       -> failwith "Wrong data type, expected Float"
  (*$= check_float
    img_rgb_f (check_float ~channels:3 ~color_mode:RGB (Float img_rgb_f))
    img_rgb_f (check_float ~color_mode:RGB (Float img_rgb_f))
    img_rgb_f (check_float ~channels:3 (Float img_rgb_f))
    img_rgb_f (check_float (Float img_rgb_f))
  *)
  (*$T check_float
    try ignore(check_float ~color_mode:Gray (Float img_rgb_f)); false with Failure _ -> true
    try ignore(check_float ~channels:2 (Float img_rgb_f)); false with Failure _ -> true
    try ignore(check_float (Int img_rgb)); false with Failure _ -> true
  *)


(* convert RGB image to grayscale *)
let convert_color_rgb_gray img =
  match img with
    | Int img'    -> begin
      let buf = array3_of_genarray img'.data in
      let new_buf = Array2.create Bigarray.Int8_unsigned c_layout img'.width img'.height in
      (for x = 0 to (img'.width - 1) do
        for y = 0 to (img'.height - 1) do
					let (r, g, b) = Array3.(get buf x y 0, get buf x y 1, get buf x y 2) in
          let new_val = int_of_float (0.299*.(float_of_int r) +. 0.587*.(float_of_int g) +. 0.114*.(float_of_int b)) in
					Array2.set new_buf x y new_val
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
					let (r, g, b) = Array3.(get buf 0 x y, get buf 1 x y, get buf 2 x y) in
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
