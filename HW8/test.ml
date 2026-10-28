
module Test =
  struct
    module Forest = MkForest.MkForest (BinaryTree.BinaryTree) (struct let lim = 4 end)
    let cmp (x,y) = 
      match x < y, x > y with 
      | true, _ -> Forest.T.Less 
      | _, true -> Forest.T.Greater 
      | _ -> Forest.T.Equal


    let t0 = List.fold_left 
      (fun t x -> Forest.T.insert cmp t x)
      (Forest.T.empty ())
      [4; 1; 65; 3; 8; 7; 2]
    let t1 = List.fold_left 
      (fun t x -> Forest.T.insert cmp t x)
      (Forest.T.empty ())
      [10; 9; 11; 12; 13]

    let lim = Forest.limit

    let fe : int Forest.forest = Forest.empty ()
    let f1 = Forest.addToForest fe t0
    let f2 = Forest.addToForest f1 t1
    let f3 = 
      try 
        Forest.addToTree cmp f2 3 15
      with Forest.Full -> f2
    let f4 = Forest.addToTree cmp f3 9 20
    let _ = 
      try 
        Some (Forest.findRoot cmp f4 20)
      with Forest.NotInForest -> None
    let _ = 
      try 
        Some (Forest.removeTree cmp f4 10)
      with Forest.NotInForest -> None
  end
