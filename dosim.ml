open Common
open Binary_graph

let () =
    let args = getArgs in
  match args with
  | dstartsName::denumsName::erepsName::restArgs -> begin
    leprintfln "reading dstarts from %s and dnums from %s, saving ereps in %s" dstartsName dnumsName erepsName;
    
    let dstarts: Dranges.starts  = loadData dstartsName in
    let denums: By_day.dedgenums = loadData denumsName in
    
    let ereps = simulate dstarts denums in
    saveData ereps erepsName
  end
  | _ -> leprintf "usage: save_starts dstartsName dnumsName simrepsName"

  