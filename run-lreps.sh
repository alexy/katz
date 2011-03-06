#../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glocap --fofcap --buckets=6 fg5cf1cb6f1wk ../ereps/ereps/dreps.mlb 7
 ../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glocap --fofcap --buckets=6 --keepbuckets fg5cf1cb6t1wk ../ereps/ereps/dreps.mlb 7
 ../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glocap --fofcap --buckets=6 fg5cf1cb6f1wk ../ereps/ereps/dreps.mlb 14
 ../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glocap --fofcap --buckets=6 fg5cf1cb6f1wk ../ereps/ereps/dreps.mlb 21
 ../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glocap --fofcap --buckets=6 fg5cf1cb6f1wk ../ereps/ereps/dreps.mlb 28

../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glocap --fofcap lj2c1wk ../ereps/ereps/dreps.mlb 7
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glocap --fofcap lj2c2wk ../ereps/ereps/dreps.mlb 14
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glocap --fofcap lj2c3wk ../ereps/ereps/dreps.mlb 21
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glocap --fofcap lj2c4wk ../ereps/ereps/dreps.mlb 28

../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glocap --fofcap lj5c1wk ../ereps/ereps/dreps.mlb 7
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glocap --fofcap lj5c2wk ../ereps/ereps/dreps.mlb 14
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glocap --fofcap lj5c3wk ../ereps/ereps/dreps.mlb 21
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glocap --fofcap lj5c4wk ../ereps/ereps/dreps.mlb 28

for i in caps-*; do ../../doaranks.opt $i; done
for i in aranks-*; do ../../save_rbucks.opt $i; done
