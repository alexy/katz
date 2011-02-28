../../sf.opt -j 0.5 -J 0.1 --glomen --fofcap ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb fg5mf1c0   
../../sf.opt -j 0.5 -J 0.1 --glomen --fofcap ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb fg5mf1c1wk ../ereps/ereps/dreps.mlb 7
../../sf.opt -j 0.5 -J 0.1 --glomen --fofcap ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb fg5mf1c2wk ../ereps/ereps/dreps.mlb 14
../../sf.opt -j 0.5 -J 0.1 --glomen --fofcap ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb fg5mf1c3wk ../ereps/ereps/dreps.mlb 21
../../sf.opt -j 0.5 -J 0.1 --glomen --fofcap ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb fg5mf1c4wk ../ereps/ereps/dreps.mlb 28

for i in caps-*; do ../../doaranks.opt $i; done
for i in aranks-*; do ../../save_rbucks.opt $i; done
