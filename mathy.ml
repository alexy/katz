open Common

let median a =
  A.sort compare a;
  let m = A.length a / 2 in
  let is_odd = A.length a mod 2 = 0 in
  if is_odd then a.(m)
  else (a.(m) +. a.(m-1)) /. 2.