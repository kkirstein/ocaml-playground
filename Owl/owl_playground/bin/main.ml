(**
  Do some basic image processing with owl *)

(* a test image *)
(* let image_path = "../../../../test_data/mandelbrot_1920_1200.png" *)
let image_folder = "./test_data"

let image_path = Filename.concat image_folder "mandelbrot_1920_1200.png"

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
  | 1 -> Ok img
  | 3 ->
      let chans = S.split ~axis:2 [| 1; 1; 1 |] img in
      let r, g, b = (chans.(0), chans.(1), chans.(2)) in
      Ok S.((r *$ 0.2125) + (g *$ 0.7154) + (b *$ 0.0721))
  | x -> Error (`Invalid_dimension x)

(** write image data to file *)
(*
let write ?(fmt = `PNG) file_path img =
  let open Owl.Dense.Ndarray.S in
  let exporter = match fmt with `PNG -> Stb_image_write.png in
  match num_dims img with
  | 2 ->
      let dims = shape img in
      let w, h, c = (dims.(0), dims.(1), 1) in
      let img_buf = reshape img [| w * h * c |] in
      Ok (exporter file_path ~w ~h ~c img_buf)
  | 3 ->
      let dims = shape img in
      let w, h, c = (dims.(0), dims.(1), dims.(2)) in
      let img_buf = reshape img [| w * h * c |] in
      Ok (exporter file_path ~w ~h ~c img_buf)
  | x -> Error (`Invalid_dimension x)
*)

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
      ignore (print_img_info gray)
