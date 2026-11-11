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
  let rec visit tree next () =
    match tree () with
    | Leaf -> next ()
    | Node (left, x, right) ->
        (* Save the right subtree for after the left, as in lecture tree search. *)
        Seq.Cons (x, visit left (fun () -> visit right next ()))
  in
  visit tree (fun () -> Seq.Nil)
