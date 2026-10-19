(*
Harry Nguyen
Huy Phan
*)

(*
(>>=) : ’a * string list -> ( ’ a -> ’b * string list ) -> ’b *
string list
REQUIRES: true
ENSURES: (x , log ) >>= f ∼= (y , log ’ @ log ) where f x ∼= (y , log ’)
*)
let rec (>>=) ((x : 'a), (log : string list)) (f : 'a -> 'b * string list) : 'b * string list =
  let (y, log') = f (x) in (y, log' @ log)

(*
return : ’a -> ’a * string list
REQUIRES: true
ENSURES: return x ∼= (x ,[])
*)
let return (x : 'a) : 'a * string list = (x, [])

(*
lift : (int -> int ) -> int -> int * string list
REQUIRES: true
ENSURES: lift f x ∼= ( f x , [ msg ]) where msg is of the form "p mapped to q"
for p the string of x and q the string of y
*)
let lift (f : int -> int) (x : int) : int * string list =
  let y = f x in
  let msg = string_of_int x ^ " mapped to " ^ (y |> string_of_int) in
  (y, [msg])