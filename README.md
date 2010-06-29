FunData Twitter Shootout -- OCaml
=================================

This is the OCaml version of the [http://github.com/alexy/fundata1](Functional Data Shootout #1), implementing the Karmic Social Capital (KSC) on Twitter Communication Graph.  The _fundata1_ repository contains all the necessary documentation about the shootout and data itself.  Here we'll provide some implementation notes specific to OCaml.


Building
--------

	make
	
The main executable is `sc.opt`, natively compiled.
	
I tried to learn `omake` here, and it builds the executable, but that then fails to process command line arguments properly.  I'm probably missing something.

Running
-------

You have to set `OCAMLRUNPARAM` or it will take forever.  Smaller values may work:

	export OCAMLRUNPARAM='h=5G;s=1G'

	time ./sc.opt <dreps> <dments> <dcaps> [maxDays]
	
It reads the graph from _<dreps>_ and <dments>, which can be either `.json.hdb` or `.mlb` files.  The latter ones are the results of `save_graph.opt`, reading in the former and saving in OCaml's own binary format via `Marshal.to_cahnnel`.  The result is uncompressed.
	
	
Data Preparation
----------------

If you want to create a smaller version of the original graphs, you can use the `save_graph` program.  It's invoked as follows:

	./save_graph.opt <orig.json.hdb> <save> [N] [progress]
	
If N is given, it will limit the number of entries read from the original -- only those will be used to build the OCaml graph and dump that into `<save>.mlb`.  If progress is given, a dot will be printed after so many entries; the default is 10,000.


Mostly Functional
-----------------

This is a translation of [http://github.com/alexy/husky](husky), a Haskell implementation of KSC, into OCaml.  At first, _husky_ was crashing under _ghc 6.12.1_ which had a GC bug.  While Simon Marlow valiantly fought and quashed it, I translated _husky_ to _clams_.  

Some things stand out in OCaml, e.g.

-- floating-point operators are distinct from integer ones, and contain a dot: `+. *. /.`  

-- Equality is tested with `=` or `==` -- but `== 0.` fails for `float`s.

-- `safeDivide x y` doesn't check for `y = 0.`, but rather goes ahead with the division and then checks whether the result is `nan` or `infinite`.

Just a Little Bit Imperative
----------------------------

OCaml's standard _map_ data structure is an imperative `Hashtbl`.  At creation time, it wants to know how much to allocate; we just go ahead and allocate it all for the number of users, i.e. 

	let orderN = 5000000 in
	Hashtbl.create orderN;
	
Hence instead of folds, some operations are `List.iter`, and all those updating a `Hashtbl` have type `unit` and value `()`.  This can present a moment's pause when translating back for a purely functional map.

Better Maps
-----------

Mauricio Fernandez and Mattias Giaovannini developed [http://eigenclass.org/R2/writings/finite-map-benchmarks](faster maps for OCaml).  Some are functional, like `ternary`, some are imperative, like `Fasthashtbl`.  The latter works best when there's no deletions, which is the case.

