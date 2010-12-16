open Batteries_uni

type user = string
type day  = int
type reps = (user,int) Hashtbl.t
type adjlist = (day,reps) Hashtbl.t
type graph = (user,adjlist) Hashtbl.t
