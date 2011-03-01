../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb rreps0d2wk ../ereps/ereps/dreps.mlb 14
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb rreps0d3wk ../ereps/ereps/dreps.mlb 21
../../sf.opt ../ereps/dstarts.mlb ../ereps/drnums/nr-dreps.mlb rreps0d4wk ../ereps/ereps/dreps.mlb 28

for i in caps-*; do ../../doaranks.opt $i; done
for i in aranks-*; do ../../save_rbucks.opt $i; done
