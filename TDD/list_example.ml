(* vim: set ft=ocaml sw=2 ts=2: *)

let rec add_to_list l num =
  match l with
  | [] -> []
  | h :: t -> (num + h) :: add_to_list t num


