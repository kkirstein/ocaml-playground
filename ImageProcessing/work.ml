(* vim: set ft=ocaml sw=2 ts=2: *)

(* work.ml
 * Do image processing in OCaml
*)

open Img_proc
open Img_proc_io

(* load example image *)
let lena = load "./test_images/lena.jpg"
let fruits = load "./test_images/fruits.jpg"

let () =
  Printf.printf "Fruits image loaded: width: %d, height: %d, channels: %d\n"
                      (width fruits) (height fruits) (channels fruits);
  let gray_fruits = convert_color ~src_mode:RGB ~dest_mode:Gray fruits in
  Printf.printf "Fruits image grayscale: width: %d, height: %d, channels: %d\n"
                      (width fruits) (height fruits) (channels fruits);
  write ~format:PNM "./test_output/fruits.ppm" fruits;
  write ~format:PNG "./test_output/fruits.png" fruits;
  write ~format:PNM "./test_output/fruits_gray.pgm" gray_fruits;
  write ~format:PNG "./test_output/fruits_gray.png" gray_fruits;

  Printf.printf "Lena image loaded: width: %d, height: %d, channels: %d\n"
                        (width lena) (height lena) (channels lena);
  let lena_gray = convert_color ~src_mode:RGB ~dest_mode:Gray lena in
  Printf.printf "Lena image grayscale: width: %d, height: %d, channels: %d\n"
                        (height lena_gray) (width lena_gray) (channels lena_gray);
  write ~format:PNG "./test_output/lena_gray.png" lena_gray;
  write ~format:PNG "./test_output/lena.png" lena;
  print_endline "Bye bye.."
