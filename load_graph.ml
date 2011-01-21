open Common

let suffix = String.ends_with

let loadAnyGraph : string -> (graph * timings) =
  fun fileName ->
    if suffix fileName "mlb" then
      let g = Binary_graph.loadData fileName in
      let t = Some (sprintf "-- loaded binary %s timing: " fileName) |> getTiming in
      (g,[t])
    else
    if suffix fileName "json.hdb" then
      let g = Tokyo_graph.fetchGraph fileName None (Some 10000) in
      let t = Some (sprintf "-- loaded json %s timing: " fileName) |> getTiming in
      (g,[t])
    else failwith "unrecognized graph file extension" 
