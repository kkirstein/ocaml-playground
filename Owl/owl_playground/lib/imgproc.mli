(**
  Imgproc module offers some basic image processing functions
  for image data given as Owl's Ndarray *)

val print_img_info :
  ('a, 'b) Owl.Dense.Ndarray.Generic.t ->
  (unit, [> `Invalid_dimension of int ]) result
(** [print_img_info nd] prints some information like size and
    number of color channels to stdout. It returns [`Invalid_dimension n] error
    if [nd] has invaild dimensions [n] *)

val error_msg : [< `Invalid_dimension of int | `IO_error of string ] -> string
(** [error_msg err] generates a string representation of
    the different error generated by this module. *)

val image_to_ndarray :
  (float, Bigarray.float32_elt) Bigarray.kind Stb_image.t ->
  (Owl.Dense.Ndarray.S.arr, [> `Invalid_dimension of int ]) result
(** [image_to_ndarray img] converts an integer image buffer to
    a suitable Ndarray. Returns [`Invalid_dimension n] error, if
    the dimensions don't match a 1 or 3 color channel image *)

val ndarray_to_image :
  Owl.Dense.Ndarray.S.arr ->
  ( (int, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t,
    [> `Invalid_dimension of int ] )
  result
(** [ndarray_to_image nd] converts a numeric array of image data to
    an integer image buffer. Returns [`Invalid_dimension n] error, if
    the dimensions don't match a 1 or 3 color channel image *)

val write :
  ?fmt:[ `PNG ] ->
  string ->
  Owl.Dense.Ndarray.S.arr ->
  (unit, [ `Invalid_dimension of int ]) result
(** [write ?fmt file_path img] writes given image data [img] to
    a file of format [fmt]. Returns [`Invalid_dimension n] error, if
    invaid dimensions are given. *)

val read : string -> (Owl.Dense.Ndarray.S.arr, [ `IO_error of string ]) result
(** [read file_path] reads the given image file [file_path] to
    a Ndarray. Returns [`IO_error str] error, if the image file
    could not read. *)

val to_grayscale :
  Owl.Dense.Ndarray.S.arr ->
  (Owl.Dense.Ndarray.S.arr, [ `Invalid_dimension of int ]) result
(** [to_grayscale nd] converts given image data to grayscale. It works for
    image data with 3 color channels and returns the original image, if a single
    color channel is given. Otherwise an [`Invalid_dimension n] error is returned. *)
