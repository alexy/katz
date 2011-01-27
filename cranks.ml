open Common

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
 
 
(* ensure we only work with the mature values, replace immature ones,
  younger than maturity days, by minimum *)
let matureDayUserReals: int -> float -> user_day_reals -> day_user_reals =
  fun maturity minimum dcaps ->

  let res = Array.init Constants.daysTotal (fun _ -> H.create Constants.usersDaily) in

  H.iter begin fun user days ->
    let ordered = L.rev days in
    let day0 = ordered |> L.hd |> fst in
    L.iter begin fun (day,x) -> 
      let c = if (day - day0) >= maturity then x else minimum in
      H.add res.(day) user c
      end ordered 
  end dcaps;  
  res
      

let rankHash: user_reals -> ranked_users =  
  fun hl ->
  let r = H.create (H.length hl) in
  H.iter begin fun k v ->
    let ks = H.find_default r v [] in
    H.replace r v (k::ks)
  end hl;
  let a = H.enum r |> A.of_enum in
  (* sort descending
     NB for floats, we may choose equality within an epsilon,
     and handle NaNs a lá Soc_run *)
  A.sort (fun (k1,_) (k2,_) -> compare k2 k1) a;
  A.enum a |> E.map (fun (_,users) -> users)

(* first, we can save the array of daily rankings as is,
   converting daily enums to lists for ease of inspectopn *)
let aranks: int -> float -> user_day_reals -> day_rank_users =
  fun maturity minimum dcaps ->
  let byday = matureDayUserReals maturity minimum dcaps in
  A.map (rankHash |- L.of_enum) byday

(* then, we rewrite dcaps as dranks, 
   replacing capitals with ranks, processing enums directly *)
let dranks: int -> float -> user_day_reals -> user_day_ranks =
  fun maturity minimum dcaps ->
  let byday  = matureDayUserReals maturity minimum dcaps in
  let ranked = A.map rankHash byday in
  let res = H.create (H.length dcaps) in
  A.iteri begin fun day eusers ->
    E.iteri begin fun i users ->
      L.iter begin fun user ->
        let days = H.find_default res user [] in
        H.replace res user ((day,i)::days)
      end users
    end eusers
  end ranked;
  res
       
(* here. we return both aranks and dranks, so we convert enums to lists
   right away *)
let daranks: int -> float -> user_day_reals -> user_day_ranks * day_rank_users =
  fun maturity minimum dcaps ->
  let byday  = matureDayUserReals maturity minimum dcaps in
  let ranked = A.map (rankHash |- L.of_enum) byday in
  let res = H.create (H.length dcaps) in
  A.iteri begin fun day eusers ->
    L.iteri begin fun i users ->
      L.iter begin fun user ->
        let days = H.find_default res user [] in
        H.replace res user ((day,i)::days)
      end users
    end eusers
  end ranked;
  (res, ranked)
