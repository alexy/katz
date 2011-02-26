for i in urepsB{1,2,3,4}wk; do ../../sk.opt $i.mlb; done

for i in caps-urepsB*; do ../../doaranks.opt $i; done
for i in aranks-*; do ../../save_rbucks.opt $i; done

for i in urepsB{0,{1,2,3,4}wk}; do ../../doversets.opt rbucks/rbucks-aranks-caps-dreps.mlb rbucks-aranks-caps-$i.mlb dreps-$i; done

for i j in ureps0 urepsB0 ureps1wk urepsB1wk ureps2wk urepsB2wk ureps3wk urepsB3wk ureps4wk urepsB4wk; do ../../doversets.opt rbucks-aranks-caps-$i.mlb rbucks-aranks-caps-$j.mlb $i-$j; done 
for i j in urepsB0 urepsC0 urepsB1wk urepsC1wk urepsB2wk urepsC2wk urepsB3wk urepsC3wk urepsB4wk urepsC4wk; do ../../doversets.opt rbucks-aranks-caps-$i.mlb rbucks-aranks-caps-$j.mlb $i-$j; done 