(* compute starranks *)
   
open Common

let () =
  let args = getArgs in
  let drepsName,dcapsName =
  match args with
    | drepsName::dcapsName::restArgs -> drepsName,dcapsName
    | _ -> failwith "usage: dosranks drepsName dcapsName"      
  in  

  let starsName = "stars-"^dcapsName in

  let dreps: dreps = loadData drepsName in
  let dcaps: dcaps = loadData dcapsName in
  
  let dcapsh = Dcaps.dcaps_hash dcaps in

  let stars = Starrank.starrank dreps dcapsh in
  
  saveData stars starsName
