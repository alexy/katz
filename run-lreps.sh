../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.2 -J 0.05 --glocap --fofcap fg2cf05c0
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.2 -J 0.05 --glocap --fofcap fg2cf05c1wk ../ereps/dreps.mlb 7
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.2 -J 0.05 --glocap --fofcap fg2cf05c2wk ../ereps/dreps.mlb 14
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.2 -J 0.05 --glocap --fofcap fg2cf05c3wk ../ereps/dreps.mlb 21
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.2 -J 0.05 --glocap --fofcap fg2cf05c4wk ../ereps/dreps.mlb 28

../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 --glocap --fofcap fg8cf05c0
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 --glocap --fofcap fg8cf05c1wk ../ereps/dreps.mlb 7
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 --glocap --fofcap fg8cf05c2wk ../ereps/dreps.mlb 14
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 --glocap --fofcap fg8cf05c3wk ../ereps/dreps.mlb 21
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 --glocap --fofcap fg8cf05c4wk ../ereps/dreps.mlb 28

../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.2 -J 0.05 -c 1e-7 --glouni --fofcap fg2uf05c7m3wk ../ereps/dreps.mlb 21
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.2 -J 0.05 -c 1e-7 --glouni --fofcap fg2uf05c7m4wk ../ereps/dreps.mlb 28

../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 -c 1e-7 --glouni --fofcap fg8uf05c7m0
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 -c 1e-7 --glouni --fofcap fg8uf05c7m1wk ../ereps/dreps.mlb 7
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 -c 1e-7 --glouni --fofcap fg8uf05c7m2wk ../ereps/dreps.mlb 14
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 -c 1e-7 --glouni --fofcap fg8uf05c7m3wk ../ereps/dreps.mlb 21
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 -c 1e-7 --glouni --fofcap fg8uf05c7m4wk ../ereps/dreps.mlb 28

for i in caps-*; do ../../doaranks.opt $i; done
cd caps
for i in *; do [ -e ../rbucks/rbucks-aranks-$i ] || echo ../../../doaranks.opt $i; done
mv aranks-* ..
cd ..
for i in aranks-*; do ../../save_rbucks.opt $i; done

mv rbucks-* rbucks
cd rbucks

for i in rbucks*; do ../../../doversets.opt ../../rbucks/rbucks-aranks-caps-dreps.mlb rbucks-aranks-caps-$i.mlb dreps-$i; done

for i j in \
fg2uf05c0 fg2uf05c1wk fg2uf05c1wk fg2uf05c2wk fg2uf05c2wk fg2uf05c3wk fg2uf05c3wk fg2uf05c4wk fg2uf05c0 fg2uf05c2wk fg2uf05c1wk fg2uf05c3wk fg2uf05c2wk fg2uf05c4wk \
fg8uf05c0 fg8uf05m0 fg8uf05c1wk fg8uf05m1wk fg8uf05c2wk fg8uf05m2wk fg8uf05c3wk fg8uf05m3wk fg8uf05c4wk fg8uf05m4wk; \
fg2uf05c0 fg2uf05m0 fg2uf05c1wk fg2uf05m1wk fg2uf05c2wk fg2uf05m2wk fg2uf05c3wk fg2uf05m3wk fg2uf05c4wk fg2uf05m4wk; \
fg2uf05c0 fg8uf05c0 fg2uf05c1wk fg8uf05c1wk fg2uf05c2wk fg8uf05c2wk fg2uf05c3wk fg8uf05c3wk fg2uf05c4wk fg8uf05c4wk; \
fg8uf05c0 fg8uf05c0 fg8uf05c1wk fg8uf05c1wk fg8uf05c2wk fg8uf05c2wk fg8uf05c3wk fg8uf05c3wk fg8uf05c4wk fg8uf05c4wk; \
fg2uf05c0 fg2uf05c0 fg2uf05c1wk fg2uf05c1wk fg2uf05c2wk fg2uf05c2wk fg2uf05c3wk fg2uf05c3wk fg2uf05c4wk fg2uf05c4wk; \
fg2uf05c7m0 fg2uf05c7m1wk fg2uf05c7m1wk fg2uf05c7m2wk fg2uf05c7m2wk fg2uf05c7m3wk fg2uf05c7m3wk fg2uf05c7m4wk fg2uf05c7m0 fg2uf05c7m2wk fg2uf05c7m1wk fg2uf05c7m3wk fg2uf05c7m2wk fg2uf05c7m4wk \
fg8uf05c7m0 fg8uf05m0 fg8uf05c7m1wk fg8uf05m1wk fg8uf05c7m2wk fg8uf05m2wk fg8uf05c7m3wk fg8uf05m3wk fg8uf05c7m4wk fg8uf05m4wk; \
fg2uf05c7m0 fg2uf05m0 fg2uf05c7m1wk fg2uf05m1wk fg2uf05c7m2wk fg2uf05m2wk fg2uf05c7m3wk fg2uf05m3wk fg2uf05c7m4wk fg2uf05m4wk; \
fg2uf05c7m0 fg8uf05c7m0 fg2uf05c7m1wk fg8uf05c7m1wk fg2uf05c7m2wk fg8uf05c7m2wk fg2uf05c7m3wk fg8uf05c7m3wk fg2uf05c7m4wk fg8uf05c7m4wk; \
fg8uf05c7m0 fg8uf05c0 fg8uf05c7m1wk fg8uf05c1wk fg8uf05c7m2wk fg8uf05c2wk fg8uf05c7m3wk fg8uf05c3wk fg8uf05c7m4wk fg8uf05c4wk; \
fg2uf05c7m0 fg2uf05c0 fg2uf05c7m1wk fg2uf05c1wk fg2uf05c7m2wk fg2uf05c2wk fg2uf05c7m3wk fg2uf05c3wk fg2uf05c7m4wk fg2uf05c4wk; \
fg2uf05c0d0 fg2uf05c0 fg2uf05c0d1wk fg2uf05c1wk fg2uf05c0d2wk fg2uf05c2wk fg2uf05c0d3wk fg2uf05c3wk fg2uf05c0d4wk fg2uf05c4wk; \
fg2cf05c0 fg2cf05c1wk fg2cf05c1wk fg2cf05c2wk fg2cf05c2wk fg2cf05c3wk fg2cf05c3wk fg2cf05c4wk fg2cf05c0 fg2cf05c2wk fg2cf05c1wk fg2cf05c3wk fg2cf05c2wk fg2cf05c4wk \
fg8cf05c0 fg8uf05c0 fg8cf05c1wk fg8uf05c1wk fg8cf05c2wk fg8uf05c2wk fg8cf05c3wk fg8uf05c3wk fg8cf05c4wk fg8uf05c4wk; \
fg2cf05c0 fg2uf05c0 fg2cf05c1wk fg2uf05c1wk fg2cf05c2wk fg2uf05c2wk fg2cf05c3wk fg2uf05c3wk fg2cf05c4wk fg2uf05c4wk; \
do ../../../doversets.opt rbucks-aranks-caps-$i rbucks-aranks-caps-$j $i-$j; done
