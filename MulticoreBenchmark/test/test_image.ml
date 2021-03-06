(* vim: set ft=ocaml sw=2 ts=2: *)

open Tasks.Image

(* Testable types *)
let pixel_to_string pix =
  Printf.sprintf "{r=%d; g=%d; b=%d}" pix.r pix.g pix.b
let pixel = Alcotest.testable (Fmt.of_to_string pixel_to_string) (=)
let image_to_string img =
  Printf.sprintf "{width: %d; height: %d; data=%s, ..}"
    img.width img.height (get_pixel img 0 0 |> pixel_to_string)
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
  Alcotest.(check pixel) "check make image pixel value"
    {r=0; g=0; b=0}
    (get_pixel img 0 0)
(* ---------------------- *)
let test_make_image_slow () =
  let img = make 640 480 in
  Alcotest.(check int) "check make image width" 640 img.width;
  Alcotest.(check int) "check make image height" 480 img.height;
  for y = 0 to (img.height - 1) do
    for x = 0 to (img.width - 1) do
      Alcotest.(check pixel) (Printf.sprintf "check make image pixel (%d,%d)" x y)
        {r=0; g=0; b=0}
        (get_pixel img x y)
    done
  done
(* ---------------------- *)
let test_make_image_color () =
  let img = make ~color:{r=128; g=64; b=240} 320 200 in
  Alcotest.(check int) "check make image width" 320 img.width;
  Alcotest.(check int) "check make image height" 200 img.height;
      Alcotest.(check pixel) "check make image pixel value"
        {r=128; g=64; b=240}
        (get_pixel img 0 0)
(* ---------------------- *)
let test_make_image_color_slow () =
  let img = make ~color:{r=128; g=64; b=240} 320 200 in
  Alcotest.(check int) "check make image width" 320 img.width;
  Alcotest.(check int) "check make image height" 200 img.height;
  for y = 0 to (img.height - 1) do
    for x = 0 to (img.width - 1) do
      Alcotest.(check pixel) (Printf.sprintf "check make image pixel (%d,%d)" x y)
        {r=128; g=64; b=240}
        (get_pixel img x y)
    done
  done
(* ---------------------- *)
let test_set_color () =
  let img = make 320 200 in
  set_pixel img 160 100 {r=128; g=96; b=204};
  Alcotest.(check pixel) "check changed pixel" {r=128; g=96; b=204}
    (get_pixel img 160 100);
  Alcotest.(check pixel) "check unchanged pixel" {r=0; g=0; b=0}
    (get_pixel img 0 0);
  Alcotest.(check pixel) "check unchanged pixel" {r=0; g=0; b=0}
    (get_pixel img 319 99)
(* ---------------------- *)
let test_get_color () =
  let img = make 320 200 in
  set_pixel img 160 100 {r=128; g=96; b=204};
  Alcotest.(check pixel) "check changed pixel" {r=128; g=96; b=204}
    (get_pixel img 160 100);
  Alcotest.(check pixel) "check unchanged pixel" {r=0; g=0; b=0}
    (get_pixel img 0 0);
  Alcotest.(check pixel) "check unchanged pixel" {r=0; g=0; b=0}
    (get_pixel img 319 99)



(* Test set *)
let test_set = [
  "black pixel", `Quick, test_black;
  "white pixel", `Quick, test_white;
  "make image", `Quick, test_make_image;
  "make image with color", `Quick, test_make_image_color;
  "make image (slow)", `Slow, test_make_image_slow;
  "make image with color (slow)", `Slow, test_make_image_color_slow;
  "change pixel color", `Quick, test_set_color;
  "get pixel color", `Quick, test_get_color
]




