../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --globmen --fofmen fg5mf1m0
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --globmen --fofmen fg5mf1m1wk ../ereps/dreps.mlb 7
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --globmen --fofmen fg5mf1m2wk ../ereps/dreps.mlb 14
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --globmen --fofmen fg5mf1m3wk ../ereps/dreps.mlb 21
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --globmen --fofmen fg5mf1m4wk ../ereps/dreps.mlb 28

../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --globmen --fofcap fg5mf1c0
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --globmen --fofcap fg5mf1c1wk ../ereps/dreps.mlb 7
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --globmen --fofcap fg5mf1c2wk ../ereps/dreps.mlb 14
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --globmen --fofcap fg5mf1c3wk ../ereps/dreps.mlb 21
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --globmen --fofcap fg5mf1c4wk ../ereps/dreps.mlb 28

../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --globmen --fofuni fg5mf1u0
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --globmen --fofuni fg5mf1u1wk ../ereps/dreps.mlb 7
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --globmen --fofuni fg5mf1u2wk ../ereps/dreps.mlb 14
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --globmen --fofuni fg5mf1u3wk ../ereps/dreps.mlb 21
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --globmen --fofuni fg5mf1u4wk ../ereps/dreps.mlb 28

for i in caps*; do ../../docranks.opt $i; done
for i in aranks*; do ../../save_rbucks.opt $i; done