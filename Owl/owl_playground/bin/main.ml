(**
  Do some basic image processing with owl *)

open Owl_playground.Imgproc

(* a test image *)
let image_folder = "./test_data"

let image_path = Filename.concat image_folder "mandelbrot_1920_1200.png"

(* main entry point *)
let () =
  if not (Sys.file_exists image_path) then failwith "Could not find test image"
  else Printf.printf "Loading %s .." image_path;
  match Stb_image.loadf image_path with
  | Error (`Msg err) -> failwith err
  | Ok img_buf ->
      Printf.printf " done (%d:%d).\n" (Stb_image.width img_buf)
        (Stb_image.height img_buf);
      let img = image_to_ndarray img_buf |> Result.get_ok in
      ignore (print_img_info img);
      let gray = to_grayscale img |> Result.get_ok in
      ignore (print_img_info gray);
      let gray_image_path =
        Filename.concat image_folder "mandelbrot_gray.png"
      in
      Printf.printf "Saving %s .." gray_image_path;
      let () =
        match write gray_image_path gray with
        | Ok () -> ()
        | Error err -> failwith (error_msg err)
      in
      Printf.printf " done.\n"
