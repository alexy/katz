open Common
open Sgraph_local

let getSocCap ustats user =
  match H.find_option ustats user with
    | Some stats -> stats.socUS
    | _ -> 0. 

(* create a real-valued list for users to attach proportionally,
   normalizes just the last cap and returns the last ones only *)
let mature_caps minDays minCap ustats day =
  H.map begin fun user {socUS=cap;dayUS=sinceDay} ->
    if day - sinceDay < minDays then minCap
    else cap
  end ustats
