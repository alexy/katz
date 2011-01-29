(* given a dcaps and dreps,
   compute daily starranks for all users *)
   
open Common
   
   (* TODO this is daily rank for that day's audience only;
      cumulative would require audeince aggregation up to the day *)

let starrank: dreps -> dcaps_hash -> (starts_hash * int * float) option -> starrank =
  fun dreps dcapsh maturity ->
    
  
  H.map begin fun user days ->
    H.fold begin fun day reps dsranks ->
      let rcaps = 
      H.fold begin fun urep num rcaps ->
        match Dcaps.matureUserDay maturity urep day dcapsh with
        | Some c -> (c,num)::rcaps
        | None -> rcaps
      end reps [] in
      
      (* -- filter_map would be easy 
         -- if not for combining (c,num)... 
        H.filter_map begin fun urep num ->
        Dreps.getUserDay dcapsh urep day
      end reps |> H.values *)
      
      let (s,n) = 
      L.fold_left begin fun (c,num) (csum,numtotal) ->
        csum +. c *. (float num), numtotal+num
      end (0.,0) rcaps in
      if n = 0 then dsranks
      else
        let audiences = s /. float n in
        match Dcaps.matureUserDay maturity user day dcapsh with
        | Some my when audiences > 0. -> 
            let srank = my /. audiences in
            (day,(srank,audiences))::dsranks
        | _ -> dsranks        
    end days []
  end dreps