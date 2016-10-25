#use "topfind";;
#require "lwt.simple-top";;

open Lwt;;

(* thread creation *)
Lwt.state (Lwt.return 42);;
Lwt.state (Lwt.fail Exit);;

let waiter, wakener = Lwt.wait ();;
Lwt.state waiter;;
Lwt.wakeup wakener 42;;
Lwt.state waiter;;

let waiter, wakener = Lwt.wait ();;
Lwt.state waiter;;
Lwt.wakeup_exn wakener Exit;;
Lwt.state waiter;;

(* thread composition *)
Lwt.bind
  (Lwt_io.read_line Lwt_io.stdin)
  (fun str -> Lwt_io.printlf "You typed %S" str);;

