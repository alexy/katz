open Common
open Sgraph
open Suds_local
include Attachment_fof

let addEdge: sgraph -> degr -> edge_counts -> day -> user -> user -> unit = 
  fun sgraph degr edgeCount day fromUser toUser ->
    let {drepsSG =dreps; dmentsSG =dments} = sgraph in
    let {inDegreeDG =inDegree; outDegreeDG =outDegree} = degr in 
    let fromDay = Dreps.userDay dreps fromUser day in  
    hashInc fromDay toUser;
    hashInc outDegree fromUser;
    let toDay = Dreps.userDay  dments toUser day in
    hashInc toDay fromUser;
    hashInc inDegree toUser;
    hashInc edgeCount "total"; 
    if (edgeCount --> "total") mod 10000 = 0 then leprintf "." else ()


let justJump strategy sgraph degr edgeCount day fromUser  =
  let {ustatsSG =ustats} = sgraph in
  let {inDePropsDG =inDeProps; fnofsDG     =fnofs; 
       fnumMentsDG =fnumMents; fnofMentsDG =fnofMents} = degr in
  let toUser = 
  match strategy with
  | GlobalUniformAttachment -> begin
      let userArray1,_ =  inDeProps in
      hashInc edgeCount "GlobalUniform";
      randomElementBut0th userArray1
    end
  | GlobalMentionsAttachment -> begin
      hashInc edgeCount "GlobalMentions";
      Proportional.pickInt2 inDeProps
    end
  | FOFUniformAttachment -> begin
      let someFOF = Proportional.pickInt2 (fnofs --> fromUser) in
      let someFriends1,_ = fnofs --> someFOF in
      hashInc edgeCount "FOFUniform";
      randomElementBut0th someFriends1
    end
  | FOFMentionsAttachment -> begin
      let someFOF = Proportional.pickInt2 (fnofMents --> fromUser) in
      hashInc edgeCount "FOFMentions";
      Proportional.pickInt2 (fnumMents --> someFOF)
    end
  in
  addEdge sgraph degr edgeCount day fromUser toUser;
  hashInc edgeCount "jump"


let edgeCountNames = ["total";"jump";"stay";"GlobalUniform";"GlobalMentions";"FOFUniform";"FOFMentions"]

let growUtility genOpts sgraph degr day userNEdges =
    let {jumpProbUtilGO   =jumpProbUtil;   jumpProbFOFGO =jumpProbFOF;
         globalStrategyGO =globalStrategy; fofStrategyGO =fofStrategy} = genOpts in
    let {ustatsSG =ustats} = sgraph in
    let {fnumsDG  =fnums}  = degr in
    
    let edgeCount =  edgeCountNames |> L.enum |> E.map (fun x -> x,0) |> H.of_enum in
    H.iter begin fun fromUser numEdges ->
      if numEdges > 0 then begin
        let {outsUS =outs} = ustats --> fromUser in
        E.iter begin fun _ ->
          if (H.is_empty outs) || itTurnsOut jumpProbUtil then begin
              if fnums --> fromUser = 0 || itTurnsOut jumpProbFOF then
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
            hashInc edgeCount "stay"
          end
        end (1 -- numEdges)
      end else ()
    end userNEdges;
    edgeCount


(* NB we're implementing 1 smoothing here.  It means someone with 1 mention will be twice as likely
   to get a mention than a newbie (1 + 1 = 2, 0 + 1 = 1) 
   We can easily smooth with a floating-point number and use the corresponding
   version of the proportional choice accroding to float-valued bucket sizes *)
   
   
let makeFNums: user_stats -> fnums =
  fun ustats ->
  H.map begin fun _ {totUS =tot} ->
    H.length tot 
  end ustats


let makeInDegreeProportions: udegr -> users -> int_proportions =
  fun inDegree novices ->
  let oldies      = H.enum inDegree |> E.map (fun (u,n) -> u,succ n) in
  let newbies     = L.enum novices |> E.map (fun x -> x,1) in
  let attachables = E.append oldies newbies in
  Proportional.intRangeLists attachables

  
(* may avoid separate fnums altogether and compute fnum as
  (ustats --> friend).tot |> H.length, but too many repeated accesses? *)
let makeFNOFs: user_stats -> fnums -> fnofs =
  fun ustats fnums ->
  H.map begin fun user {totUS =tot} ->
    let userFNums = H.keys tot |> E.map begin fun friend ->
      friend,fnums --> friend (* total number of that friend's friends! *)
    end in
    Proportional.intRangeLists userFNums
  end ustats
   
   
let makeFNumMents: user_stats -> udegr -> fnofs =
  fun ustats inDegree ->
  H.map begin fun user {totUS =tot} ->
    let userFMents = H.keys tot |> E.map begin fun friend ->
      friend,inDegree --> friend
    end in
    Proportional.intRangeLists userFMents
  end ustats
  

let makeFNOFMents: user_stats -> fnofs -> fnofs =
  fun ustats fnumMents ->
  H.map begin fun user {totUS =tot} ->
    let userFMentsTotal = H.keys tot |> E.map begin fun friend ->
      friend,fnumMents --> friend |> snd |> array_last (* total number of mentions of all that user's friends! *)
    end in
    Proportional.intRangeLists userFMentsTotal
  end ustats
  