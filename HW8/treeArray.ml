type 'a tree = Empty | Node of 'a tree * 'a * 'a tree

module TreeArray =
  struct
    type 'a t = (int * 'a) tree

    exception Subscript

    let new_array = Empty

    let rec nth t i = 
      match t with 
      | Empty -> raise Subscript
      | Node (tl, (n, x), tr) ->
        match i < n, i > n with 
        | true, _ -> nth tl i 
        | _, true -> nth tr (i - n - 1) 
        | _ -> x
 
    let rec insert t i x = 
      match t, i with 
      | Empty, 0 -> Node (Empty, (0, x), Empty)
      | Empty, _ -> raise Subscript
      | Node (tl, (n, y), tr), _ ->
        if i <= n 
        then Node (insert tl i x, (n + 1, y), tr)
        else Node (tl, (n, y), insert tr (i - n - 1) x)

    let rec set t i x = 
      match t with 
      | Empty -> raise Subscript
      | Node (tl, (n, y), tr) -> 
        match i < n, i > n with 
        | true, _ -> Node (set tl i x, (n, y), tr)
        | _, true -> Node (tl, (n, y), set tr (i - n - 1) x)
        | _ -> Node (tl, (n, x), tr)

    let rec rightmost t = 
      match t with 
      | Empty -> raise Subscript
      | Node (tl, (_, y), Empty) -> (y, tl)
      | Node (tl, x, tr) ->
        let (y, tr') = rightmost tr in
        (y, Node (tl, x, tr'))

    let rec pop t i = 
      match t, i with 
      | Empty, _ -> raise Subscript
      | Node (Empty, (0, x), tr), 0 -> (x, tr)
      | Node (tl, (n, x), tr), _ ->
        match i < n, i > n with 
        | true, _ -> 
          let (y, tl') = pop tl i in
          (y, Node (tl', (n - 1, x), tr))
        | _, true -> 
          let (y, tr') = pop tr (i - n - 1) in
           (y, Node (tl, (n, x), tr'))
        | _ ->  
          let (y, tl') = rightmost tl in
          (x, Node (tl', (n - 1, y), tr))

    let rec length t = 
      match t with 
      | Empty -> 0
      | Node (tl, (n, _), tr) -> n + 1 + length tr
  end