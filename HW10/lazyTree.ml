(* Huy Phan
 Harry Nguyen*)

type 'a lazyTree = unit -> 'a treeFront
and 'a treeFront =
  | Leaf
  | Node of 'a lazyTree * 'a * 'a lazyTree

let rec map f tree () =
  match tree () with
  | Leaf -> Leaf
  | Node (left, x, right) -> Node (map f left, f x, map f right)

let rec tabulate f g x () =
  Node ((fun () -> tabulate f g (f x) ()), x,
        (fun () -> tabulate f g (g x) ()))

let preOrd tree =
  let rec visit pending () =
    match pending with
    | [] -> Seq.Nil
    | next :: rest ->
        match next () with
        | Leaf -> visit rest ()
        | Node (left, x, right) ->
            Seq.Cons (x, visit (left :: right :: rest))
  in
  visit [tree]
