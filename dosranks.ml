(* compute starranks *)
   
open Common

let () =
  let args = getArgs in
  let minDaysO = Some 7 in
  let minCap  = 1e-7 in
  let drepsName,dcapsName =
  match args with
    | drepsName::dcapsName::restArgs -> drepsName,dcapsName
    | _ -> failwith "usage: dosranks drepsName dcapsName"      
  in  

  let starsName = "stars-"^dcapsName in

  let dreps: dreps = loadData drepsName in
  let dcaps: dcaps = loadData dcapsName in
  
  let dcapsh,startsh = Dcaps.dcaps_hash dcaps in
  let maturity = match minDaysO with
  | Some minDays -> Some (startsh,minDays,minCap)
  | _ -> None in
  let stars = Starrank.starrank dreps dcapsh maturity in
  
  saveData stars starsName
