open Common
open Sgraph
open Suds_local
include Attachment_fof
let oget=Option.get


let edgeCountNames = ("total","jump","stay",
"GlobalUniform","GlobalMentions",
"FOFUniform","FOFMentions","FOFSocCap")
let (totalEC,jumpEC,stayEC,globalUniformEC,globalMentionsEC,
fOFUniformEC,fOFMentionsEC,fOFSocCapEC) = edgeCountNames
let edgeCountNamesList = [totalEC;jumpEC;stayEC;globalUniformEC;globalMentionsEC;
fOFUniformEC;fOFMentionsEC;fOFSocCapEC]

let addEdge: sgraph -> degr -> edge_counts -> day -> user -> user -> unit = 
  fun sgraph degr edgeCount day fromUser toUser ->
    let {drepsSG =dreps; dmentsSG =dments} = sgraph in
    let inDegree  = degrInDegree  degr in 
    let outDegree = degrOutDegree degr in 
    let fromDay = Dreps.userDay dreps fromUser day in  
    hashInc fromDay toUser;
    hashInc outDegree fromUser;
    let toDay = Dreps.userDay  dments toUser day in
    hashInc toDay fromUser;
    hashInc inDegree toUser;
    hashInc edgeCount totalEC;
    if (edgeCount --> totalEC) mod 10000 = 0 then leprintf "." else ()


let justJump strategy sgraph degr edgeCount day fromUser  =
  let toUser =
  match strategy with
  | GlobalUniformAttachment -> begin
      let userArray1,_ =  degrInDeProps degr in
      hashInc edgeCount globalUniformEC;
      randomElementBut0th userArray1
    end
 | GlobalMentionsAttachment -> begin
      hashInc edgeCount globalMentionsEC;
      Proportional.pickInt2 (degrInDeProps degr)
    end
  | FOFUniformAttachment -> begin
      let fnofs = degrFnofs degr in
      let someFOF = 
        try Proportional.pickInt2 (fnofs --> fromUser)
      with Not_found -> failwith (sprintf "Not_found in justJump fnofs --> %s" fromUser) in
      let someFriends1,_ = fnofs --> someFOF in
      hashInc edgeCount fOFUniformEC;
      randomElementBut0th someFriends1
    end
  | FOFMentionsAttachment -> begin
      let fnumMents = degrFnumMents degr in
      let fnofMents = degrFnofMents degr in
      let someFOF = 
        try Proportional.pickInt2 (fnofMents --> fromUser) 
      with Not_found -> failwith (sprintf "Not_found in justJump fnofMents --> %s" fromUser) in
      hashInc edgeCount fOFMentionsEC;
      try Proportional.pickInt2 (fnumMents --> someFOF)
      with Not_found -> failwith (sprintf "Not_found in justJump fnumMents --> %s" someFOF) 
    end
  | FOFSocCapAttachment -> begin
      let fsocs  = degrFsocs  degr in
      let fscofs = degrFscofs degr in
      let someFOF = 
        try Proportional.pickFloat2 (fscofs --> fromUser) 
      with Not_found -> failwith (sprintf "Not_found in justJump fscofs --> %s" fromUser) in
      hashInc edgeCount fOFSocCapEC;
      try Proportional.pickFloat2 (fsocs --> someFOF)
      with Not_found -> failwith (sprintf "Not_found in justJump fsocs --> %s" someFOF) 
    end
  in
  addEdge sgraph degr edgeCount day fromUser toUser;
  hashInc edgeCount jumpEC


let growUtility genOpts sgraph degr day userNEdges =
    let {jumpProbUtilGO   =jumpProbUtil;   jumpProbFOFGO =jumpProbFOF;
         globalStrategyGO =globalStrategy; fofStrategyGO =fofStrategy} = genOpts in
    let {ustatsSG =ustats} = sgraph in
    let fnums = degrFnums degr in
    
    let edgeCount =  edgeCountNamesList |> L.enum |> E.map (fun x -> x,0) |> H.of_enum in
    H.iter begin fun fromUser numEdges ->
      if numEdges > 0 then begin
        let {outsUS =outs} = ustats --> fromUser in
        E.iter begin fun _ ->
          if (H.is_empty outs) || jumpProbUtil = 0.0 || itTurnsOut jumpProbUtil then begin
              if fnums --> fromUser = 0 || jumpProbFOF = 0.0 || itTurnsOut jumpProbFOF then
                justJump globalStrategy sgraph degr edgeCount day fromUser
              else
                justJump fofStrategy sgraph degr edgeCount day fromUser
          end
          else begin
          
            (* TODO should we simulate num from a Poisson?  1 for now 
               also, can pick not a max but some with a fuzz *)
               
            let toUser,_ = H.keys outs |> L.of_enum |> 
                        L.map (fun to' -> to', stepOut ustats fromUser to' 1 0.) |> 
                        listMax2 in
            addEdge sgraph degr edgeCount day fromUser toUser;
            hashInc edgeCount stayEC
          end
        end (1 -- numEdges)
      end else ()
    end userNEdges;
    edgeCount


(* NB we're implementing 1 smoothing here.  It means someone with 1 mention will be twice as likely
   to get a mention than a newbie (1 + 1 = 2, 0 + 1 = 1) 
   We can easily smooth with a floating-point number and use the corresponding
   version of the proportional choice accroding to float-valued bucket sizes *)

let makeInDegreeProportions: udegr -> users -> int_proportions =
  fun inDegree novices ->
  let oldies      = H.enum inDegree |> E.map (fun (u,n) -> u,succ n) in
  let newbies     = L.enum novices |> E.map (fun x -> x,1) in
  let attachables = E.append oldies newbies in
  Proportional.intRangeLists attachables

      
let makeFNums: user_stats -> fnums =
  fun ustats ->
  H.map begin fun _ {totUS =tot} ->
    H.length tot 
  end ustats

  
(* may avoid separate fnums altogether and compute fnum as
  (ustats --> friend).tot |> H.length, but too many repeated accesses? *)
let makeFNOFs: user_stats -> fnums -> fnofs =
  fun ustats fnums ->
  H.map begin fun user {totUS =tot} ->
    let userFNums = H.keys tot |> E.map begin fun friend ->
      friend,
      try fnums --> friend (* total number of that friend's friends! *)
    with Not_found -> failwith (sprintf "Not_found in makeFNOFs fnums --> %s" friend)
    end in
    Proportional.intRangeLists userFNums
  end ustats
   
   
let makeFNumMents: user_stats -> udegr -> fnofs =
  fun ustats inDegree ->
  H.map begin fun user {totUS =tot} ->
    let userFMents = H.keys tot |> E.map begin fun friend ->
      friend,H.find_default inDegree friend 0
    end in
    Proportional.intRangeLists userFMents
  end ustats
  

let makeFNOFMents: user_stats -> fnofs -> fnofs =
  fun ustats fnumMents ->
  H.map begin fun user {totUS =tot} ->
    let userFMentsTotal = H.keys tot |> E.map begin fun friend ->
      friend,
      try fnumMents --> friend |> snd |> array_last (* total number of mentions of all that user's friends! *)
    with Not_found -> failwith (sprintf "Not_found in makeFNOFMents fnumMents --> %s" friend)
    end in
    Proportional.intRangeLists userFMentsTotal
  end ustats
  
  
let makeFsocs: user_stats -> fsocs =
  fun ustats ->
  H.map begin fun _ {totUS=tot} ->
    H.map begin fun friend _ -> 
      (ustats-->friend).socUS
    end tot |> H.enum |>
    Proportional.floatRangeLists
  end ustats


let makeFscofs: user_stats -> fsocs -> fsocs =
  fun ustats fsocs ->
  H.map begin fun _ {totUS=tot} ->
    H.map begin fun friend _ -> 
      fsocs-->friend |> snd |> array_last
    end tot |> H.enum |>
    Proportional.floatRangeLists
  end ustats
  
  
(* NB uses prefedined strategyFeatures *)
let computeStrategyFeatures strategyData strategyList =
  let sdata = L.fold_left begin fun res strategy ->
    (* just convert each to a set and union, then restore list order form s
       trategyDataInOrder *)
    let sdata = 
    try L.assoc strategy strategyFeatures |> L.enum |> S.of_enum
      with Not_found -> failwith (sprintf "strategy %s is not found in the strategies-features list" 
        (showStrategy strategy)) in
    S.union res sdata
  end S.empty strategyList in
  L.fold_left begin fun res feature ->
    if S.mem feature sdata then feature::res else res
  end [] strategyFeaturesInOrder |> L.rev 


let computeStrategyData degr features ustats newUsers =
 L.fold_left begin fun degr feature ->
    match feature with
     | x when x = inDePropsSF -> let inDeProps = makeInDegreeProportions (degrInDegree degr) newUsers in
                      { degr with inDePropsDG=Some inDeProps }
     | x when x = fnumsSF     -> let fnums = makeFNums ustats in
                      { degr with fnumsDG=Some fnums }
     | x when x = fnofsSF     -> let fnofs = makeFNOFs ustats (degrFnums degr) in
                      { degr with fnofsDG=Some fnofs }
     | x when x = fnumMentsSF -> let fnumMents = makeFNumMents ustats (degrInDegree degr) in
                      { degr with fnumMentsDG=Some fnumMents }
     | x when x = fnofMentsSF -> let fnofMents = makeFNOFMents ustats (degrFnumMents degr) in
                      { degr with fnofMentsDG=Some fnofMents }
     | x when x = fsocsSF     -> let fsocs = makeFsocs ustats in
                      { degr with fsocsDG=Some fsocs }
     | x when x = fscofsSF    -> let fscofs = makeFscofs ustats (degrFsocs degr) in
                      { degr with fscofsDG=Some fscofs }
     | x -> failwith (sprintf "an impossible strategy feature %s is needed!" x)
  end degr features
  
   
let basicDegr inDegree outDegree =
  { inDegreeDG=Some inDegree; outDegreeDG=Some outDegree;
    inDePropsDG=None;
    fnumsDG=None;     fnofsDG=None;
    fnumMentsDG=None; fnofMentsDG=None;
    fsocsDG=None;     fscofsDG=None }
     
