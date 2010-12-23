open Common
open Tokyo_cabinet

let matureCaps ?(days=5) dcaps toName =
  let count = ref 0 in
  let tc = HDB.new_ () in
  HDB.open_ tc ~omode:[Owriter] toName;
  H.enum dcaps |> 
  E.filter (fun (user,caps) -> (L.length caps) > days) |>
  E.map (fun (k,v::vs) -> (k,v)) |>
  E.iter begin fun (k,v) ->
    HDB.put tc k v;
  incr count
  end;
  HDB.close tc; 
  leprintfln "wrote %d pairs to %s" !count toName
  