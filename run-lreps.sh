../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 fg5uf1u0
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 fg5uf1u1wk ../ereps/dreps/mlb 7
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 fg5uf1u2wk ../ereps/dreps/mlb 14
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 fg5uf1u3wk ../ereps/dreps/mlb 21
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.5 -J 0.1 fg5uf1u4wk ../ereps/dreps/mlb 28

../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.0 fg8uf0u0
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.0 fg8uf0u1wk ../ereps/dreps/mlb 7
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.0 fg8uf0u2wk ../ereps/dreps/mlb 14
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.0 fg8uf0u3wk ../ereps/dreps/mlb 21
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.0 fg8uf0u4wk ../ereps/dreps/mlb 28

../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.1 fg8uf1u0
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.1 fg8uf1u1wk ../ereps/dreps/mlb 7
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.1 fg8uf1u2wk ../ereps/dreps/mlb 14
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.1 fg8uf1u3wk ../ereps/dreps/mlb 21
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.8 -J 0.1 fg8uf1u4wk ../ereps/dreps/mlb 28

../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.4 -J 0.2 fg4uf2u0
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.4 -J 0.2 fg4uf2u1wk ../ereps/dreps/mlb 7
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.4 -J 0.2 fg4uf2u2wk ../ereps/dreps/mlb 14
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.4 -J 0.2 fg4uf2u3wk ../ereps/dreps/mlb 21
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.4 -J 0.2 fg4uf2u4wk ../ereps/dreps/mlb 28

../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.7 -J 0.2 fg7uf2u0
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.7 -J 0.2 fg7uf2u1wk ../ereps/dreps/mlb 7
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.7 -J 0.2 fg7uf2u2wk ../ereps/dreps/mlb 14
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.7 -J 0.2 fg7uf2u3wk ../ereps/dreps/mlb 21
../../sf.opt ../dstarts.mlb ../drnums/nr-dreps.mlb -j 0.7 -J 0.2 fg7uf2u4wk ../ereps/dreps/mlb 28

for i in caps*; do ../../docranks.opt $i; done
for i in aranks*; do ../../save_rbucks.opt $i; done