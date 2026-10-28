module BinaryTree : Tree.TREE =
struct

  type order = Less | Equal | Greater

  type 'a tree = Empty | Node of 'a tree * 'a * 'a tree

  exception NotFound

  let empty () = Empty

  let rec insert (cmp : 'a * 'a -> order) t x = 
    match t with 
    | Empty -> Node (Empty, x, Empty)
    | Node (l, v, r) ->
      match cmp (x, v) with
      | Less -> Node (insert cmp l x, v, r)
      | _    -> Node (l, v, insert cmp r x)

  let rec remove (cmp : 'a * 'a -> order) t x = 
    match t with 
    | Empty -> Empty
    | Node (l, v, r) ->
      match cmp (x, v) with
      | Equal -> Empty
      | Less  -> Node (remove cmp l x, v, r)
      | _     -> Node (l, v, remove cmp r x)

  let rec isIn (cmp: 'a * 'a -> order) t x = 
    match t with 
    | Empty -> false
    | Node (l, v, r) ->
      cmp (x, v) = Equal || isIn cmp l x || isIn cmp r x

  let rec find (cmp: 'a * 'a -> order) t x = 
    match t with 
    | Empty -> raise NotFound
    | Node (l, v, r) ->
      match cmp (x, v) with
      | Equal -> Node (l, v, r)
      | Less  -> find cmp l x
      | _     -> find cmp r x

  let findRoot t = 
    match t with 
    | Empty -> raise NotFound
    | Node (l, v, r) -> v

end
