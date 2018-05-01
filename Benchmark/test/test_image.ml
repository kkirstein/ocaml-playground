(* vim: set ft=ocaml sw=2 ts=2: *)

open Tasks.Image

(* Testable types *)
let pixel_to_string pix =
  Printf.sprintf "{r=%d; g=%d; b=%d}" pix.r pix.g pix.b
let pixel = Alcotest.testable (Fmt.of_to_string pixel_to_string) (=)

(* The tests *)
let test_black () =
  Alcotest.(check pixel) "check black color" {r = 0; g = 0; b = 0} color_black
(* ---------------------- *)
let test_white () =
  Alcotest.(check pixel) "check white color" {r = 255; g = 255; b = 255} color_white
(* ---------------------- *)


(* Test set *)
let test_set = [
  "black pixel", `Quick, test_black;
  "white pixel", `Quick, test_white
]




