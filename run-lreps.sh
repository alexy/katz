../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.1 -J 1.0 --glocap --fofnone lj1c0
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.1 -J 1.0 --glocap --fofnone lj1c1wk ../ereps/ereps/dreps.mlb 7
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.1 -J 1.0 --glocap --fofnone lj1c2wk ../ereps/ereps/dreps.mlb 14
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.1 -J 1.0 --glocap --fofnone lj1c3wk ../ereps/ereps/dreps.mlb 21
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.1 -J 1.0 --glocap --fofnone lj1c4wk ../ereps/ereps/dreps.mlb 28

../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.2 -J 1.0 --glocap --fofnone lj2c0
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.2 -J 1.0 --glocap --fofnone lj2c1wk ../ereps/ereps/dreps.mlb 7
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.2 -J 1.0 --glocap --fofnone lj2c2wk ../ereps/ereps/dreps.mlb 14
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.2 -J 1.0 --glocap --fofnone lj2c3wk ../ereps/ereps/dreps.mlb 21
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.2 -J 1.0 --glocap --fofnone lj2c4wk ../ereps/ereps/dreps.mlb 28

../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.5 -J 1.0 --glocap --fofnone lj5c0
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.5 -J 1.0 --glocap --fofnone lj5c1wk ../ereps/ereps/dreps.mlb 7
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.5 -J 1.0 --glocap --fofnone lj5c2wk ../ereps/ereps/dreps.mlb 14
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.5 -J 1.0 --glocap --fofnone lj5c3wk ../ereps/ereps/dreps.mlb 21
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.5 -J 1.0 --glocap --fofnone lj5c4wk ../ereps/ereps/dreps.mlb 28

for i in caps-*; do ../../doaranks.opt $i; done
for i in aranks-*; do ../../save_rbucks.opt $i; done
