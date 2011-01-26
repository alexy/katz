SAVE_GRAPH=save_graph
INVERT_GRAPH=invert_graph
SC=sc
LOOK=look
#DEBUG=-g
#PROFILE=-p
OPTFLAGS=-inline 100 $(PROFILE)
PACKAGES=batteries,tokyo_cabinet,otoky,json-wheel
BYDAY=save_days
STARTS=save_starts
SIM=dosim
SIMF=dosimf
SIMU=dosimu
CRANKS=docranks
ARANKS=doaranks
RATES=dorates
SCAPS=save_caps
CBUCKS=dobucks
BLENS=doblens
SKEW=sk
SGEN=sg
RBUCKS=save_rbucks
VOLS=dovols
SAVE_REME=save_reme
OVERLAPS=doverlaps
OVERSETS=doversets

all: $(SIM).opt $(SIMF).opt
  
all.opt: $(SAVE_GRAPH).opt $(SC) $(SC).opt $(LOOK) $(LOOK).opt $(BYDAY).opt $(STARTS).opt $(SIM).opt

common.cmx: binary_graph.cmx h.cmx utils.cmx
load_graph.ml tokyo_graph.ml json_graph.ml: common.ml

%.opt: common.cmx
  
%.cmo %.cmx: %.cmi
  
%.cmo: %.ml
	ocamlfind ocamlc   $(DEBUG) -package $(PACKAGES) -c $^ -o $@

%.cmx: %.ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -c $^ -o $@

json_graph.cmo: graph.cmo
json_graph.cmx: graph.cmx

tokyo_graph.cmo: json_graph.cmo graph.cmo
tokyo_graph.cmx: json_graph.cmx graph.cmx

soc_run.cmo: dranges.cmo utils.cmo graph.cmo
soc_run.cmx: dranges.cmx utils.cmx graph.cmx

sc.cmx save_starts.cmx: dranges.cmx
invert.cmx by_day.cmx: utils.cmx graph.cmx

simulate.cmx: dreps.cmx proportional.cmx
  
topsets.cmx: cranks.cmx

lib: h.cmo graph.cmo utils.cmo binary_graph.cmo common.cmo constants.cmo by_day.cmo dranges.cmo dreps.cmo proportional.cmo dcaps.cmo skew.cmo soc_run_common.cmo
	ocamlfind ocamlc -a -o lib.cma $^

lib.cmxa: h.cmx graph.cmx utils.cmx binary_graph.cmx common.cmx constants.cmx by_day.cmx dranges.cmx dreps.cmx proportional.cmx dcaps.cmx skew.cmx soc_run_common.cmx
	ocamlfind ocamlopt -a -o $@ $^

anygraph.cma:  json_graph.cmo tokyo_graph.cmo load_graph.cmo
	ocamlfind ocamlc -a -o $@ $^
  
anygraph.cmxa: json_graph.cmx tokyo_graph.cmx load_graph.cmx
	ocamlfind ocamlopt -a -o $@ $^
  

clean:
	rm -f *.cmi *.cmo *.cmx *.o *.opt


$(SAVE_GRAPH).opt: lib.cmxa json_graph.cmx tokyo_graph.cmx binary_graph.cmx $(SAVE_GRAPH).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(INVERT_GRAPH).opt: lib.cmxa invert.cmx $(INVERT_GRAPH).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ common.cmx -o $@

$(SC):     lib.cma anygraph.cma graph.cmo soc_run.cmo invert.cmo $(SC).ml
	ocamlfind ocamlc   $(DEBUG) -package $(PACKAGES) -linkpkg $^ -o $@

$(SC).opt: lib.cmxa anygraph.cmxa soc_run.cmx invert.cmx $(SC).cmx
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(LOOK):      lib.cma binary_graph.cmo $(LOOK).ml
	ocamlfind ocamlc   $(DEBUG) -package $(PACKAGES) -linkpkg $^ -o $@

$(LOOK).opt:  lib.cmxa binary_graph.cmx $(LOOK).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(BYDAY).opt: lib.cmxa json_graph.cmx tokyo_graph.cmx load_graph.cmx $(BYDAY).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(SAVE_REME).opt: lib.cmxa $(SAVE_REME).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@
  
$(STARTS).opt: lib.cmxa json_graph.cmx tokyo_graph.cmx binary_graph.cmx load_graph.cmx dranges.cmx invert.cmx $(STARTS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(SIM).opt:  lib.cmxa invert.cmx simulate.cmx $(SIM).cmx
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(SIMF).opt: lib.cmxa invert.cmx simulate.cmx $(SIMF).cmx
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(SIMU).opt: lib.cmxa invert.cmx simulate.cmx $(SIMU).cmx
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(CRANKS).opt: lib.cmxa cranks.cmx $(CRANKS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(ARANKS).opt: lib.cmxa cranks.cmx $(ARANKS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(RATES).opt: lib.cmxa cranks.cmx topsets.cmx $(RATES).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(SCAPS).opt: lib.cmxa $(SCAPS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(CBUCKS).opt: lib.cmxa $(CBUCKS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(RBUCKS).opt: lib.cmxa topsets.cmx $(RBUCKS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(BLENS).opt: lib.cmxa $(BLENS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(SKEW).opt: lib.cmxa anygraph.cmxa soc_run_skew.cmx invert.cmx $(SKEW).cmx
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(SGEN).opt: lib.cmxa invert.cmx simulate.cmx soc_run_gen.cmx $(SGEN).cmx
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(VOLS).opt: lib.cmxa by_day.cmx cranks.cmx topsets.cmx volume.cmx $(VOLS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(OVERLAPS).opt: lib.cmxa topsets.cmx $(OVERLAPS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(OVERSETS).opt: lib.cmxa topsets.cmx $(OVERSETS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@
