(* demo for OOP features of OCaml *)

(* class with local defs *)
class my_state =

let value = ref 0
in

object
  val mutable value1 = 13

  method value = !value
  method set_value v = value := v

  method value1 = value1
  method set_value1 v = value1 <- v
end
