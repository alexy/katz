open Common
  
let () = 
  let args = getArgs in
  
  let drepsName,saveName =
  match args with
  | drepsName::saveName::restArgs -> drepsName,saveName
  | _ -> failwith "usage: save_starts drepsName dstartsName"
  in
  leprintfln "reading graph from %s, saving dstarts in %s" drepsName saveName;

  let dreps: graph = loadData drepsName in
  leprintfln "loaded %s, %d" drepsName (H.length dreps);
  
  let dments = Invert.invert2 dreps in
  leprintfln "dments has length %d" (H.length dments);  
    
  let dstarts : starts = Dranges.startsArray dreps dments in
  leprintfln "dstarts has length %d" (A.length dstarts);

  saveData dstarts saveName;
