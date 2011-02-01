open Common

let median a =
  let len = A.length a in
  match len with
  | 0 -> -1.
  | 1 -> a.(0)
  | _ -> begin
    A.sort compare a;
    let m = len / 2 in
    let is_odd = len mod 2 = 0 in
    if is_odd then a.(m)
    else (a.(m) +. a.(m-1)) /. 2.
  end