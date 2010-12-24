open Common
open Binary_graph

(* we need to serialize float to Cstr ourselves so
   that R will be able to read it back
   
   Otoky stores all kinds of OCaml's own type info,
   which R won't undertand.  We should either use
   raw Tokyo_cabinet, or understand R's STRING_ELT
   serialization to string, or, even better, write
   .rda directly instead of .mlb
   
module TC=Tokyo_cabinet
let matureCapsTC ?(days=5) dcaps toName =
  let count = ref 0 in
  let tc = HDB.new_ () in
  TC.open_ tc ~omode:[Owriter] toName;
  H.enum dcaps |> 
  E.filter (fun (user,caps) -> (L.length caps) > days) |>
  E.map (fun (k,v::vs) -> (k,v)) |>
  E.iter begin fun (k,v) ->
    TC.put tc k v;
  incr count
  end;
  TC.close tc; 
  leprintfln "wrote %d pairs to %s" !count toName

 *)
 
type day_rank_users = ((user list) list) array
type day_ranks = (day * rank) list
type user_day_ranks = (user, day_ranks) Hashtbl.t
 
let rankHash hl =
  let r = H.create (H.length hl) in
  H.iter begin fun k v ->
    let ks = H.find_default r v [] in
    H.replace w k::ks
  end;
  let a = H.enum r |> A.of_enum in
  (* sort descending
     NB for floats, we may choose equality within an epsilon,
     and handle NaNs a lá Soc_run *)
  A.sort (fun (k1,_) (k2,_) -> compare k2 k1) a;
  A.enum a |> E.filter (fun (_,users) -> users)
  
let dranks: By_day.user_day_reals -> user_day_ranks =
  fun dcaps ->
  let byday  = By_day.dayUserReals dcaps in
  let ranked = A.map rankHash byday in
  let res = H.create (H.length dcaps) in
  A.iteri begin fun day eusers ->
    E.iteri begin fun i users ->
      L.iter begin fun user ->
        let days = H.find_default res user [] in
        H.replace res user (day,i)::days
      end users
    end eusers
  end ranked
       
let aranks: By_day.user_day_reals-> day_rank_users =
  fun dcaps ->
  let byday = By_day.dayUserReals dcaps in
  A.map (rankHash | L.of_enum) byday
