(*
Harry Nguyen 
Huy Phan
*)
module type TREE = 
sig
  type order = Less | Equal | Greater
  type 'a tree

  exception NotFound

  val empty: unit -> 'a tree
  val insert: ('a * 'a -> order) -> 'a tree -> 'a -> 'a tree
  val remove: ('a * 'a -> order) -> 'a tree -> 'a -> 'a tree
  val isIn: ('a * 'a -> order) -> 'a tree -> 'a -> bool
  val findRoot: 'a tree -> 'a
end