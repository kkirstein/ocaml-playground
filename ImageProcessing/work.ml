(* vim: set ft=ocaml sw=2 ts=2: *)

(* work.ml
 * Do image processing in OCaml
*)

open Img_proc
open Img_proc_io

(* load example image *)
let lena = load "./test_images/lena.jpg"

let () =
  Printf.printf "Image loaded: width: %d, height: %d, channels: %d\n"
                        (height lena) (width lena) (channels lena);
  let gray_img = convert_color ~src_mode:RGB ~dest_mode:Gray lena in
  Printf.printf "Grayscale image: width: %d, height: %d, channels: %d\n"
                        (height gray_img) (width gray_img) (channels gray_img);
  write "./test_output/lena_gray.png" gray_img;
  write "./test_output/lena.png" lena;
  print_endline "Bye bye.."
