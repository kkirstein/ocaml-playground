(**
  Do some basic image processing with owl *)

(* a test image *)
(* let image_path = "../../../../test_data/mandelbrot_1920_1200.png" *)
let image_path = "./test_data/mandelbrot_1920_1200.png"

(** prints some information of given image data *)
let print_img_info img =
  let open Owl.Dense.Ndarray in
  let dims = S.shape img in
  match Array.length dims with
  | 3 -> Ok (Printf.printf "w:%d h:%d c:%d\n" dims.(0) dims.(1) dims.(2))
  | 2 -> Ok (Printf.printf "w:%d h:%d\n" dims.(0) dims.(1))
  | x -> Error (`Invalid_dimension x)

(** convert given image buffer to Ndarray *)
let image_to_ndarray img =
  let open Owl.Dense.Ndarray in
  let w = Stb_image.width img in
  let h = Stb_image.height img in
  let img_data = Bigarray.genarray_of_array1 img.data in
  match Stb_image.channels img with
  | 1 -> Ok (S.reshape img_data [| w; h |])
  | 3 -> Ok (S.reshape img_data [| w; h; 3 |])
  | x -> Error (`Invalid_dimension x)

  (** convert given image data to grayscale *)
  let to_grayscale img =
    let open Owl.Dense.Ndarray in
    match S.num_dims img with
  | 1 -> Ok (img)
  | 3 -> Ok (failwith "not implemented")
  | x -> Error (`Invalid_dimension x)

(* main entry point *)
let () =
  if not (Sys.file_exists image_path) then failwith "Could not find test image"
  else Printf.printf "Loading %s .." image_path;
  match Stb_image.loadf image_path with
  | Error (`Msg err) -> failwith err
  | Ok img_buf ->
      Printf.printf " done (%d:%d).\n" (Stb_image.width img_buf)
        (Stb_image.height img_buf);
      let img_data = image_to_ndarray img_buf in
      ignore (print_img_info (Result.get_ok img_data))
