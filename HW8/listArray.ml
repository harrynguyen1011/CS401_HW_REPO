module ListArray =
  struct
    type 'a t = 'a list

    exception Subscript

    let new_array = []

    let rec nth lst i = 
      match lst,i  with 
      | [], _ -> raise Subscript
      | x::_, 0 -> x
      | x::xs, _ -> nth xs (i - 1)

    let rec insert lst i x = 
      match lst, i with 
      | _, 0 -> x::lst
      | y::ys, _ -> y :: (insert ys (i - 1) x)
      | [], _ -> raise Subscript

    let rec set lst i x = 
      match lst, i with 
      | y::ys, 0 -> x::ys
      | y::ys, _ -> y :: (set ys (i - 1) x)
      | [], _ -> raise Subscript

    let rec pop lst i = 
      match lst, i  with 
      | [], _ -> raise Subscript
      | x::xs, 0 -> (x, xs)
      | x::xs, _ ->
          let (y, ys) = pop xs (i - 1) in
          (y, x::ys)

    let length = List.length
  end