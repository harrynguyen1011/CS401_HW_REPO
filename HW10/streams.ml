(*
Harry Nguyen
Huy Phan
*)


let rec append (a : 'a Seq.t) (b : 'a Seq.t) : 'a Seq.t =
  fun () ->
    match a () with
    | Seq.Nil -> b ()
    | Seq.Cons (x, a') -> Seq.Cons (x, append a' b)

(*
concat : ’a Seq . t Seq . t -> ’a Seq . t
REQUIRES: s is productive
ENSURES:
• concat s -*→ s ’, a stream containing the elements of s concatenated together.
• concat s is maximally lazy (evaluating concat s never exposes any elements of
s).
*)
let rec concat (s : 'a Seq.t Seq.t) : 'a Seq.t =
  fun () ->
    match s () with
    | Seq.Nil -> Seq.Nil
    | Seq.Cons (inner, rest) -> append (inner) (concat rest) ()

(*
cycle : ’a Seq . t -> ’a Seq . t
REQUIRES: s is productive
ENSURES:
• cycle s is productive
• cycle s _*→ s ’ a stream formed by infinitely repeating the elements of s
• If s ∼= Seq . empty, then cycle s ∼= Seq . empty
• cycle s is maximally lazy (evaluating cycle s never exposes any elements of s).
*)
let rec cycle (s : 'a Seq.t) : 'a Seq.t =
  fun () ->
    match s () with
    | Seq.Nil -> Seq.Nil
    | Seq.Cons (_, _) -> append (s) (cycle s) ()

(*
interleave : ’a Seq . t -> ’a Seq . t -> ’a Seq . t
REQUIRES: s1 and s2 are productive
ENSURES:
• interleave s1 s2 is productive
• interleave s1 s2 -∗→ s, where s contains alternating elements from s1 and s2,
starting with the first element of s1
• If one stream ends early, the rest of the other stream is appended in its entirety
• interleave s1 s2 is maximally lazy (evaluating interleave s1 s2 never
exposes any elements of s1 or s2).
*)
let rec interleave (s1 : 'a Seq.t) (s2 : 'a Seq.t) : 'a Seq.t =
  fun () ->
    match s1 () with
    | Seq.Nil -> s2 ()
    | Seq.Cons (x, s1') -> Seq.Cons (x, interleave s2 s1')