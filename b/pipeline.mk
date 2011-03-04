.PHONY: all denums vols b2br b2bm sbucks

CMD_DIR=../..
DREPS_DIR=dreps
CAPS_DIR=caps
SKEW_DIR=skew
JUMP_DIR=jump
NORMS_DIR=norms
ARANKS_DIR=aranks
RBUCKS_DIR=rbucks
DENUMS_DIR=denums
VOLS4_DIR=vols4
B2BR_DIR=b2br
B2BM_DIR=b2bm
STARS_DIR=stars
SBUCKS_DIR=sbucks
JCAPS_DIR=jcaps
LBUCKS_DIR=lbucks
LBLENS_DIR=lblens
RBLENS_DIR=rblens

DIRS= \
  $(DREPS_DIR)  \
  $(CAPS_DIR)   \
  $(ARANKS_DIR) \
  $(RBUCKS_DIR) \
  $(DENUMS_DIR) \
  $(VOLS4_DIR)  \
  $(B2BR_DIR)   \
  $(B2BM_DIR)   \
  $(STARS_DIR)  \
  $(SBUCKS_DIR) \
  $(JCAPS_DIR)  \
  $(LBUCKS_DIR) \
  $(LBLENS_DIR) \
  $(RBLENS_DIR) \

SAVE_DAYS=$(CMD_DIR)/save_days.opt
DOVOLS2=$(CMD_DIR)/dovols2.opt
DOB2BS=$(CMD_DIR)/dob2bs.opt
DOSRANKS=$(CMD_DIR)/dosranks.opt
DOSTARBUCKS=$(CMD_DIR)/dostarbucks.opt
SAVE_CAPS=$(CMD_DIR)/save_caps.opt
DOCBUCKS=$(CMD_DIR)/docbucks.opt
DOLBLENS=$(CMD_DIR)/dolblens.opt
DORBLENS=$(CMD_DIR)/dorblens.opt

RBUCKS_PREFIX=rbucks-aranks-caps
DENUMS_PREFIX=denums-dreps
VOLS4_PREFIX=vols4-$(RBUCKS_PREFIX)
B2BR_PREFIX=b2br-$(RBUCKS_PREFIX)
B2BM_PREFIX=b2bm-$(RBUCKS_PREFIX)
STARS_PREFIX=stars-dreps
SBUCKS_PREFIX=sbucks-$(STARS_PREFIX)
LBUCKS_PREFIX=lb-jcaps
LBLENS_PREFIX=le$(LBUCKS_PREFIX)
RBLENS_PREFIX=rblens-$(RBUCKS_PREFIX)

DREPS= $(BASES:%=$(DREPS_DIR)/dreps-%.mlb)
RBUCKS=$(BASES:%=$(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb)
DENUMS=$(BASES:%=$(DENUMS_DIR)/$(DENUMS_PREFIX)-%.mlb)
VOLS4= $(BASES:%=$(VOLS4_DIR)/$(VOLS4_PREFIX)-%.mlb)
B2BR=  $(BASES:%=$(B2BR_DIR)/$(B2BR_PREFIX)-%.mlb)
B2BM=  $(BASES:%=$(B2BM_DIR)/$(B2BM_PREFIX)-%.mlb)
STARS= $(BASES:%=$(STARS_DIR)/$(STARS_PREFIX)-%.mlb)
SBUCKS=$(BASES:%=$(SBUCKS_DIR)/$(SBUCKS_PREFIX)-%.mlb)
JCAPS= $(BASES:%=$(JCAPS_DIR)/jcaps-%.mlb)
LBUCKS=$(BASES:%=$(LBUCKS_DIR)/$(LBUCKS_PREFIX)-%.mlb)
LBLENS=$(BASES:%=$(LBLENS_DIR)/$(LBLENS_PREFIX)-%.mlb)
RBLENS=$(BASES:%=$(RBLENS_DIR)/$(RBLENS_PREFIX)-%.mlb)

all:  $(DREPS) $(RBUCKS) $(DENUMS) $(VOLS4) $(B2BR) $(B2BM) $(STARS) $(SBUCKS) $(LBLENS) $(RBLENS)

all1: denums1 vols1 b2br1 b2bm1 sbucks1 lblens1 rblens1 show

show:
	@echo lblens: $(LBLENS)
	@echo lbucks: $(LBUCKS)
	@echo jcaps:  $(JCAPS)

denums1:
	for i in $(BASES); do $(SAVE_DAYS) $(DREPS_DIR)/dreps-$$i.mlb; done
	mkdir -p    $(DENUMS_DIR)
#	mv denums-* $(DENUMS_DIR)

$(DIRS):
	mkdir -p $@

$(DENUMS): $(DENUMS_DIR)
$(DENUMS): $(DENUMS_DIR)/$(DENUMS_PREFIX)-%.mlb: $(DREPS_DIR)/dreps-%.mlb
	mkdir -p $(DENUMS)
	$(SAVE_DAYS) $^

denums2: $(DENUMS)

vols1:
	for i in $(BASES); do $(DOVOLS2) $(DENUMS_DIR)/$(DENUMS_PREFIX)-$$i.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-$$i.mlb; done
	mkdir -p   $(VOLS4_DIR)
#	mv vols4-* $(VOLS4_DIR)

$(VOLS4): $(VOLS4_DIR)
$(VOLS4): $(VOLS4_DIR)/vols4-$(RBUCKS_PREFIX)-%.mlb: $(DENUMS_DIR)/$(DENUMS_PREFIX)-%i.mlb rbucks/$(RBUCKS_PREFIX)-%i.mlb
	$(DOVOLS2) $^

vols2: $(VOLS4)

b2br1:
	for i in $(BASES); do $(DOB2BS) $(DREPS_DIR)/dreps-$$i.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-$$i.mlb; done
	mkdir -p  $(B2BR_DIR)
#	mv b2br-* $(B2BR_DIR)

$(B2BR): $(B2BR_DIR)
$(B2BR): $(B2BR_DIR)/$(B2BR_PREFIX)-%.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb
	$(DOB2BS) $^

b2br2: $(B2BR)

b2bm1:
	for i in $(BASES); do $(DOB2BS) -i -k m $(DREPS_DIR)/dreps-$$i.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-$$i.mlb; done
	mkdir -p  $(B2BM_DIR)
#	mv b2bm-* $(B2BM_DIR)

$(B2BM): $(B2BM_DIR)
$(B2BM): $(B2BM_DIR)/$(B2BM_PREFIX)-%.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb
	$(DOB2BS) -i -k m $^

b2bm2: $(B2BM)

sbucks1:
	for i in $(BASES); do $(DOSRANKS) $(DREPS_DIR)/dreps-$$i.mlb $(CAPS_DIR)/caps-$$i.mlb; done
	mkdir -p    $(STARS_DIR)
#	mv stars-*  $(STARS_DIR)
	for i in $(BASES); do $(DOSTARBUCKS) $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-$$i.mlb $(STARS_DIR)/$(STARS_PREFIX)-$$i.mlb; done
	mkdir -p    $(SBUCKS_DIR)
#	mv sbucks-* $(SBUCKS_DIR)

$(STARS):  $(STARS_DIR)
$(STARS):  $(STARS_DIR)/$(STARS_PREFIX)-%.mlb $(DREPS_DIR)/dreps-%.mlb $(CAPS_DIR)/caps-%.mlb
	$(DOSRANKS) $^

$(SBUCKS): $(SBUCKS_DIR)
$(SBUCKS): $(SBUCKS_DIR)/$(SBUCKS_PREFIX)-%.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb $(STARS_DIR)/$(STARS_PREFIX)-%.mlb
	$(DOSTARBUCKS) $^

sbucks2: $(SBUCKS)

lblens1:
	for i in $(BASES); do $(SAVE_CAPS) $(CAPS_DIR)/caps-$$i.mlb; done
	mkdir -p   $(JCAPS_DIR)
#	mv jcaps-* $(JCAPS_DIR)
	for i in $(BASES); do $(DOCBUCKS) $(JCAPS_DIR)/jcaps-$$i.mlb; done
	mkdir -p   $(LBUCKS_DIR)
#	mv lb-*    $(LBUCKS_DIR) 
	for i in $(BASES); do $(DOLBLENS) $(LBUCKS_DIR)/$(LBUCKS_PREFIX)-$$i.mlb; done
	mkdir -p   $(LBLENS_DIR)
#	mv lelb-*  $(LBLENS_DIR)

$(JCAPS): $(JCAPS_DIR)
$(JCAPS): $(JCAPS_DIR)/jcaps-%.mlb: $(CAPS_DIR)/caps-%.mlb
	$(SAVE_CAPS) $^

$(LBUCKS): $(LBUCKS_DIR)
$(LBUCKS): $(LBUCKS_DIR)/$(LBUCKS_PREFIX)-%.mlb: $(JCAPS_DIR)/jcaps-%.mlb
	$(DOCBUCKS) $^

$(LBLENS): $(LBLENS_DIR)
$(LBLENS): $(LBLENS_DIR)/$(LBLENS_PREFIX)-%.mlb: $(LBUCKS_DIR)/$(LBUCKS_PREFIX)-%.mlb
	$(DOLBLENS) $^

lblens2: $(LBLENS)

# these can be saved right from save_rbucks, but we like to recheck afterwards:
rblens1:
	for i in $(BASES); do $(DORBLENS) $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-$$i.mlb; done
	mkdir -p    $(RBLENS_DIR)
	mv rblens-* $(RBLENS_DIR)

$(RBLENS): $(RBLENS_DIR)
$(RBLENS): $(RBLENS_DIR)/$(RBLENS_PREFIX)-%.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb
	$(DORBLENS) $^


order: $(DIRS)
	mv dreps-*  $(DREPS_DIR)
	mv caps-*   $(CAPS_DIR)
	mv skew-*   $(SKEW_DIR)
	mv jump-*   $(JUMP_DIR)
	mv norms-*  $(NORMS_DIR)
	mv aranks-* $(ARANKS_DIR)
	mv rbucks-* $(RBUCKS_DIR)
	mv denums-* $(DENUMS_DIR)
	mv vols4-*  $(VOLS4_DIR)
	mv b2br-*   $(B2BR_DIR)
	mv b2bm-*   $(B2BM_DIR)
	mv stars-*  $(STARS_DIR)
	mv sbucks-* $(SBUCKS_DIR)
	mv jcaps-*  $(JCAPS_DIR)
	mv lb-*     $(LBUCKS_DIR)
	mv lelb-*   $(LBLENS_DIR)
	mv rblens-* $(RBLENS_DIR)
