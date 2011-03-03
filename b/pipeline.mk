.PHONY: all denums vols b2br b2bm sbucks
  
all: denums vols b2br b2bm sbucks lblens rblens

denums:
	for i in $(BASES); do ../../save_days.opt dreps/dreps-$$i.mlb; done
	mkdir -p denums
	mv denums-* denums

vols:
	for i in $(BASES); do ../../dovols2.opt denums/denums-dreps-$$i.mlb rbucks/rbucks-aranks-caps-$$i.mlb; done
	mkdir -p vols4
	mv vols4-* vols4

b2br:
	for i in $(BASES); do ../../dob2bs.opt dreps/dreps-$$i.mlb rbucks/rbucks-aranks-caps-$$i.mlb; done
	mkdir -p b2br
	mv b2br-* b2br

b2bm:
	for i in $(BASES); do ../../dob2bs.opt -i -k m dreps/dreps-$$i.mlb rbucks/rbucks-aranks-caps-$$i.mlb; done
	mkdir -p b2bm
	mv b2bm-* b2bm

sbucks:
	for i in $(BASES); do ../../dosranks.opt dreps/dreps-$$i.mlb caps/caps-$$i.mlb; done
	mkdir -p stars
	mv stars-* stars
	for i in $(BASES); do ../../dostarbucks.opt rbucks/rbucks-aranks-caps-$$i.mlb stars/stars-dreps-$$i.mlb; done
	mkdir sbucks-*
	mv sbucks-* sbucks

lblens:
	for i in $(BASES); do ../../save_caps.opt caps/caps-$$i.mlb; done
	mkdir -p jcaps
	mv jcaps-* jcaps
	for i in $(BASES); do ../../docbucks.opt jcaps/jcaps-$$i.mlb; done
	mkdir -p lbucks
	mv lb-* lbucks
	for i in $(BASES); do ../../dolblens.opt lbucks/lb-jcaps-$$i.mlb; done
	mkdir -p lblens
	mv lelb-* lblens

# these can be saved right from save_rbucks, but we like to recheck afterwards:
rblens:
	for i in $(BASES); do ../../dorblens.opt rbucks/rbucks-aranks-caps-$$i.mlb; done
	mkdir -p rblens
	mv rblens-* rblens
	
order:
	mkdir -p dreps
	mv dreps-* dreps
	mkdir -p caps
	mv caps-* caps
	mkdir -p skew
	mv skew-* skew
	mkdir -p jump
	mv jump-* jump
	mkdir -p norms
	mv norms-* norms
	mkdir -p aranks
	mv aranks-* aranks
	mkdir -p rbucks
	mv rbucks-* rbucks
	mkdir -p denums
	mv denums-* denums
	mkdir -p vols4
	mv vols4-* vols4
	mkdir -p b2br
	mv b2br-* b2br
	mkdir -p b2bm
	mv b2bm-* b2bm
	mkdir -p stars
	mv stars-* stars
	mkdir -p sbucks
	mv sbucks-* sbucks
	mkdir -p jcaps
	mv jcaps-* jcaps
	mkdir -p lbucks
	mv lb-* lbucks
	mkdir -p lblens
	mv lelb-* lblens
	mkdir -p rblens
	mv rblens-* rblens
