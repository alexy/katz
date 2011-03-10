open Batteries_uni
open Utils
  
let loadData fileName =
  leprintf "loading data from file %s" fileName;
  if String.ends_with fileName ".xz" then begin
    leprintfln " via xzcat";
    load_mlbxz fileName
  end
  else begin
    le_newline;
    let ib = open_in_bin fileName in
    let r = Marshal.from_channel ib in
    close_in ib;
    r
  end

let saveData data fileName =
  let ob = open_out_bin fileName in
  leprintfln "saving data in file %s" fileName;
  Marshal.to_channel ob data [];
  close_out ob
  