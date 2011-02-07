open Common
open Sgraph_local
open Gen_opts
open Suds_local

let addEdge: sgraph -> int ref -> day -> user -> user -> unit = 
  fun sgraph edgeCount day fromUser toUser ->
    let {drepsSG =dreps; dmentsSG =dments; 
         inDegreeSG =inDegree; outDegreeSG =outDegree} = sgraph in 
    let fromDay = Dreps.userDay dreps fromUser day in  
    hashInc fromDay toUser;
    hashInc outDegree fromUser;
    let toDay = Dreps.userDay  dments toUser day in
    hashInc toDay fromUser;
    hashInc inDegree toUser;
    incr edgeCount; 
    if !edgeCount mod 10000 = 0 then leprintf "." else ()


let justJump genOpts sgraph edgeCount day fromUser  =
  let {attachmentStrategyGO =attachmentStrategy} = genOpts in
  let {ustatsSG =ustats; inDegreeProportionsSG =inDegreeProportions} = sgraph in
  match attachmentStrategy with
  | UniformAttachment -> 
    let userArray,_ =  inDegreeProportions in
    let n = Random.int (A.length userArray - 1) |> succ in 
    let toUser = userArray.(n) in
    addEdge sgraph edgeCount day fromUser toUser
  | MentionsAttachment ->
    let names,vals = inDegreeProportions in
    let bound = array_last vals in
    match Proportional.pickInt vals bound with
    | None -> () | Some n -> 
      let toUser = names.(n) in 
      addEdge sgraph edgeCount day fromUser toUser


let growUtility genOpts sgraph day userNEdges =
    let {jumpProbGO =jumpProb} = genOpts in
    let {ustatsSG =ustats} = sgraph in
    let edgeCount = ref 0 in
    let jumpCount = ref 0 in
    let stayCount = ref 0 in
    userNEdges |> H.iter begin fun fromUser numEdges ->
      if numEdges > 0 then begin
        let {outsUS =outs} = ustats --> fromUser in
        E.iter begin fun _ ->
          if (H.is_empty outs) || itTurnsOut jumpProb then begin
              justJump genOpts sgraph edgeCount day fromUser;
              incr jumpCount 
            end
          else begin
            
              (* TODO should we simulate num from a Poisson?  1 for now 
                 also, can pick not a max but some with a fuzz *)
                 
              let toUser,_ = H.keys outs |> L.of_enum |> 
                          L.map (fun to' -> to', stepOut ustats fromUser to' 1 0.) |> 
                          listMax2 in
              addEdge sgraph edgeCount day fromUser toUser;
            incr stayCount
          end
        end (1 -- numEdges)
      end else ()
    end;
    !edgeCount,!jumpCount,!stayCount


(* NB we're implementing 1 smoothing here.  It means someone with 1 mention will be twice as likely
   to get a mention than a newbie (1 + 1 = 2, 0 + 1 = 1) 
   We can easily smooth with a floating-point number and use the corresponding
   version of the proportional choice accroding to float-valued bucket sizes *)
   
let makeInDegreeProportions inDegree novices =
  let oldies      = H.enum inDegree |> E.map (fun (u,n) -> u,succ n) in
  let newbies     = L.enum novices |> E.map (fun x -> x,1) in
  let attachables = E.append oldies newbies in
  Proportional.rangeLists (+)  1 0 attachables