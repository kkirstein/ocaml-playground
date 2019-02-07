(* vehicle.ml
 * An attempt to implement a type family with
 * GADTs (General Algebraic Data Types
 *
 * this has been inspired by the vehicle data type
 * from chapter 4.2 of the book
 * Type-Driven Development with Idris
 * https://www.manning.com/books/type-driven-development-with-idris
*)

(*
type power_source =
  | Petrol
  | Pedal
  | Electric
*)

type petrol
type pedal
type electric

type _ vehicle =
  | Bicycle : pedal vehicle
  | Unicycle : pedal vehicle
  | Motorcycle : int -> (petrol * int) vehicle
  | Car : int -> (petrol * int) vehicle
  | Bus : int -> (petrol * int) vehicle
  | Tram : electric vehicle

let bicycle = Bicycle
let car = Car 100
let bus = Bus 200

(* Some function s that pattern match on the given type *)
let wheels : type a. a vehicle -> int = function
  | Bicycle -> 2
  | Unicycle -> 1
  | Motorcycle _ -> 2
  | Car _ -> 4
  | Bus _ -> 4
  | Tram -> 16


let refuel = function
  | Car _ -> Car 100
  | Bus _ -> Bus 200
  | Motorcycle _ -> Motorcycle 50


