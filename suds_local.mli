(* general reciprocal social capital *)

open Common
open Ustats

val stepOut: user_stats -> user -> user -> int -> float -> float
  
val stepIn:  user_stats -> user -> user -> int -> float * float -> float * float
