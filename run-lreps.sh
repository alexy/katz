../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glouni --fofuni fg5uf1u1wk ../ereps/dreps.mlb 7
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glouni --fofuni fg5uf1u2wk ../ereps/dreps.mlb 14
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glouni --fofuni fg5uf1u3wk ../ereps/dreps.mlb 21
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glouni --fofuni fg5uf1u4wk ../ereps/dreps.mlb 28

for i in caps*; do ../../docranks.opt $i; done
for i in aranks*; do ../../save_rbucks.opt $i; done