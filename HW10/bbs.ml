(*
Harry Nguyen
Huy Phan
*)

(*
bbs : int -> int -> int Seq . t
REQUIRES: m is the product of two primes
ENSURES: bbs m s ∼= a stream of integers representing a Blum-Blum-Shub PRNG with
modulus m and seed s. The first element in the stream is x1 as defined above, where the
seed is x0.
*)
let bbs (m : int) (s : int) : int Seq.t = 
  Seq.unfold (fun a -> Some((a * a) mod m, (a * a) mod m)) (s)