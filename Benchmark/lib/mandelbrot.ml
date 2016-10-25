(* vim: set ft=ocaml sw=2 ts=2: *)

(* mandelbrot.ml
 * A package to Mandelbrot sets
 *)

(* calculate pixel value *)
let pixel_value x y n_max r_max =
  let z0 = {Complex.re = x; Complex.im = y} in
  let rec loop z n =
    if (Complex.norm z > r_max) || (n = 0) then n
    else loop (Complex.add (Complex.mul z z) z0) (n-1)
  in
  loop Complex.zero n_max
;;

(* select color for given pixel value *)
let color_of_value value = 
  if value > Array.length Color_map.plan9 then Image.color_black
  else Color_map.plan9.(value)
;;

let bw_of_value value = 
  if value > 0 then Image.color_white else Image.color_black
;;

(* generate mandelbrot set *)
let mandelbrot width height center_x center_y pixel_size =
  let mandel = Image.make width height
  and x_offset = center_x -. 0.5 *. pixel_size *. (float_of_int width)
  and y_offset = center_y +. 0.5 *. pixel_size *. (float_of_int height)
  in
  let pixel_fun x y = 
    let x_val = (float_of_int x) *. pixel_size +. x_offset
    and y_val = (float_of_int y) *. pixel_size -. y_offset
    in
    pixel_value x_val y_val 255 2.0 |> color_of_value
  in
  Image.map pixel_fun mandel
;;


