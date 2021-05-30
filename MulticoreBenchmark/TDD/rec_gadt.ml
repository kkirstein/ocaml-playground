(* rec_gadt.ml
 * A case study on GADTs with respect to recursive definitions
 * of a GADT
 * Taken from a Scala blog post.
 * https://medium.com/disney-streaming/fix-point-type-for-gadt-scala-dc4e2cde349b
 *)

(* type _ query =
  | QString: string -> string query
  | QBool: bool -> bool query
  | QPath: string query -> (string * _ query) query *)

type _ query =
  | QString: string query
  | QBool: bool query
  | QPath: string * _ query -> (string * _ query) query


(* sample data *)
let expr = QPath ("oh", (QPath ("my", QString)))
let query_string = QPath ("my", QString)
let query_nested_string = QPath ("oh", (QPath ("my", QString)))

(* a simple function for type-checking *)
let type_match a b = (a = b)



