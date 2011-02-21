(* compute starranks *)
   
open Common
open Getopt

let minDays' = ref (Some 7)
let minCap'  = ref 1e-35
let mark'    = ref ""
let specs =
[
  ('d',"mindays",None,Some (fun x -> minDays' := Some (int_of_string x)));
  (noshort,"nomindays",(set minDays' None), None);
  ('c',"mincap",None,Some (fun x -> minCap' := float_of_string x));
  ('k',"mark",  None,Some (fun x -> mark' := x))
]

let () =
  let args = getOptArgs specs in
  
  let mark,   minDays,   minCap =
      !mark', !minDays', !minCap' in

  let drepsName,dcapsName =
  match args with
    | drepsName::dcapsName::restArgs -> drepsName,dcapsName
    | _ -> failwith "usage: dosranks drepsName dcapsName"      
  in  

  let starsName = "stars-"^mark^drepsName in
  leprintfln "reading dreps from %s, dcaps from %s, storing stars in %s" drepsName dcapsName starsName;
  begin match minDays with
  | Some minDays -> leprintfln "applying minCap %e for maturities less than %d days" minCap minDays
  | _ -> leprintfln "not using maturity at all" 
  end;

  let dreps: dreps = loadData drepsName in
  let dcaps: dcaps = loadData dcapsName in
  
  let dcapsh,startsh = Dcaps.dcaps_hash dcaps in
  let maturity = match minDays with
  | Some minDays -> Some (startsh,minDays,minCap)
  | _ -> None in
  let stars: starrank = Starrank.starrank dreps dcapsh maturity in
  
  saveData stars starsName
