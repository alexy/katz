../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glocap --fofcap fg5cf1c0
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glocap --fofcap fg5cf1c1wk ../ereps/dreps.mlb 7
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glocap --fofcap fg5cf1c2wk ../ereps/dreps.mlb 14
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glocap --fofcap fg5cf1c3wk ../ereps/dreps.mlb 21
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glocap --fofcap fg5cf1c4wk ../ereps/dreps.mlb 28

for i in caps-*; do ../../doaranks.opt $i; done
for i in aranks-*; do ../../save_rbucks.opt $i; done

