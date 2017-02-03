(* vim: set ft=ocaml sw=2 ts=2: *)

(* work.ml
 * Do image processing in OCaml
*)

open Stb_image

(* load example image *)
let lena = load "./test_images/lena.jpg"

let () =
  match lena with
  | Ok img -> Printf.printf "Image loaded: width: %d, height: %d, channels: %d" img.height img.width img.channels
  | Error (`Msg msg) -> print_endline ("Failed loading image: " ^ msg);
  print_endline "Bye bye.."
