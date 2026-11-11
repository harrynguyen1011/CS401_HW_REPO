(* Huy Phan
 Harry Nguyen*)

type 'a lazyTree = unit -> 'a treeFront
and 'a treeFront =
  | Leaf
  | Node of 'a lazyTree * 'a * 'a lazyTree

(*
map : ( ’ a -> ’b ) -> ’a lazyTree -> ’b lazyTree
REQUIRES: true
ENSURES: map f t ∼= t ’ where
• t ’ has the same shape as t
• All the x : ’a in t are replaced with f x : ’b in t ’
• map f t is maximally lazy (evaluating map f t never calls f or exposes any elements of the tree)
*)
let rec map f tree () =
  match tree () with
  | Leaf -> Leaf
  | Node (left, x, right) -> Node (map f left, f x, map f right)

(*
tabulate : ( ’ a -> ’a ) -> ( ’ a -> ’a ) -> ’a -> ’a lazyTree
REQUIRES: true
ENSURES: tabulate f g x ∼= t where
• x is the root element for t
• for every subtree t ’ containing some y at its root, f y should be contained in the
root node of left subtree of t ’
• for every subtree t ’ containing some y at its root, g y should be contained in the
root node of right subtree of t ’
• tabulate f g x is maximally lazy (evaluating tabulate f g x never calls
neither f nor g and never exposes any elements of the tree)
*)
let rec tabulate f g x () =
  Node ((fun () -> tabulate f g (f x) ()), x,
        (fun () -> tabulate f g (g x) ()))

(*
preOrd : ’a lazyTree -> ’a Seq . t
REQUIRES: true
ENSURES: preOrd t ∼= s where
• s is the pre-order traversal for t (the pre-order traversal is the current node, then
the pre-order traversal of the left subtree, then the pre-order traversal of the right
subtree)
• preOrd t is maximally lazy (evaluating preOrd t does not expose any elements
of the tree)
*)
let preOrd tree =
  let rec visit tree next () =
    match tree () with
    | Leaf -> next ()
    | Node (left, x, right) ->
        Seq.Cons (x, visit left (fun () -> visit right next ()))
  in
  visit tree (fun () -> Seq.Nil)
