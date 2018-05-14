(* vim: set ft=ocaml sw=2 ts=2: *)

open Tasks.Image

(* Testable types *)
let pixel_to_string pix =
  Printf.sprintf "{r=%d; g=%d; b=%d}" pix.r pix.g pix.b
let pixel = Alcotest.testable (Fmt.of_to_string pixel_to_string) (=)
let image_to_string img =
  Printf.sprintf "{width: %d; height: %d; data=%s, ..}"
    img.width img.height (pixel_to_string img.data.(0))
let image = Alcotest.testable (Fmt.of_to_string image_to_string) (=)

(* The tests *)
let test_black () =
  Alcotest.(check pixel) "check black color" {r = 0; g = 0; b = 0} color_black
(* ---------------------- *)
let test_white () =
  Alcotest.(check pixel) "check white color" {r = 255; g = 255; b = 255} color_white
(* ---------------------- *)
let test_make_image () =
  let img = make 640 480 in
  Alcotest.(check int) "check make image width" 640 img.width;
  Alcotest.(check int) "check make image height" 480 img.height;
  Alcotest.(check bool) "check make image default color" true
    (Array.for_all (fun p -> p = {r=0; g=0; b=0}) img.data)
(* ---------------------- *)
let test_make_image_color () =
  let img = make ~color:{r=128; g=64; b=240} 320 200 in
  Alcotest.(check int) "check make image width" 320 img.width;
  Alcotest.(check int) "check make image height" 200 img.height;
  Alcotest.(check bool) "check make image color" true
    (Array.for_all (fun p -> p = {r=128; g=64; b=240}) img.data)
(* ---------------------- *)
let test_set_color () =
  let img = make 320 200 in
  set_color img 160 100 {r=128; g=96; b=204};
  Alcotest.(check pixel) "check changed pixel" {r=128; g=96; b=204}
    img.data.(160 + 100*img.width);
  Alcotest.(check pixel) "check changed pixel" {r=0; g=0; b=0}
    img.data.(0);
  Alcotest.(check pixel) "check changed pixel" {r=0; g=0; b=0}
    img.data.(319 + 99*img.width)



(* Test set *)
let test_set = [
  "black pixel", `Quick, test_black;
  "white pixel", `Quick, test_white;
  "make image", `Quick, test_make_image;
  "make image with color", `Quick, test_make_image_color;
  "change pixel color", `Quick, test_set_color
]




