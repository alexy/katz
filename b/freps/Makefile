BASES=`cat bases.list`

.PHONY: all denums vols b2br b2bm sbucks
  
all: denums vols b2br b2bm sbucks lblens rblens

denums:
	for i in $(BASES); do ../../save_days.opt dreps/dreps-$i.mlb; done
	mkdir -p denums
	mv denums-* denums

vols:
	for i in $(BASES); do ../../dovols2.opt denums/denums-dreps-$i.mlb rbucks/rbucks-aranks-caps-$i.mlb; done
	mkdir -p vols4
	mv vols4-* vols4

b2br:
	for i in $(BASES); do ../../dob2bs.opt dreps/dreps-$i.mlb rbucks/rbucks-aranks-caps-$i.mlb; done
	mkdir -p b2br
	mv b2br-* b2br

b2bm:
	for i in $(BASES); do ../../dob2bs.opt -i -k m dreps/dreps-$i.mlb rbucks/rbucks-aranks-caps-$i.mlb; done
	mkdir -p b2bm
	mv b2bm-* b2bm

sbucks:
	for i in $(BASES); do ../../dosranks.opt dreps/dreps-$i.mlb caps/caps-$i.mlb; done
	mkdir -p stars
	mv stars-* stars
	for i in $(BASES); do ../../dostarbucks.opt rbucks/rbucks-aranks-caps-$i.mlb stars/stars-dreps-$i.mlb; done
	mkdir sbucks-*
	mv sbucks-* sbucks

lblens:
	for i in $(BASES); do ../../save_caps.opt caps/caps-$i.mlb; done
	mkdir -p jcaps
	mv jcaps-* jcaps
	for i in $(BASES); do ../../docbucks.opt jcaps/jcaps-$i.mlb; done
	mkdir -p lbucks
	mv lb-* lbucks
	for i in $(BASES); do ../../dolblens.opt lbucks/lb-jcaps-$i.mlb; done
	mkdir -p lblens
	mv lelb-* lblens

# these can be saved right from save_rbucks, but we check afterwards:
rblens:
	for i in $(BASES); do ../../dorblens.opt rbucks/rbucks-aranks-caps-$i.mlb; done
	mkdir -p rblens
	mv rblens-* rblens