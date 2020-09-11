(**
  Do some basic image processing with owl *)

open Owl_playground.Imgproc
open Owl_plplot

(* a test image *)
let image_folder = "./test_data"

let image_path = Filename.concat image_folder "mandelbrot_1920_1200.png"

(* main entry point *)
let () =
  if not (Sys.file_exists image_path) then failwith "Could not find test image"
  else Printf.printf "Loading %s .." image_path;
  let img = load image_path |> Result.get_ok in
  Printf.printf " done.\n";
  ignore (print_img_info img);
  let gray = to_grayscale img |> Result.get_ok in
  ignore (print_img_info gray);
  let gray_image_path = Filename.concat image_folder "mandelbrot_gray.png" in
  Printf.printf "Saving %s .." gray_image_path;
  let () =
    match save gray_image_path gray with
    | Ok () -> ()
    | Error err -> failwith (error_msg err)
  in
  Printf.printf " done.\n";
  Printf.printf "Plotting gray image ..";
  let h = Plot.create (Filename.concat image_folder "plot_01.png") in
  Plot.image ~h (Owl.Dense.Ndarray.Generic.cast_s2d gray);
  Plot.output h
