
(* a dummy implementation of SEQUENCE; does not satisfy asymptotic bounds *)
module ListSeq : Sequence.SEQUENCE with type 'a seq = 'a list = struct 

  type 'a seq = 'a list

  exception Range of string 


  (* Constructing a Sequence *)

  let empty () = []
  let singleton x = [x]
  let tabulate f n = 
    if n < 0 
    then raise (Range ("tabulate given negative length " ^ (string_of_int n)))
    else List.init n f
  let fromList lst = lst


  (* Deconstructing a Sequence *)

  let nth lst n = 
    if n < 0 
    then raise (Range ("nth given negative index " ^ (string_of_int n)))
    else 
      let len = List.length lst in 
      if n > len
      then raise (Range ("nth given index " ^ (string_of_int n) ^ " which is out of range for seq of length " ^ (string_of_int len)))
      else List.nth lst n
  let null = List.is_empty
  let length = List.length
  let toList lst = lst
  let toString f lst = "<" ^ (String.concat ";" (List.map f lst)) ^ ">"
  let equal eq (s1,s2) = try List.for_all2 (fun x y -> eq (x,y)) s1 s2 with Invalid_argument _ -> false 
  
  
  (* Simple Transformations *)

  let rev = List.rev
  let append (s1,s2) = List.append s1 s2
  let flatten = List.flatten
  let cons = List.cons


  (* Combinators and Higher-Order Functions *)

  let filter = List.filter
  let map = List.map
  let reduce f z lst = List.fold_left (fun a b -> f (a,b)) z lst
  let rec reduce1 f lst = 
    match lst with 
    | x::[] -> x 
    | x::xs -> f (x, (reduce1 f xs))
    | _ -> raise (Range "empty seq given to reduce1")

  let mapreduce f z g lst = reduce g z (map f lst)
  let zip (lst1,lst2) = List.combine lst1 lst2
  let zipWith f (lst1,lst2) = map f (zip (lst1, lst2))


 (* Indexing-Related Functions *)

  let enum lst = List.mapi (fun i x -> (i,x)) lst
  let mapIdx f lst = map f (enum lst)

  let update (lst, (i, x)) = 
    let len = List.length lst in
    if i >= len
    then raise (Range ("mapIdx given index " ^ (string_of_int i) ^ " which is out of range for seq of length " ^ (string_of_int len)))
    else List.mapi (fun j y -> if i = j then x else y) lst

  let inject (lst1, lst2) =
    let len = List.length lst1 in
    let maxElt = List.fold_left (fun acc (i,_) -> max acc i) (-1) lst2 in
    if maxElt >= len
    then raise (Range ("inject given index " ^ (string_of_int maxElt) ^ " which is out of range for seq of length " ^ (string_of_int len)))
    else List.fold_left (fun acc (i,x) -> update (acc, (i, x))) lst1 lst2

  let subseq lst (start, len) = 
    if start + len > List.length lst 
    then raise (Range ("subseq given (" ^ (string_of_int start) ^ "," ^ (string_of_int len) ^ ") goes out of range for seq of length " ^ (string_of_int len)))
    else
      lst 
      |> (try List.drop start with Invalid_argument _ -> raise (Range ("subseq given negative starting index " ^ (string_of_int start))))
      |> (try List.take len with Invalid_argument _ -> raise (Range ("subseq given negative length " ^ (string_of_int len))))
    

  let take lst n = 
    let len = List.length lst in
    if n > len || n < 0
    then raise (Range ("take given index " ^ (string_of_int n) ^ " which is out of range for seq of length " ^ (string_of_int len)))
    else List.take n lst

  let drop lst n = 
    let len = List.length lst in
    if n > len || n < 0
    then raise (Range ("drop given index " ^ (string_of_int n) ^ " which is out of range for seq of length " ^ (string_of_int len)))
    else List.drop n lst

  let split lst n = 
    let len = List.length lst in
    if n > len || n < 0 
    then raise (Range ("split given index " ^ (string_of_int n) ^ " which is out of range for seq of length " ^ (string_of_int len)))
    else (List.take n lst, List.drop n lst)


  (* Sorting and Searching *)

  type order = Less | Equal | Greater

  let sort cmp = List.stable_sort (fun a b -> match cmp (a, b) with Less -> -1 | Equal -> 0 | Greater -> 1)

  let merge cmp (lst1, lst2) = List.merge (fun a b -> match cmp (a, b) with Less -> -1 | Equal -> 0 | Greater -> 1) lst1 lst2
  let search cmp x = List.find_index (fun y -> cmp (x,y) = Equal)


  (* Views *)

  type 'a lview = Nil | Cons of 'a * 'a seq

  let showl lst = match lst with [] -> Nil | x::xs -> Cons (x,xs)
  let hidel lst = match lst with Nil -> [] | Cons (x,xs) -> x::xs

  type 'a tview = Empty | Leaf of 'a | Node of 'a seq * 'a seq

  let showt lst = 
    match lst with 
    | [] -> Empty 
    | x::[] -> Leaf x 
    | _ -> 
      let len = List.length lst in 
      Node (List.take (len/2) lst, List.drop (len/2) lst)

  let rec hidet t = 
    match t with 
    | Empty -> [] 
    | Leaf x -> [x]
    | Node (t1, t2) -> t1 @ t2

end


