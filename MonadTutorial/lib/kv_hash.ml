(** A Ocaml tutorial to show the usage of Monads
 * It implements a DSL for a key-value store, using
 * different backend implementation, e.g. Hashtbl or Assoc Lists
 *
 * see: http://www.heise.de/developer/artikel/Dependency-Injection-in-der-funktionalen-Programmierung-3115570.html
 *)

open Kv_dsl
;;

(* interpreter for KV store with Hastbl backend *)
let rec run_with_hashtable ht p =
  match p with
  | Put (k, v, next) -> begin
    Hashtbl.add ht k v;
    run_with_hashtable ht next
  end
  | Get (k, cont) -> run_with_hashtable ht (cont (Hashtbl.find ht k))
  | Done v -> v
;;
