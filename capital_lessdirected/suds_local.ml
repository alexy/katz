(* the weight-directionless reciprocal social capital:
   we do not multiply by the number of one-way links,
   only by the total balance *)

open Common
open Ustats

let version = "lessdirected capital"

let stepOut ustats from to' num res = 
  let {outsUS =outs; totUS =tot; balUS =bal} = ustats --> from in
  let toBal = H.find_default bal to' 0 in
  if toBal >= 0 then res
  else begin
    let toSoc = getSocCap ustats to' in
      if toSoc = 0. then res
      else
        (* let toOut = H.find_default outs to' 1 in *)
        let toTot = H.find_default tot  to' 1 in
        (* was: float (num * toBal * toOut) *)
        let term = float (num * toBal) *. toSoc /. float toTot in
        res -. term (* the term is negative, so we sum positive *)
  end
  
  
(* we don't really have to factor out stepIn as it's not used in the simulation *)
let stepIn ustats from to' num ((backSum,allSum) as res) =
  let {insUS =ins; totUS =tot; balUS =bal} = ustats --> from in
  let toSoc = getSocCap ustats to' in
  if toSoc = 0. then res
  else begin
    (* let toIn  = H.find_default ins to' 1 in *)
    let toTot = H.find_default tot to' 1 in
    (* was: float (num * toIn) *)
    let allTerm  = float num *. toSoc /. float toTot in
    let toBal = H.find_default bal to' 0 in
    let backTerm = if toBal <= 0 then 0. else float toBal *. allTerm in
    (backSum +. backTerm,allSum +. allTerm)
  end
