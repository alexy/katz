../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.2 -J 0.05 -c 1e-7 --glouni --fofcap fg2uf05c7m0
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.2 -J 0.05 -c 1e-7 --glouni --fofcap fg2uf05c7m1wk ../ereps/dreps.mlb 7
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.2 -J 0.05 -c 1e-7 --glouni --fofcap fg2uf05c7m2wk ../ereps/dreps.mlb 14
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.2 -J 0.05 -c 1e-7 --glouni --fofcap fg2uf05c7m3wk ../ereps/dreps.mlb 21
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.2 -J 0.05 -c 1e-7 --glouni --fofcap fg2uf05c7m4wk ../ereps/dreps.mlb 28

../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 -c 1e-7 --glouni --fofcap fg8uf05c7m0
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 -c 1e-7 --glouni --fofcap fg8uf05c7m1wk ../ereps/dreps.mlb 7
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 -c 1e-7 --glouni --fofcap fg8uf05c7m2wk ../ereps/dreps.mlb 14
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 -c 1e-7 --glouni --fofcap fg8uf05c7m3wk ../ereps/dreps.mlb 21
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.05 -c 1e-7 --glouni --fofcap fg8uf05c7m4wk ../ereps/dreps.mlb 28

for i in caps*; do ../../docranks.opt $i; done
for i in aranks*; do ../../save_rbucks.opt $i; done

# mv rbucks-* rbucks
# cd rbucks
# 
# for i in rbucks*; do ../../../doversets.opt ../../rbucks/rbucks-aranks-caps-dreps.mlb rbucks-aranks-caps-$i.mlb dreps-$i; done
# 
# for i j in \
# fg2uf05ce0 fg2uf05ce1wk fg2uf05ce1wk fg2uf05ce2wk fg2uf05ce2wk fg2uf05ce3wk fg2uf05ce3wk fg2uf05ce4wk fg2uf05ce0 fg2uf05ce2wk fg2uf05ce1wk fg2uf05ce3wk fg2uf05ce2wk fg2uf05ce4wk \
# fg8uf05ce0 fg8uf05m0 fg8uf05ce1wk fg8uf05m1wk fg8uf05ce2wk fg8uf05m2wk fg8uf05ce3wk fg8uf05m3wk fg8uf05ce4wk fg8uf05m4wk; \
# fg2uf05ce0 fg2uf05m0 fg2uf05ce1wk fg2uf05m1wk fg2uf05ce2wk fg2uf05m2wk fg2uf05ce3wk fg2uf05m3wk fg2uf05ce4wk fg2uf05m4wk; \
# fg2uf05ce0 fg8uf05ce0 fg2uf05ce1wk fg8uf05ce1wk fg2uf05ce2wk fg8uf05ce2wk fg2uf05ce3wk fg8uf05ce3wk fg2uf05ce4wk fg8uf05ce4wk; \
# fg8uf05ce0 fg8uf05c0 fg8uf05ce1wk fg8uf05c1wk fg8uf05ce2wk fg8uf05c2wk fg8uf05ce3wk fg8uf05c3wk fg8uf05ce4wk fg8uf05c4wk; \
# fg2uf05ce0 fg2uf05c0 fg2uf05ce1wk fg2uf05c1wk fg2uf05ce2wk fg2uf05c2wk fg2uf05ce3wk fg2uf05c3wk fg2uf05ce4wk fg2uf05c4wk; \
# do ../../../doversets.opt rbucks-aranks-caps-$i rbucks-aranks-caps-$j $i-$j; done
