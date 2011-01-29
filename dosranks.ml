(* compute starranks *)
   
open Common
open Getopt

let minDaysO = Some 7
let minCap = ref 1e-35
let specs =
[
  ('c',"mincap",None,Some (fun x -> minCap := float_of_string x))
]

let () =
  let restArgsE = E.empty () in
  let pushArg a = E.push restArgsE a in
  parse_cmdline specs pushArg;
  let args = L.of_enum restArgsE |> L.rev in

  let drepsName,dcapsName =
  match args with
    | drepsName::dcapsName::restArgs -> drepsName,dcapsName
    | _ -> failwith "usage: dosranks drepsName dcapsName"      
  in  

  let starsName = "stars-"^dcapsName in
  leprintfln "reading dreps from %s, dcaps from %s, storing stars in %s" drepsName dcapsName starsName;
  begin match minDaysO with
  | Some minDays -> leprintfln "applying minCap %e for maturities less than %d days" !minCap minDays
  | _ -> leprintfln "not using maturity at all" 
  end;

  let dreps: dreps = loadData drepsName in
  let dcaps: dcaps = loadData dcapsName in
  
  let dcapsh,startsh = Dcaps.dcaps_hash dcaps in
  let maturity = match minDaysO with
  | Some minDays -> Some (startsh,minDays,!minCap)
  | _ -> None in
  let stars = Starrank.starrank dreps dcapsh maturity in
  
  saveData stars starsName
