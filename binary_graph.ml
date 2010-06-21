open Utils
  
let loadData fileName =
  let ib = open_in_bin fileName in
  leprintfln "loading data from file %s" fileName;
  let graph = Marshal.from_channel ib in
  close_in ib;
  graph

let saveData data fileName =
  let ob = open_out_bin fileName in
  leprintfln "saving data in file %s" fileName;
  Marshal.to_channel ob data [];
  close_out ob
  