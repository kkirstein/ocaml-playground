(* vim: set ft=ocaml sw=2 ts=2: *)

(* listx.ml
 * A package with some additional list manipulation functions
*)

(* some helper functions *)
let rec range a b =
  if a > b then [] else a :: range (a + 1) b

let take l n =
  let rec loop res l' =
    match l' with
    | []      -> (res, [])
    | h :: t  -> if List.length res < n then (loop (List.append res [h]) t)
                  else (res, h :: t) in
  loop [] l

let part l n =
  let rec loop tail =
    match tail with
    | []  -> []
    | ll  -> let (f, t) = take ll n in f :: (loop t) in
  loop l
