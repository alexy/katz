open Batteries_uni
open Utils
module H=Hashtbl

let minMax1 (oldMin, oldMax) x =
  let newMin = min oldMin x in
  let newMax = max oldMax x in
  (newMin, newMax)

let minMax2 (oldMin, oldMax) (x,y) =
  let newMin = min oldMin x in
  let newMax = max oldMax y in
  (newMin, newMax)

(* find the day range when each user exists in dreps *)

let dayRanges dreps = 
    let doDays _ doReps =
        if H.is_empty doReps then None
        else
          let days = H.keys doReps in
          let aDay = match Enum.peek days with 
            | Some day -> day
            | _ -> failwith "should have some days here" in
          let dayday = (aDay,aDay) in
          let ranges = Enum.fold (fun res elem -> minMax1 res elem) dayday days in
          Some ranges
    in
    H.filter_map doDays dreps

let startsRange dreps dments =    
    let dranges = hashMergeWith minMax2 (dayRanges dreps) (dayRanges dments) in
    let dstarts = H.fold (fun user (d1,d2) res -> 
        let users = H.find_default res d1 [] in H.replace res d1 (user::users); res) 
        dranges (H.create 100000) in    
    let firstLast = H.fold (fun _ v res -> minMax2 v res) dranges (dranges |> hashFirst |> snd) in
    (dstarts,firstLast)
    
type users = Graph.user list
type starts = users array

let startsArray dreps dments =
  let (dstarts,(firstDay,lastDay)) = startsRange dreps dments in
  let a : starts = Array.create (succ lastDay) [] in
  H.iter begin fun day users -> 
    a.(day) <- users end dstarts;
  a