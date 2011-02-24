../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -r 123     -j 0.5 -J 0.1 --glocap --fofcap fg5cf1cB0
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -r 45678   -j 0.5 -J 0.1 --glocap --fofcap fg5cf1cB1wk ../ereps/ereps/dreps.mlb 7
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -r 8764543 -j 0.5 -J 0.1 --glocap --fofcap fg5cf1cB2wk ../ereps/ereps/dreps.mlb 14
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -r 12365   -j 0.5 -J 0.1 --glocap --fofcap fg5cf1cB3wk ../ereps/ereps/dreps.mlb 21
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -r 12      -j 0.5 -J 0.1 --glocap --fofcap fg5cf1cB4wk ../ereps/ereps/dreps.mlb 28

../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glocap --fofcap fg5cf1cA0
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glocap --fofcap fg5cf1cA1wk ../ereps/ereps/dreps.mlb 7
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glocap --fofcap fg5cf1cA2wk ../ereps/ereps/dreps.mlb 14
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glocap --fofcap fg5cf1cA3wk ../ereps/ereps/dreps.mlb 21
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -j 0.5 -J 0.1 --glocap --fofcap fg5cf1cA4wk ../ereps/ereps/dreps.mlb 28

../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -r 9876897 -j 0.5 -J 0.1 --glocap --fofcap fg5cf1cC0
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -r 45      -j 0.5 -J 0.1 --glocap --fofcap fg5cf1cC1wk ../ereps/ereps/dreps.mlb 7
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -r 4543    -j 0.5 -J 0.1 --glocap --fofcap fg5cf1cC2wk ../ereps/ereps/dreps.mlb 14
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -r 23658   -j 0.5 -J 0.1 --glocap --fofcap fg5cf1cC3wk ../ereps/ereps/dreps.mlb 21
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb -r 1234567 -j 0.5 -J 0.1 --glocap --fofcap fg5cf1cC4wk ../ereps/ereps/dreps.mlb 28

for i in caps-*; do ../../doaranks.opt $i; done
for i in aranks-*; do ../../save_rbucks.opt $i; done

