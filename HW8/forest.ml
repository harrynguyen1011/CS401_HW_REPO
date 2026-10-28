(*
Harry Nguyen
Huy Phan
*)
module type FOREST =
  sig
    module T: Tree.TREE
    type 'a forest

  
    exception Full
    exception NotInForest
  
    val limit: int
    val empty: unit -> 'a forest
    val addToForest: 'a forest -> 'a T.tree -> 'a forest
    val addToTree: ('a * 'a -> T.order) -> 'a forest -> 'a -> 'a -> 'a forest
    val findRoot: ('a * 'a -> T.order) -> 'a forest -> 'a -> 'a
    val removeTree: ('a * 'a -> T.order) -> 'a forest -> 'a -> 'a forest
  end