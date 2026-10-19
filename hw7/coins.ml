(*
Harry Nguyen
Huy Phan
*)
type coin = Penny | Nickel | Dime | Quarter

let worth c =
match c with
| Penny -> 1
| Nickel -> 5
| Dime -> 10
| Quarter -> 25

(*
countCPS : coin list -> (int -> ’a ) -> ’a
REQUIRES: true
ENSURES: countCPS cs k ∼= k ( count cs )
*)
let rec countCPS (cs : coin list) (k : int -> 'a) : 'a = 
  match cs with
  | [] -> k(0) 
  | c :: cs' -> countCPS (cs') (fun total -> k (total + worth c))

(*
change : int -> coin list -> (int -> ’a ) -> (int -> ’a ) -> ’a
REQUIRES: true
ENSURES: change n cs succ fail ∼= succ n if n cents can be made from the
coins in cs, and otherwise change n cs succ fail ∼= fail m where m is the closest
amount of change that can be made to n (picking the larger value in the case of ties in
closeness)
*)
let rec change (n : int) (cs : coin list) (succ : int -> 'a) (fail : int -> 'a) : 'a =
  match cs with
  | [] -> if n = 0 then succ n else fail 0
  | c :: cs' ->
    change (n - worth c) (cs') 
    (fun r -> succ (r + worth c)) 
    (
    fun m1 -> change (n) (cs') (succ) 
    (fun m2 -> let a = m1 + worth c in 
    if abs (n - a) < abs (n - m2) || ( abs(n - a) = abs (n - m2) && a > m2) 
    then fail a else fail m2)
    )