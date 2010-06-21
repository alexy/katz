open Printf
let leprintf   format = eprintf (format ^^ "%!")
let leprintfln format = eprintf (format ^^ "\n%!")

let showSomeInt x = match x with | Some i -> string_of_int i | _ -> "none"
