(** A Ocaml tutorial to show the usage of Monads
 * It implements a DSL for a key-value store, using
 * different backend implementation, e.g. Hashtbl or Assoc Lists
 *
 * This is a test application of the KV-store Monads
 *
 * see: http://www.heise.de/developer/artikel/Dependency-Injection-in-der-funktionalen-Programmierung-3115570.html
 *)

(* check DSl types *)
open Kv_dsl
open Kv_hash
;;

let prg1 = Put ("foo", 23, Get ("foo", fun r -> Done r ))
let prg2 = Get ("foo", fun r -> Put ("foo", r + 1, Done r))
;;

let res1 = run_with_hashtable (Hashtbl.create 0) prg1
(* let res2 = run_with_hashtable (Hashtbl.create 0) prg2
 *)


let () =
  print_endline "Monad tutorial:";
  print_endline "";
  print_endline ("result 1: " ^ string_of_int res1);
;;
