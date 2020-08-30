(* vim: set ft=ocaml sw=2 ts=2: *)

(* image.ml
 * A package for image data containers
 *)

open Bigarray

(* struct for pixel color *)
type pixel_color = { r : int; g : int; b : int }

let color_black = { r = 0; g = 0; b = 0 }
let color_white = { r = 255; g = 255; b = 255 }

(* image data container *)
(* type image = { width : int; height : int; data : pixel_color array } *)
type image = { width : int; height : int; data : (int, int8_unsigned_elt, c_layout) Array1.t }

(* generate image data *)
let make ?color:(color=color_black) width height = 
  let data = Array1.create Int8_unsigned C_layout (3 * width * height) in
  for x = 0 to (width * height - 1) do
    Array1.set data (3 * x) color.r;
    Array1.set data (3 * x + 1) color.g;
    Array1.set data (3 * x + 2) color.b
  done;
  { width = width; height = height; data = data}


  (* set pixel color *)
let set_pixel img x y color =
  if (x > (img.width - 1)) || (y > (img.height - 1)) then
    raise (Invalid_argument "Index out of bound")
  else
    Array1.set img.data (3 * x + 3 * y * img.width) color.r;
    Array1.set img.data (3 * x + 3 * y * img.width + 1) color.g;
    Array1.set img.data (3 * x + 3 * y * img.width + 2) color.b

    (* get pixel color *)
let get_pixel img x y =
  if (x > (img.width - 1)) || (y > (img.height - 1)) then
    raise (Invalid_argument "Index out of bound")
  else
    let idx_1 = 3 * x + 3 * y * img.width in
    { r = Array1.get img.data idx_1;
      g = Array1.get img.data (idx_1 + 1);
      b = Array1.get img.data (idx_1 + 2)}


    (* map function to all pixels *)
    (*
let map f img =
  let rec loop x y =
    if x < (img.width-1) then (ignore(f x y |> set_color img x y); loop (x+1) y)
    else (if y < (img.height-1) then (ignore(f x y |> set_color img x y); loop 0 (y+1))
      else (ignore(f x y |> set_color img x y); img))
    in
  loop 0 0

  *)
let map f img =
  for y = 0 to (img.height-1) do
    for x = 0 to (img.width-1) do
      f x y |> set_pixel img x y
  done
    done;
  img


  (* write image to pnm file *)
let write_ppm img file_name =
  let oc = open_out file_name in
  try
    Printf.fprintf oc "P3\n";
    Printf.fprintf oc "%d %d %d\n" img.width img.height 255;
    for i = 0 to (img.height * img.width * 3 - 1) do
      Array1.get img.data i |> string_of_int |> output_string oc;
      if ((i + 1) mod 24) = 0 then output_char oc '\n' else output_char oc ' '
  done;
    close_out oc
  with e ->
    close_out_noerr oc;
    raise e

let write_png img file_name =
  Stb_image_write.png file_name ~w:img.width ~h:img.height ~c:3 img.data

