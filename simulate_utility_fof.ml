open Common
open Sgraph
include Attachment_fof


let edgeCountNames = ("total","jump","stay","backup",
"GlobalUniform","GlobalMentions","GlobalSocCap",
"FOFUniform","FOFMentions","FOFSocCap","AsIs")
let (totalEC,jumpEC,stayEC,backupEC,
  globalUniformEC,globalMentionsEC,globalSocCapEC,
  fOFUniformEC,fOFMentionsEC,fOFSocCapEC,asIsEC) = edgeCountNames
let edgeCountNamesList = [totalEC;jumpEC;stayEC;backupEC;
globalUniformEC;globalMentionsEC;globalSocCapEC;
fOFUniformEC;fOFMentionsEC;fOFSocCapEC;asIsEC]

let addEdge: sgraph -> degr -> edge_counts -> day -> user -> ?n:int -> user -> unit = 
  fun sgraph degr edgeCount day fromUser ?(n=1) toUser ->
    let {drepsSG =dreps; dmentsSG =dments} = sgraph in
    let inDegree  = degrInDegree  degr in 
    let outDegree = degrOutDegree degr in 
    let fromDay = Dreps.userDay dreps fromUser day in  
    hashInc ~n fromDay toUser;
    hashInc ~n outDegree fromUser;
    let toDay = Dreps.userDay  dments toUser day in
    hashInc ~n toDay fromUser;
    hashInc ~n inDegree toUser;
    hashInc ~n edgeCount totalEC;
    if (edgeCount --> totalEC) mod 10000 = 0 then leprintf "." else ()

exception NotFound  of string
exception RandomInt of string * int

let rec justJump strategy ?(backupStrategy=GlobalUniformAttachment) sgraph degr edgeCount day fromUser  =
  let jumpBack error where =
    leprintfln "WARNING *** %s in justJump %s --> %s" error where fromUser;
    hashInc edgeCount backupEC;
    justJump backupStrategy sgraph degr edgeCount day fromUser
  in
  match strategy with
  | GlobalUniformAttachment -> begin
      let userArray1,_ =  degrInDeProps degr in
      let toUser = randomElementBut0th userArray1 in
      hashInc edgeCount globalUniformEC;
      addEdge sgraph degr edgeCount day fromUser toUser
    end
 | GlobalMentionsAttachment -> begin
      hashInc edgeCount globalMentionsEC;
      let toUser = Proportional.pickInt2 (degrInDeProps degr) in
      addEdge sgraph degr edgeCount day fromUser toUser
    end
  | GlobalSocCapAttachment -> begin
      hashInc edgeCount globalSocCapEC;
      let toUser = Proportional.pickFloat2 (degrSocCapProps degr) in
      addEdge sgraph degr edgeCount day fromUser toUser      
    end
  | FOFUniformAttachment -> begin
    try 
      let fnofs = degrFnofs degr in
      let someFOF = 
      Proportional.pickInt2 (fnofs --> fromUser) in
      let someFriends1,_ = fnofs --> someFOF in
      let toUser = randomElementBut0th someFriends1 in
      hashInc edgeCount fOFUniformEC;
      addEdge sgraph degr edgeCount day fromUser toUser
    with Not_found -> 
      jumpBack "Not_found" "FOFUniformAttachment"
    end
  | FOFMentionsAttachment -> begin
    try 
      let fnumMents = degrFnumMents degr in
      let fnofMents = degrFnofMents degr in
      let someFOF = 
      try Proportional.pickInt2 (fnofMents --> fromUser)
      with
        | Not_found -> 
          raise (NotFound("fnofMents"))
        | Invalid_argument("Random.int") ->
          raise (RandomInt("fnofMents", 
                            fnofMents --> fromUser |> Proportional.bound))
      in
      let toUser = 
      try Proportional.pickInt2 (fnumMents --> someFOF)
      with
        | Not_found -> 
          raise (NotFound("fnumMents"))
        | Invalid_argument("Random.int") ->
          raise (RandomInt("fnumMents", 
                            fnumMents --> fromUser |> Proportional.bound))
      in
      hashInc edgeCount fOFMentionsEC;
      addEdge sgraph degr edgeCount day fromUser toUser
    with 
    | NotFound(where) -> 
      jumpBack "Not_found" ("FOFMentionsAttachment "^where)
    | RandomInt(where,num) ->
      jumpBack (sprintf "Invalid_argument(\"Random.int\"): %d" num) ("FOFMentionsAttachment "^where)
    end
  | FOFSocCapAttachment -> begin
    try
      let fsocs  = degrFsocs  degr in
      let fscofs = degrFscofs degr in
      let someFOF = Proportional.pickFloat2 (fscofs --> fromUser) in
      hashInc edgeCount fOFSocCapEC;
      let toUser = Proportional.pickFloat2 (fsocs --> someFOF) in
      addEdge sgraph degr edgeCount day fromUser toUser
    with Not_found -> 
      jumpBack "Not_found" "FOFSocCapAttachment"
    end
  | NoAttachment -> leprintfln "*** justJump called with NoAttachment ***"
  | Buckets      -> leprintfln "*** justJump called with Buckets ***"


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
  
  
(* NB shares the meat with makeFsocs and dcaps.mature_caps -- factor out? *)
let makeSocCapProportions: day -> float -> day ->
  (* ?(sort=false) -> ?(desc=false) ->  *)
  user_stats -> float_proportions =
  fun minDays minCap day ustats ->
  Ustats.mature_caps minDays minCap ustats day |> H.enum |>
  (* if sort then sortHEnum ~desc else identity |> *)
  Proportional.floatRangeLists

      
let makeFNums: user_stats -> fnums =
  fun ustats ->
  H.map begin fun _ {totUS =tot} ->
    H.length tot 
  end ustats


let makeBuckets: day -> float -> day -> user_stats -> buckets =
  fun minDays minCap day ustats ->
  Ustats.mature_caps minDays minCap ustats day |>
  Cranks.rankList |>
  Topsets.buckets

  
(* may avoid separate fnums altogether and compute fnum as
  (ustats --> friend).tot |> H.length, but too many repeated accesses? 
  NB: fnums are importnt in growUtility jumping, as a guard when fnums = 0 *)
let makeFNOFs: user_stats -> fnums -> fnofs =
  fun ustats fnums ->
    (* TODO can use fnums instead of H.is_empty tot, computed in makeFNums? *)
  ustats |> H.filter begin fun {totUS =tot} -> not (H.is_empty tot) end |>
  H.map begin fun user {totUS =tot} ->
    (* TODO are enums eating too much memory?
       Should we replace H.keys ... E.map user, f user 
       by H.map user val ... H.enum, right before Proportional? *)
    H.keys tot |> E.map begin fun friend ->
      friend,
      try fnums --> friend (* total number of that friend's friends! *)
      with Not_found -> failwith (sprintf "Not_found in makeFNOFs fnums --> %s" friend)
    end |> 
    E.filter (snd |- (<) 0)
  end |>
  H.filter (E.is_empty |- not) |>
  H.map (map_second Proportional.intRangeLists)
     
   
let makeFNumMents: user_stats -> udegr -> fnofs =
  fun ustats inDegree ->
  ustats |> H.filter begin fun {totUS =tot} -> not (H.is_empty tot) end |>
  H.map begin fun user {totUS =tot} ->
    H.keys tot |> E.map begin fun friend ->
      friend,H.find_default inDegree friend 0
    end |>
    E.filter (snd |- (<) 0)
  end |>
  H.filter (E.is_empty |- not) |>
  H.map (map_second Proportional.intRangeLists)
  (* |> H.filter (Proportional.bound |- (<) 1) *)
  

let makeFNOFMents: fnofs -> fnofs =
  fun fnumMents ->
  fnumMents |> H.map begin fun user (friends,_) ->
    A.enum friends |> E.skip 1 |> E.map begin fun friend ->
      friend,
      try fnumMents --> friend |> Proportional.bound (* total number of mentions of all that user's friends! *)
      with Not_found -> 0                            (* issue 0 and filter this whole pair in the coming E.filter *)
        (* failwith (sprintf "Not_found in makeFNOFs, enum over prefiltered fnumMents --> %s" friend) *)
    end |> 
    E.filter (snd |- (<) 0)
  end |>
  H.filter (E.is_empty |- not) |>
  H.map (map_second Proportional.intRangeLists) 
  (* |> H.filter (Proportional.bound |- (<) 1) *)
  
  
let makeFsocs: day -> float -> day -> user_stats -> fsocs =
  fun minDays minCap day ustats ->
  ustats |> H.filter begin fun {totUS =tot} -> not (H.is_empty tot) end |>
  H.map begin fun _ {totUS=tot} ->
    H.map begin fun friend _ -> 
      let {socUS =cap; dayUS =sincetDay} = ustats-->friend in
      if day - sincetDay > minDays then cap
      else minCap
    end tot |> H.enum |>
    Proportional.floatRangeLists
  end


let makeFscofs: fsocs -> fsocs =
  fun fsocs ->
  fsocs |> H.map begin fun _ (friends,_)  ->
    A.enum friends |> E.skip 1 |> E.map begin fun friend ->
      friend,
      fsocs --> friend |> Proportional.bound
    end |>
    Proportional.floatRangeLists
  end
  
  
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


let computeStrategyData genOpts degr ustats day newUsers =
 let {strategyFeaturesGO =strategyFeatures; minCapDaysGO =minDays; minCapGO =minCap} = genOpts in
 L.fold_left begin fun degr feature ->
    match feature with
     | x when x = inDegreeSF  -> begin assert (Option.is_some degr.inDegreeDG); degr end
     | x when x = outDegreeSF -> begin assert (Option.is_some degr.outDegreeDG); degr end
     | x when x = inDePropsSF -> let inDeProps = makeInDegreeProportions (degrInDegree degr) newUsers in
                      { degr with inDePropsDG=Some inDeProps }
     | x when x = socCapPropsSF -> let socCapProps = makeSocCapProportions minDays minCap day ustats in
                      { degr with socCapPropsDG = Some socCapProps }
     | x when x = fnumsSF     -> let fnums = makeFNums ustats in
                      { degr with fnumsDG=Some fnums }
     | x when x = fnofsSF     -> let fnofs = makeFNOFs ustats (degrFnums degr) in
                      { degr with fnofsDG=Some fnofs }
     | x when x = fnumMentsSF -> let fnumMents = makeFNumMents ustats (degrInDegree degr) in
                      { degr with fnumMentsDG=Some fnumMents }
     | x when x = fnofMentsSF -> let fnofMents = makeFNOFMents (degrFnumMents degr) in
                      { degr with fnofMentsDG=Some fnofMents }
     | x when x = fsocsSF     -> let fsocs = makeFsocs minDays minCap day ustats in
                      { degr with fsocsDG=Some fsocs }
     | x when x = fscofsSF    -> let fscofs = makeFscofs (degrFsocs degr) in
                      { degr with fscofsDG=Some fscofs }
     | x when x = bucketsSF -> let buckets = makeBuckets minDays minCap day ustats in
                      { degr with bucketsDG = Some buckets }
     | x -> failwith (sprintf "an impossible strategy feature %s is needed!" x)
  end degr strategyFeatures
  
   
let basicDegr inDegree outDegree =
  { inDegreeDG=Some inDegree; outDegreeDG=Some outDegree;
    inDePropsDG=None; socCapPropsDG=None;
    fnumsDG=None;     fnofsDG=None;
    fnumMentsDG=None; fnofMentsDG=None;
    fsocsDG=None;     fscofsDG=None;
    bucketsDG=None }


 (* 1-based bucket numers as powers of 10 *)
let keepUser: ?keepBuckets:bool -> buckets -> buckno -> user -> bool =
  fun ?(keepBuckets=true) buckets buckno user ->
  let rec aux ns =
    match ns with
    (* buckets are given by users as 1-based, powers of 10, List.nth is 0-based *)
    | n::ns when n <= L.length buckets && S.mem user (L.nth buckets (pred n)) -> true
    | _::ns -> aux ns
    | _ -> false in
  let res =  
  match buckno with
  (* the way to specify keep none is buckno=Some []; keepBuckets := false *)
  | None -> false
  | Some bucknums -> aux bucknums in
  if keepBuckets
    then res 
    else not res
  
  
let copyEdges degr edgeCount fromUser day dreps1 sgraph =
  match Dreps.getUserDay fromUser day dreps1 with
  | None -> ()
  | Some reps -> 
    H.iter begin fun toUser n ->
      addEdge sgraph degr edgeCount day fromUser ~n toUser;
      hashInc ~n edgeCount asIsEC
    end reps
       

let growUtility genOpts degr sgraph day newUsers userNEdges =
    let {initDrepsGO      =initDreps;
         jumpProbUtilGO   =jumpProbUtil;   jumpProbFOFGO =jumpProbFOF;
         globalStrategyGO =globalStrategy; fofStrategyGO =fofStrategy;
         bucketsGO =buckets; keepBucketsGO =keepBuckets} = genOpts in
    let {ustatsSG =ustats} = sgraph in

    let degr = computeStrategyData genOpts degr ustats day newUsers in

    let edgeCount =  edgeCountNamesList |> L.enum |> E.map (fun x -> x,0) |> H.of_enum in
    
    H.iter begin fun fromUser numEdges ->
      if numEdges > 0 then begin
        
        (* NB error on the Some,None case in the top driver when checking options *)
        match buckets,initDreps with
        | Some bucknums, Some drepsOrig when keepUser ~keepBuckets (degrBuckets degr) buckets fromUser ->
          copyEdges degr edgeCount fromUser day drepsOrig sgraph
        | _ -> 
        let {outsUS =outs} = ustats --> fromUser in
        E.iter begin fun _ ->
          if jumpProbUtil <> 0.0 && begin
             jumpProbUtil =  1.0 ||
             H.is_empty outs || 
             itTurnsOut jumpProbUtil end then begin
             hashInc edgeCount jumpEC;

            (* NB we used to guard with a wrong && guard and called backup jumps in justJump,
               thus throwing GlobalUniform for those into the mix -- may do so explicitly;
               jumpProbFOF = 0. will always skip globalStrategy, hence must have valid backup in 
               justJump fofStrategy! *)
              if jumpProbFOF <> 0.0 && begin
                 jumpProbFOF =  1.0 || fofStrategy = NoAttachment ||
                 (* no friends -- no friends of friends, no? *)
                 (let fnums = degrFnums degr in fnums --> fromUser = 0) ||
                 (fofStrategy = FOFUniformAttachment  && not (H.mem (degrFnofs     degr) fromUser)) ||
                 (fofStrategy = FOFMentionsAttachment && not (H.mem (degrFnofMents degr) fromUser)) ||                
                 (fofStrategy = FOFSocCapAttachment   && not (H.mem (degrFscofs    degr) fromUser)) ||                
                 itTurnsOut jumpProbFOF end then
                 justJump globalStrategy sgraph degr edgeCount day fromUser
              else
                justJump fofStrategy sgraph degr edgeCount day fromUser
          end
          else begin
          
            (* TODO should we simulate num from a Poisson?  1 for now 
               also, can pick not a max but some with a fuzz *)
               
            let toUser,_ = H.keys outs |> L.of_enum |> 
                        L.map (fun to' -> to', Suds_local.stepOut ustats fromUser to' 1 0.) |> 
                        listMax2 in
            addEdge sgraph degr edgeCount day fromUser toUser;
            hashInc edgeCount stayEC
          end
        end (1 -- numEdges)
      end else () (* have edges at all *)
    end userNEdges;
    edgeCount
