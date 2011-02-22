open Common


let array_median a =
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
  

let list_average l =
  if L.is_empty l then 0.
  else (L.fsum l) /. (L.length l |> float_of_int)
  
  
let list_median l =
  let a = A.of_list l in
  array_median a
