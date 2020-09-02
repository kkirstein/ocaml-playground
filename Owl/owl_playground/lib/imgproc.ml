(**
  Imgproc module offers some basic image processing functions
  for image data given as Owl's Ndarray *)


(** prints some information of given image data *)
let print_img_info img =
  let open Owl.Dense.Ndarray in
  let dims = S.shape img in
  match Array.length dims with
  | 3 -> Ok (Printf.printf "w:%d h:%d c:%d\n" dims.(0) dims.(1) dims.(2))
  | 2 -> Ok (Printf.printf "w:%d h:%d\n" dims.(0) dims.(1))
  | x -> Error (`Invalid_dimension x)

(** Generates descriptive message for given error *)
let error_msg = function
  | `Invalid_dimension x -> "Invalid dimension " ^ string_of_int x

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
  match Generic.num_dims img with
  | 2 -> Ok img
  | 3 ->
      let chans =Generic.split ~axis:2 [| 1; 1; 1 |] img in
      let r, g, b = (chans.(0), chans.(1), chans.(2)) in
      Ok Generic.((r *$ 0.2125) + (g *$ 0.7154) + (b *$ 0.0721))
  | x -> Error (`Invalid_dimension x)

(** Converts an ImageBuffer to Owl's Ndarray *)
let i2s _img = failwith "not implemented"

(** Converts a Ndarray to an ImageBuffer *)
let s2i nd =
  let open Owl.Dense.Ndarray in
  match Generic.num_dims nd with
  | 1 | 3 ->
      let len = Generic.shape nd |> Array.fold_left ( * ) 1 in
      let buf = Bigarray.(Array1.create int8_unsigned c_layout len) in
      Generic.iteri (fun i x -> buf.{i} <- int_of_float (x *. 255.0)) nd;
      Ok buf
  | x -> Error (`Invalid_dimension x)

(** write image data to file *)
let write ?(fmt = `PNG) file_path img =
  let open Owl.Dense.Ndarray in
  let exporter = match fmt with `PNG -> Stb_image_write.png in
  match S.num_dims img with
  | 2 ->
      let dims = S.shape img in
      let w, h, c = (dims.(0), dims.(1), 1) in
      let img_buf = S.reshape img [| w * h * c |] |> s2i in
      Result.bind img_buf (fun buf -> Ok (exporter file_path ~w ~h ~c buf))
  | 3 ->
      let dims = S.shape img in
      let w, h, c = (dims.(0), dims.(1), dims.(2)) in
      let img_buf = S.reshape img [| w * h * c |] |> s2i in
      Result.bind img_buf (fun buf -> Ok (exporter file_path ~w ~h ~c buf))
  | x -> Error (`Invalid_dimension x)

