(**
 * Visual Random
 * Visualize random number generation,
 * a blog post from TypeOCaml,
 * http://typeocaml.com/2015/11/22/visualise_random/
 *)

(* generate random ints from timestamp *)
let decimal_only f = f -. (floor f)

(** generte a random integer from [0, bound)
 *)
let ran_via_time bound =
  ((Unix.gettimeofday () |> decimal_only) *. 100000000. |> int_of_float)
    mod bound
  (*
    Unix.gettimeofday() returns float like 1447920488.92716193 in second.
    We get the decimal part and then amplify it to be integer like, i.e., 1447920488.92716193 ==> 0.92716193 ==> 92716193.
    Then we mod it by bound to get the final "random" number.
  *)
