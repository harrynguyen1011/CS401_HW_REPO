module MkForest (T : Tree.TREE) (L : sig val lim : int end) : Forest.FOREST =
struct

  type 'a forest = 'a T.tree list * int 

  module T = T

  exception Full
  exception NotInForest
  exception Empty

  let limit = L.lim

  let empty () = ([], 0)

  let addToForest (ts, i) tree =
    if i >= L.lim then raise Full else (tree::ts, i + 1)

  let rec accForest g f lst key x = 
    match lst with 
    | [] -> raise Empty
    | t::ts ->
      if g t key 
      then (f t x)::ts 
      else t::(accForest g f ts key x)

  let rec iterateForest g f lst x = 
    match lst with 
    | [] -> raise Empty
    | t::ts ->
      if g t x 
      then f t x 
      else iterateForest g f ts x

  let rec addToTree cmp (ts, i) key x = 
    match ts with 
    | [] -> raise NotInForest
    | _ ->
        try 
          let nts = accForest (T.isIn cmp) (T.insert cmp) ts key x in 
          (nts, i)
        with Empty -> raise NotInForest

  let getRoot t x = T.findRoot t

  let findRoot cmp (ts, i) x = 
    match ts with 
    | [] -> raise NotInForest
    | _ ->
      try
        (iterateForest (T.isIn cmp) getRoot ts x)
      with 
      | Empty -> raise NotInForest
      | T.NotFound -> raise NotInForest

  let removeTree cmp (ts, i) x = 
    match ts with 
    | [] -> raise NotInForest
    | _ ->
      try
        let nts = accForest (T.isIn cmp) (T.remove cmp) ts x x in 
        (nts, i)
      with Empty -> raise NotInForest

end
