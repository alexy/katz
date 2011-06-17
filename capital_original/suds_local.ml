(* the original reciprocal social capital *)

open Common
open Ustats

let version = "original capital"

let stepOut ustats from to' num res = 
  let {outsUS =outs; totUS =tot; balUS =bal} = ustats --> from in
  let toBal = H.find_default bal to' 0 in
  if toBal >= 0 then res
  else begin
    let toSoc = getSocCap ustats to' in
      if toSoc = 0. then res
      else
        let toOut = H.find_default outs to' 1 in
        let toTot = H.find_default tot  to' 1 in
        let term = float (num * toBal * toOut) *. toSoc /. float toTot in
        res -. term (* the term is negative, so we sum positive *)
  end
  
  
(* we don't really have to factor out stepIn as it's not used in the simulation *)
let stepIn ustats from to' num ((backSum,allSum) as res) =
  let {insUS =ins; totUS =tot; balUS =bal} = ustats --> from in
  let toSoc = getSocCap ustats to' in
  if toSoc = 0. then res
  else begin
    let toIn  = H.find_default ins to' 1 in
    let toTot = H.find_default tot to' 1 in
    let allTerm  = float (num * toIn) *. toSoc /. float toTot in
    let toBal = H.find_default bal to' 0 in
    let backTerm = if toBal <= 0 then 0. else float toBal *. allTerm in
    (backSum +. backTerm,allSum +. allTerm)
  end
