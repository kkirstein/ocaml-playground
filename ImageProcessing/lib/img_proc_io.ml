(* vim: set ft=ocaml sw=2 ts=2: *)

(* img_proc_io.ml
 * Reading & writing of images.
 * This are simple wrappers around the Stb_image module
*)

open Stb_image
open Stb_image_write

(* Pixel layout as return by Stb_image:
// An output image with N components has the following components interleaved
// in this order in each pixel:
//
//     N=#comp     components
//       1           grey
//       2           grey, alpha
//       3           red, green, blue
//       4           red, green, blue, alpha
*)

(* load image from file *)
let load ?channels filename =
  match load ?channels filename with
    | Ok img  -> Img_proc.(Int {width = img.width; height = img.height;
                  channels = img.channels; cmode = RGB;
                  data = Bigarray.reshape (Bigarray.genarray_of_array1 img.data) [|img.channels; img.width; img.height|]})
    | Error (`Msg msg)  -> failwith msg

(* Supported image file formats *)
type fileformat =
  | PNG
  | BMP

let fix_array w h ary =
  let new_ary = Bigarray.Array1.create Bigarray.Int8_unsigned Bigarray.C_layout (w*h*3) in
  for idx = 0 to (w*h - 1) do
    Bigarray.Array1.set new_ary (idx*3) (Bigarray.Array1.get ary idx);
    Bigarray.Array1.set new_ary (idx*3+1) (Bigarray.Array1.get ary idx);
    Bigarray.Array1.set new_ary (idx*3+2) (Bigarray.Array1.get ary idx)
  done;
  new_ary


(* write image to file *)
let write_png filename img =
  let open Img_proc in
  match img with
    | Img_proc.Int img' -> let data = Bigarray.reshape_1 img'.data (img'.channels*img'.width*img'.height) in
                            png filename ~w:img'.width ~h:img'.height ~c:img'.channels data
    | Img_proc.Float _  -> failwith "Float images are currently not supported"

let write_bmp filename img =
  match img with
    | Img_proc.Int img' -> let data = Img_proc.(Bigarray.reshape_1 img'.data (img'.channels*img'.width*img'.height)) in
                            Img_proc.(bmp filename ~w:img'.width ~h:img'.height ~c:img'.channels data)
    | Img_proc.Float _  -> failwith "Float images are currently not supported"

let write ~format filename img =
  match format with
  | PNG -> write_png filename img
  | BMP -> write_bmp filename img
  (* | _   -> failwith "Format not supported" *)
