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

let () =
  let s1 = new my_state in
  let s2 = new my_state in 

  print_endline (string_of_int s1#value);
  print_endline (string_of_int s2#value);

  print_endline (string_of_int s1#value1);
  print_endline (string_of_int s2#value1);

  s1#set_value 42;
  print_endline (string_of_int s2#value);

  s1#set_value1 3;
  print_endline (string_of_int s1#value1);
  print_endline (string_of_int s2#value1);

  ()
