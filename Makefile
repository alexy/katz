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
CRANKS=docranks
ARANKS=doaranks
RATES=dorates
SCAPS=save_caps
BUCKS=dobucks
BLENS=doblens
SKEW=sk

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

lib: h.cmo graph.cmo utils.cmo common.cmo binary_graph.cmo by_day.cmo dranges.cmo proportional.cmo dcaps.cmo
	ocamlfind ocamlc -a -o lib.cma $^

lib.cmxa: h.cmx graph.cmx utils.cmx binary_graph.cmx common.cmx by_day.cmx dranges.cmx proportional.cmx dcaps.cmx
	ocamlfind ocamlopt -a -o lib.cmxa $^

clean:
	rm -f *.cmi *.cmo *.cmx *.o *.opt


$(SAVE_GRAPH).opt: lib.cmxa json_graph.cmx tokyo_graph.cmx binary_graph.cmx $(SAVE_GRAPH).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(INVERT_GRAPH).opt: lib.cmxa invert.cmx $(INVERT_GRAPH).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ common.cmx -o $@

$(BYDAY).opt: lib.cmxa by_day.cmx json_graph.cmx tokyo_graph.cmx binary_graph.cmx load_graph.cmx $(BYDAY).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(STARTS).opt: lib.cmxa json_graph.cmx tokyo_graph.cmx binary_graph.cmx load_graph.cmx dranges.cmx invert.cmx $(STARTS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@


$(LOOK):      lib.cma binary_graph.cmo $(LOOK).ml
	ocamlfind ocamlc   $(DEBUG) -package $(PACKAGES) -linkpkg $^ -o $@

$(LOOK).opt:  lib.cmxa binary_graph.cmx $(LOOK).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@


$(SC):     lib.cma json_graph.cmo tokyo_graph.cmo binary_graph.cmo load_graph.cmo graph.cmo dranges.cmo soc_run.cmo invert.cmo $(SC).ml
	ocamlfind ocamlc   $(DEBUG) -package $(PACKAGES) -linkpkg $^ -o $@

$(SC).opt: lib.cmxa json_graph.cmx tokyo_graph.cmx load_graph.cmx dranges.cmx soc_run.cmx invert.cmx $(SC).cmx
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(SIM).opt: lib.cmxa dranges.cmx dreps.cmx invert.cmx proportional.cmx simulate.cmx $(SIM).cmx
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(SIMF).opt: lib.cmxa dranges.cmx dreps.cmx invert.cmx proportional.cmx simulate.cmx $(SIMF).cmx
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(CRANKS).opt: lib.cmxa cranks.cmx $(CRANKS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(ARANKS).opt: lib.cmxa cranks.cmx $(ARANKS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(RATES).opt: lib.cmxa cranks.cmx topsets.cmx $(RATES).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(SCAPS).opt: lib.cmxa $(SCAPS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(BUCKS).opt: lib.cmxa $(BUCKS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(BLENS).opt: lib.cmxa $(BLENS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(SKEW).opt: lib.cmxa json_graph.cmx tokyo_graph.cmx load_graph.cmx dranges.cmx skew.cmx soc_run_skew.cmx invert.cmx $(SKEW).cmx
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@
