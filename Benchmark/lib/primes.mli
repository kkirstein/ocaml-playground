(* vim: set ft=ocaml sw=2 ts=2: *)

(** primes.mli
    A module to calculate prime numbers *)


val sieve : int -> int list
(** [sieve limit] finds all prime numbers less-or-equal to [limit]
    by applying the 'Sieve of Eratosthenes' algorithm *)


val is_prime : int -> bool
(** [is_prime n] checks whether [n] is a prime number by a brute force approach *)


val is_prime_z : Z.t -> bool
(** [is_prime n] checks whether [n] is a prime number by a brute force approach *)


val find_primes : int -> int list
(** [find_primes limit] finds all prime numbers less than [limit] *)


val find_primes_z : Z.t -> Z.t list
(** [find_primes limit] finds all prime numbers less than [limit] *)
