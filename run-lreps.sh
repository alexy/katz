# for i j in lj2u2wk 14 lj2u3wk 21 lj2u4wk 28; do echo ../../su.opt ../dstarts.mlb ../drnums/nr-dreps.mlb $i ../ereps/dreps.mlb $j; done
../../su.opt ../dstarts.mlb ../drnums/nr-dreps.mlb lj2u2wk ../ereps/dreps.mlb 14
../../su.opt ../dstarts.mlb ../drnums/nr-dreps.mlb lj2u3wk ../ereps/dreps.mlb 21
../../su.opt ../dstarts.mlb ../drnums/nr-dreps.mlb lj2u4wk ../ereps/dreps.mlb 28
# for i j in lj2m2wk 14 lj2m3wk 21 lj2m4wk 28; do echo ../../su.opt --amen ../dstarts.mlb ../drnums/nr-dreps.mlb $i ../ereps/dreps.mlb $j; done
../../su.opt --amen ../dstarts.mlb ../drnums/nr-dreps.mlb lj2m2wk ../ereps/dreps.mlb 14
../../su.opt --amen ../dstarts.mlb ../drnums/nr-dreps.mlb lj2m3wk ../ereps/dreps.mlb 21
../../su.opt --amen ../dstarts.mlb ../drnums/nr-dreps.mlb lj2m4wk ../ereps/dreps.mlb 28
# for i j in lj1u1wk 7 lj1u2wk 14 lj1u3wk 21 lj1u4wk 28; do echo ../../su.opt -j 0.1 ../dstarts.mlb ../drnums/nr-dreps.mlb $i ../ereps/dreps.mlb $j; done
../../su.opt -j 0.1 ../dstarts.mlb ../drnums/nr-dreps.mlb lj1u0
../../su.opt -j 0.1 ../dstarts.mlb ../drnums/nr-dreps.mlb lj1u1wk ../ereps/dreps.mlb 7
../../su.opt -j 0.1 ../dstarts.mlb ../drnums/nr-dreps.mlb lj1u2wk ../ereps/dreps.mlb 14
../../su.opt -j 0.1 ../dstarts.mlb ../drnums/nr-dreps.mlb lj1u3wk ../ereps/dreps.mlb 21
../../su.opt -j 0.1 ../dstarts.mlb ../drnums/nr-dreps.mlb lj1u4wk ../ereps/dreps.mlb 28
# for i j in lj1m1wk 7 lj1m2wk 14 lj1m3wk 21 lj1m4wk 28; do echo ../../su.opt -j 0.1 --amen ../dstarts.mlb ../drnums/nr-dreps.mlb $i ../ereps/dreps.mlb $j; done
../../su.opt -j 0.1 --amen ../dstarts.mlb ../drnums/nr-dreps.mlb lj1m0
../../su.opt -j 0.1 --amen ../dstarts.mlb ../drnums/nr-dreps.mlb lj1m1wk ../ereps/dreps.mlb 7
../../su.opt -j 0.1 --amen ../dstarts.mlb ../drnums/nr-dreps.mlb lj1m2wk ../ereps/dreps.mlb 14
../../su.opt -j 0.1 --amen ../dstarts.mlb ../drnums/nr-dreps.mlb lj1m3wk ../ereps/dreps.mlb 21
../../su.opt -j 0.1 --amen ../dstarts.mlb ../drnums/nr-dreps.mlb lj1m4wk ../ereps/dreps.mlb 28
#
../../su.opt -j 0.5 ../dstarts.mlb ../drnums/nr-dreps.mlb lj5u0
../../su.opt -j 0.5 ../dstarts.mlb ../drnums/nr-dreps.mlb lj5u1wk ../ereps/dreps.mlb 7
../../su.opt -j 0.5 ../dstarts.mlb ../drnums/nr-dreps.mlb lj5u2wk ../ereps/dreps.mlb 14
../../su.opt -j 0.5 ../dstarts.mlb ../drnums/nr-dreps.mlb lj5u3wk ../ereps/dreps.mlb 21
../../su.opt -j 0.5 ../dstarts.mlb ../drnums/nr-dreps.mlb lj5u4wk ../ereps/dreps.mlb 28
#
../../su.opt -j 0.5 --amen ../dstarts.mlb ../drnums/nr-dreps.mlb lj5m0
../../su.opt -j 0.5 --amen ../dstarts.mlb ../drnums/nr-dreps.mlb lj5m1wk ../ereps/dreps.mlb 7
../../su.opt -j 0.5 --amen ../dstarts.mlb ../drnums/nr-dreps.mlb lj5m2wk ../ereps/dreps.mlb 14
../../su.opt -j 0.5 --amen ../dstarts.mlb ../drnums/nr-dreps.mlb lj5m3wk ../ereps/dreps.mlb 21
../../su.opt -j 0.5 --amen ../dstarts.mlb ../drnums/nr-dreps.mlb lj5m4wk ../ereps/dreps.mlb 28
for i in caps*; do ../../docranks.opt $i; done
for i in aranks*; do ../../save_rbucks.opt $i; done