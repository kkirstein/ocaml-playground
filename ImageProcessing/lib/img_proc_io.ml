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
                  data = Bigarray.genarray_of_array1 img.data})
    | Error (`Msg msg)  -> failwith msg

(* write image to file *)
let write filename img =
  match img with
    | Img_proc.Int img' -> Img_proc.(png filename ~w:img'.width ~h:img'.height
                            ~c:img'.channels (Bigarray.array1_of_genarray img'.data))
    | Img_proc.Float _  -> failwith "Float images are currently not supported"
