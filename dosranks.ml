(* compute starranks *)
   
open Common
open Getopt

let invert'      = ref false
let minDays'     = ref (Some 7)
let minCap'      = ref 1e-35
let mark'        = ref ""
let prefix'      = ref "stars"
let outdir'      = ref (Some !prefix')
let drepsInfix'  = ref "dreps"
let dmentsInfix' = ref "dments"
let specs =
[
  (noshort,"prefix",None,Some (fun x -> prefix' := x));
  (noshort,"outdir",None,Some (fun x -> outdir' := Some x));
  (noshort,"nodir", (set outdir' None), None);
  (noshort,"dreps", None,Some (fun x -> drepsInfix'  := x));
  (noshort,"dments",None,Some (fun x -> dmentsInfix' := x));
  ('i',"invert",(set invert' (not !invert')),None);
  ('d',"mindays",None,Some (fun x -> minDays' := Some (int_of_string x)));
  (noshort,"nomindays",(set minDays' None), None);
  ('c',"mincap",None,Some (fun x -> minCap' := float_of_string x));
  ('k',"mark",  None,Some (fun x -> mark' := x))
]

let () =
  let args = getOptArgs specs in
  
  let invert,   minDays,   minCap =
      !invert', !minDays', !minCap' in
      
  let drepsInfix,   dmentsInfix =
      !drepsInfix', !dmentsInfix' in

  let prefix,   outdir,   mark  =
      !prefix', !outdir', !mark' in
  
  let drepsName,dcapsName,outdir =
  match args with
    | drepsName::dcapsName::outdir::restArgs -> drepsName,dcapsName,Some outdir
    | drepsName::dcapsName::restArgs         -> drepsName,dcapsName,outdir
    | _ -> failwith "usage: dosranks drepsName dcapsName [outdir]"      
  in  

  let baseName = cutPathZ drepsName in
  let ok,baseName = 
    if invert
      then String.replace ~str:baseName ~sub:drepsInfix ~by:dmentsInfix
      else true,baseName in
  assert ok;
  let starsName = sprintf "%s-%s%s" prefix mark baseName |> mayPrependDir outdir in
  leprintfln "reading dreps from %s, dcaps from %s, storing stars in %s" drepsName dcapsName starsName;
  begin match minDays with
  | Some minDays -> leprintfln "applying minCap %e for maturities less than %d days" minCap minDays
  | _ -> leprintfln "not using maturity at all" 
  end;

  let dreps: dreps = loadData drepsName in
  let dreps = if invert then Invert.invert2 dreps else dreps in
  let dcaps: dcaps = loadData dcapsName in
  
  let dcapsh,startsh = Dcaps.dcaps_hash dcaps in
  let maturity = match minDays with
  | Some minDays -> Some (startsh,minDays,minCap)
  | _ -> None in
  let stars: starrank = Starrank.starrank dreps dcapsh maturity in
  
  mayMkDir outdir;
  saveData stars starsName
