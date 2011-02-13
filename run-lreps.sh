../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 --glouni --fofmen fg8uf05m4wk ../ereps/dreps.mlb 22

../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.2 -J 0.05 --glouni --fofmen fg2uf05m0
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.2 -J 0.05 --glouni --fofmen fg2uf05m1wk ../ereps/dreps.mlb 7
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.2 -J 0.05 --glouni --fofmen fg2uf05m2wk ../ereps/dreps.mlb 14
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.2 -J 0.05 --glouni --fofmen fg2uf05m3wk ../ereps/dreps.mlb 21
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.2 -J 0.05 --glouni --fofmen fg2uf05m4wk ../ereps/dreps.mlb 22

../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.2 -J 0.05 --glouni --fofcap fg2uf05c0
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.2 -J 0.05 --glouni --fofcap fg2uf05c1wk ../ereps/dreps.mlb 7
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.2 -J 0.05 --glouni --fofcap fg2uf05c2wk ../ereps/dreps.mlb 14
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.2 -J 0.05 --glouni --fofcap fg2uf05c3wk ../ereps/dreps.mlb 21
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.2 -J 0.05 --glouni --fofcap fg2uf05c4wk ../ereps/dreps.mlb 22

../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 --glouni --fofcap fg8uf05c0
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 --glouni --fofcap fg8uf05c1wk ../ereps/dreps.mlb 7
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 --glouni --fofcap fg8uf05c2wk ../ereps/dreps.mlb 14
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 --glouni --fofcap fg8uf05c3wk ../ereps/dreps.mlb 21
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 --glouni --fofcap fg8uf05c4wk ../ereps/dreps.mlb 22


for i in caps*; do ../../docranks.opt $i; done
for i in aranks*; do ../../save_rbucks.opt $i; done

mv rbucks-* rbucks
cd rbucks

for i in rbucks*; do ../../../doversets.opt ../../rbucks/rbucks-aranks-caps-dreps.mlb rbucks-aranks-caps-$i.mlb dreps-$i; done

for i j in \
fg5uf1u0 fg5uf1u1wk fg5uf1u1wk fg5uf1u2wk fg5uf1u2wk fg5uf1u3wk fg5uf1u3wk fg5uf1u4wk fg5uf1u0 fg5uf1u2wk fg5uf1u1wk fg5uf1u3wk fg5uf1u2wk fg5uf1u4wk \
fg5mf1m0 fg5mf1m1wk fg5mf1m1wk fg5mf1m2wk fg5mf1m2wk fg5mf1m3wk fg5mf1m3wk fg5mf1m4wk fg5mf1m0 fg5mf1m2wk fg5mf1m1wk fg5mf1m3wk fg5mf1m2wk fg5mf1m4wk \
fg5uf1m0 fg5uf1m1wk fg5uf1m1wk fg5uf1m2wk fg5uf1m2wk fg5uf1m3wk fg5uf1m3wk fg5uf1m4wk fg5uf1m0 fg5uf1m2wk fg5uf1m1wk fg5uf1m3wk fg5uf1m2wk fg5uf1m4wk \
fg8uf05m0 fg8uf05m1wk fg8uf05m1wk fg8uf05m2wk fg8uf05m2wk fg8uf05m3wk fg8uf05m3wk fg8uf05m4wk fg8uf05m0 fg8uf05m2wk fg8uf05m1wk fg8uf05m3wk fg8uf05m2wk fg8uf05m4wk \
fg8uf05c0 fg8uf05c1wk fg8uf05c1wk fg8uf05c2wk fg8uf05c2wk fg8uf05c3wk fg8uf05c3wk fg8uf05c4wk fg8uf05c0 fg8uf05c2wk fg8uf05c1wk fg8uf05c3wk fg8uf05c2wk fg8uf05c4wk \
fg2uf05m0 fg2uf05m1wk fg2uf05m1wk fg2uf05m2wk fg2uf05m2wk fg2uf05m3wk fg2uf05m3wk fg2uf05m4wk fg2uf05m0 fg2uf05m2wk fg2uf05m1wk fg2uf05m3wk fg2uf05m2wk fg2uf05m4wk \
fg2uf05c0 fg2uf05c1wk fg2uf05c1wk fg2uf05c2wk fg2uf05c2wk fg2uf05c3wk fg2uf05c3wk fg2uf05c4wk fg2uf05c0 fg2uf05c2wk fg2uf05c1wk fg2uf05c3wk fg2uf05c2wk fg2uf05c4wk \
fg5uf1u0 fg5mf1m0 fg5uf1u1wk fg5mf1m1wk fg5uf1u2wk fg5mf1m2wk fg5uf1u3wk fg5mf1m3wk fg5uf1u4wk fg5mf1m4wk \
fg5uf1u0 fg5uf1m0 fg5uf1u1wk fg5uf1m1wk fg5uf1u2wk fg5uf1m2wk fg5uf1u3wk fg5uf1m3wk fg5uf1u4wk fg5uf1m4wk \
fg5mf1u0 fg5uf1m0 fg5mf1u1wk fg5uf1m1wk fg5mf1u2wk fg5uf1m2wk fg5mf1u3wk fg5uf1m3wk fg5mf1u4wk fg5uf1m4wk \
fg5uf1u0 fg8uf05m0 fg5uf1u1wk fg8uf05m1wk fg5uf1u2wk fg8uf05m2wk fg5uf1u3wk fg8uf05m3wk fg5uf1u4wk fg8uf05m4wk \
fg8uf05c0 fg8uf05m0 fg8uf05c1wk fg8uf05m1wk fg8uf05c2wk fg8uf05m2wk fg8uf05c3wk fg8uf05m3wk fg8uf05c4wk fg8uf05m4wk; \
fg2uf05c0 fg2uf05m0 fg2uf05c1wk fg2uf05m1wk fg2uf05c2wk fg2uf05m2wk fg2uf05c3wk fg2uf05m3wk fg2uf05c4wk fg2uf05m4wk; \
fg2uf05c0 fg8uf05c0 fg2uf05c1wk fg8uf05c1wk fg2uf05c2wk fg8uf05c2wk fg2uf05c3wk fg8uf05c3wk fg2uf05c4wk fg8uf05c4wk; \
do ../../../doversets.opt rbucks-aranks-caps-$i rbucks-aranks-caps-$j $i-$j; done
