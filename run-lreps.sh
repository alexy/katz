../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glouni --fofuni fg5uf1u0
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glouni --fofuni fg5uf1u1wk ../ereps/dreps.mlb 7
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glouni --fofuni fg5uf1u2wk ../ereps/dreps.mlb 14
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glouni --fofuni fg5uf1u3wk ../ereps/dreps.mlb 21
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glouni --fofuni fg5uf1u4wk ../ereps/dreps.mlb 28

../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glomen --fofmen fg5mf1m0
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glomen --fofmen fg5mf1m1wk ../ereps/dreps.mlb 7
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glomen --fofmen fg5mf1m2wk ../ereps/dreps.mlb 14
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glomen --fofmen fg5mf1m3wk ../ereps/dreps.mlb 21
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glomen --fofmen fg5mf1m4wk ../ereps/dreps.mlb 28

../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glouni --fofmen fg5uf1m0
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glouni --fofmen fg5uf1m1wk ../ereps/dreps.mlb 7
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glouni --fofmen fg5uf1m2wk ../ereps/dreps.mlb 14
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glouni --fofmen fg5uf1m3wk ../ereps/dreps.mlb 21
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glouni --fofmen fg5uf1m4wk ../ereps/dreps.mlb 28

../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 --glouni --fofmen fg5uf05m0
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 --glouni --fofmen fg5uf05m1wk ../ereps/dreps.mlb 7
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 --glouni --fofmen fg5uf05m2wk ../ereps/dreps.mlb 14
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 --glouni --fofmen fg5uf05m3wk ../ereps/dreps.mlb 21
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 --glouni --fofmen fg5uf05m4wk ../ereps/dreps.mlb 28

../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 --glouni --fofcap fg5uf05c0
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 --glouni --fofcap fg5uf05c1wk ../ereps/dreps.mlb 7
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 --glouni --fofcap fg5uf05c2wk ../ereps/dreps.mlb 14
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 --glouni --fofcap fg5uf05c3wk ../ereps/dreps.mlb 21
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 --glouni --fofcap fg5uf05c4wk ../ereps/dreps.mlb 28


for i in caps*; do ../../docranks.opt $i; done
for i in aranks*; do ../../save_rbucks.opt $i; done

mv rbucks-* rbucks
cd rbucks

for i in rbucks*; do ../../../doversets.opt ../../rbucks/rbucks-aranks-caps-dreps.mlb rbucks-aranks-caps-$i.mlb dreps-$i; done

for i j in \
fg5uf1u0 fg5uf1u1wk fg5uf1u1wk fg5uf1u2wk fg5uf1u2wk fg5uf1u3wk fg5uf1u3wk fg5uf1u4wk fg5uf1u0 fg5uf1u2wk fg5uf1u1wk fg5uf1u3wk fg5uf1u2wk fg5uf1u4wk \
fg5mf1m0 fg5mf1m1wk fg5mf1m1wk fg5mf1m2wk fg5mf1m2wk fg5mf1m3wk fg5mf1m3wk fg5mf1m4wk fg5mf1m0 fg5mf1m2wk fg5mf1m1wk fg5mf1m3wk fg5mf1m2wk fg5mf1m4wk \
fg5uf1m0 fg5uf1m1wk fg5uf1m1wk fg5uf1m2wk fg5uf1m2wk fg5uf1m3wk fg5uf1m3wk fg5uf1m4wk fg5uf1m0 fg5uf1m2wk fg5uf1m1wk fg5uf1m3wk fg5uf1m2wk fg5uf1m4wk \
fg5uf05m0 fg5uf05m1wk fg5uf05m1wk fg5uf05m2wk fg5uf05m2wk fg5uf05m3wk fg5uf05m3wk fg5uf05m4wk fg5uf05m0 fg5uf05m2wk fg5uf05m1wk fg5uf05m3wk fg5uf05m2wk fg5uf05m4wk \
fg5uf1u0 fg5mf1m0 fg5uf1u1wk fg5mf1m1wk fg5uf1u2wk fg5mf1m2wk fg5uf1u3wk fg5mf1m3wk fg5uf1u4wk fg5mf1m4wk \
fg5uf1u0 fg5uf1m0 fg5uf1u1wk fg5uf1m1wk fg5uf1u2wk fg5uf1m2wk fg5uf1u3wk fg5uf1m3wk fg5uf1u4wk fg5uf1m4wk \
fg5mf1u0 fg5uf1m0 fg5mf1u1wk fg5uf1m1wk fg5mf1u2wk fg5uf1m2wk fg5mf1u3wk fg5uf1m3wk fg5mf1u4wk fg5uf1m4wk \
fg5uf1u0 fg5uf05m0 fg5uf1u1wk fg5uf05m1wk fg5uf1u2wk fg5uf05m2wk fg5uf1u3wk fg5uf05m3wk fg5uf1u4wk fg5uf05m4wk \
fg5uf05c0 fg5uf05m0 fg5uf05c1wk fg5uf05m1wk fg5uf05c2wk fg5uf05m2wk fg5uf05c3wk fg5uf05m3wk fg5uf05c4wk fg5uf05m4wk; \
do ../../../doversets.opt rbucks-aranks-caps-$i rbucks-aranks-caps-$j $i-$j; done
