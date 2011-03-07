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
OVERX_DREPS_DIR=overx
OVERX_SELF_DIR=$(OVERX_DREPS_DIR)

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

DOARANKS=$(CMD_DIR)/doaranks.opt
SAVE_RBUCKS=$(CMD_DIR)/save_rbucks.opt
SAVE_DAYS=$(CMD_DIR)/save_days.opt
DOVOLS2=$(CMD_DIR)/dovols2.opt
DOB2BS=$(CMD_DIR)/dob2bs.opt
DOSRANKS=$(CMD_DIR)/dosranks.opt
DOSTARBUCKS=$(CMD_DIR)/dostarbucks.opt
SAVE_CAPS=$(CMD_DIR)/save_caps.opt
DOCBUCKS=$(CMD_DIR)/docbucks.opt
DOLBLENS=$(CMD_DIR)/dolblens.opt
DORBLENS=$(CMD_DIR)/dorblens.opt

ARANKS_PREFIX=aranks-caps
RBUCKS_PREFIX=rbucks-$(ARANKS_PREFIX)
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
ARANKS=$(BASES:%=$(ARANKS_DIR)/$(ARANKS_PREFIX)-%.mlb)
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
OVERX_DREPS=$(BASES:%=$(OVERX_DREPS_DIR)/$(OVERX_DREPS_PREFIX)-%.mlb)

# assumes OROOTS are defined
# NB BASES can be defined in terms of OROOTS, with the caveat of 0 not available in buckets-specific simulations

O01=$(OROOTS:%=$(if $(wildcard $(DREPS_DIR)/dreps-%.mlb),$(OVERX_SELF_DIR)/overx-%0-%1wk.mlb))
O12=$(OROOTS:%=$(OVERX_SELF_DIR)/overx-%1wk-%2wk.mlb)
O23=$(OROOTS:%=$(OVERX_SELF_DIR)/overx-%2wk-%3wk.mlb)
O34=$(OROOTS:%=$(OVERX_SELF_DIR)/overx-%3wk-%4wk.mlb)
OVERX_SELF=$(O01) $(O12) $(O23) $(O34)

all:  $(DREPS) $(RBUCKS) $(OVERX_DREPS) $(OVERX_SELF) $(VOLS4) $(B2BR) $(B2BM) $(SBUCKS) $(LBLENS) $(RBLENS)

all1: denums1 vols1 b2br1 b2bm1 sbucks1 lblens1 rblens1 show

show:
	@echo overx_self: $(OVERX_SELF)

denums1:
	for i in $(BASES); do $(SAVE_DAYS) $(DREPS_DIR)/dreps-$$i.mlb; done

$(DIRS):
	mkdir -p $@

# we originally had the target dir as a dependency, like
# $(DENUMS): $(DENUMS_DIR)
# -- it was auto-created using the $(DIRS): rule above, 
# and added as the trailing target to the command, which 
# we used as an explicit outdir argument.  However, 
# directory time always changes when used, so it caused
# unnecessary remakes, and we moved mkdir -p into OCaml,
# but reting the explicit trailing outdir here for visual confirmation.
# The drivers are smart enough to use the default which must coincide,
# but since we parameterize all _DIRs here anyways, 
# might as well apply them explicitly for guaranteed consistency

#for i in caps-*; do ../../doaranks.opt $i; done
#for i in aranks-*; do ../../save_rbucks.opt $i; done

.INTERMEDIATE: $(ARANKS)
$(ARANKS): $(ARANKS_DIR)/$(ARANKS_PREFIX)-%.mlb: $(CAPS_DIR)/caps-%.mlb
	$(DOARANKS) $^ $(ARANKS_DIR)

$(RBUCKS): $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb: $(ARANKS_DIR)/$(ARANKS_PREFIX)-%.mlb
	$(SAVE_RBUCKS) $^ $(RBUCKS_DIR)

rbucks2: $(RBUCKS)
  
$(OVERX_DREPS): $(OVERX_DREPS_DIR)/$(OVERX_DREPS_PREFIX)-%.mlb:  $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-dreps.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb
	$(DOVERSETS) $^ dreps-$* $(OVERX_DREPS_DIR)

overx_dreps2: $(OVERX_DREPS)

# $(shell ls $(DREPS_DIR)/dreps-%.mlb) could be used instead of wildcard, especially since there's no wild cards in it!

$(O01): $(OVERX_SELF_DIR)/overx-%\0-%\1wk.mlb:   $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%\0.mlb   $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%\1wk.mlb
	$(DOVERSETS) $^ $*0-$*1wk $(OVERX_SELF_DIR)

$(O12): $(OVERX_SELF_DIR)/overx-%\1wk-%\2wk.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%\1wk.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%\2wk.mlb
	$(DOVERSETS) $^ $*1wk-$*2wk $(OVERX_SELF_DIR)

$(O23): $(OVERX_SELF_DIR)/overx-%\2wk-%\3wk.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%\2wk.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%\3wk.mlb
	$(DOVERSETS) $^ $*2wk-$*3wk $(OVERX_SELF_DIR)

$(O34): $(OVERX_SELF_DIR)/overx-%\3wk-%\4wk.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%\3wk.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%\4wk.mlb
	$(DOVERSETS) $^ $*3wk-$*4wk $(OVERX_SELF_DIR)

overx_self2: $(OVERX_SELF)

.INTERMEDIATE: $(DENUMS)
$(DENUMS): $(DENUMS_DIR)/$(DENUMS_PREFIX)-%.mlb: $(DREPS_DIR)/dreps-%.mlb
	$(SAVE_DAYS) $^ $(DENUMS_DIR)

denums2: $(DENUMS)

vols1:
	for i in $(BASES); do $(DOVOLS2) $(DENUMS_DIR)/$(DENUMS_PREFIX)-$$i.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-$$i.mlb; done

$(VOLS4): $(VOLS4_DIR)/vols4-$(RBUCKS_PREFIX)-%.mlb: $(DENUMS_DIR)/$(DENUMS_PREFIX)-%.mlb rbucks/$(RBUCKS_PREFIX)-%.mlb
	$(DOVOLS2) $^ $(VOLS4_DIR)

vols2: $(VOLS4)

b2br1:
	for i in $(BASES); do $(DOB2BS) $(DREPS_DIR)/dreps-$$i.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-$$i.mlb; done

$(B2BR): $(B2BR_DIR)/$(B2BR_PREFIX)-%.mlb: $(DREPS_DIR)/dreps-%.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb
	$(DOB2BS) $^ $(B2BR_DIR)

b2br2: $(B2BR)

b2bm1:
	for i in $(BASES); do $(DOB2BS) -i -k m $(DREPS_DIR)/dreps-$$i.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-$$i.mlb; done

$(B2BM): $(B2BM_DIR)/$(B2BM_PREFIX)-%.mlb: $(DREPS_DIR)/dreps-%.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb
	$(DOB2BS) -i -k m $^ $(B2BM_DIR)

b2bm2: $(B2BM)

sbucks1:
	for i in $(BASES); do $(DOSRANKS) $(DREPS_DIR)/dreps-$$i.mlb $(CAPS_DIR)/caps-$$i.mlb; done
	for i in $(BASES); do $(DOSTARBUCKS) $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-$$i.mlb $(STARS_DIR)/$(STARS_PREFIX)-$$i.mlb; done

# .INTERMEDIATE can be used instead of .SECONDARY to rm those when done
.INTERMEDIATE: $(STARS)
$(STARS):  $(STARS_DIR)/$(STARS_PREFIX)-%.mlb: $(DREPS_DIR)/dreps-%.mlb $(CAPS_DIR)/caps-%.mlb
	$(DOSRANKS) $^ $(STARS_DIR)

$(SBUCKS): $(SBUCKS_DIR)/$(SBUCKS_PREFIX)-%.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb $(STARS_DIR)/$(STARS_PREFIX)-%.mlb
	$(DOSTARBUCKS) $^ $(SBUCKS_DIR)

sbucks2: $(SBUCKS)

lblens1:
	for i in $(BASES); do $(SAVE_CAPS) $(CAPS_DIR)/caps-$$i.mlb; done
	for i in $(BASES); do $(DOCBUCKS) $(JCAPS_DIR)/jcaps-$$i.mlb; done
	for i in $(BASES); do $(DOLBLENS) $(LBUCKS_DIR)/$(LBUCKS_PREFIX)-$$i.mlb; done

.INTERMEDIATE: $(JCAPS)
$(JCAPS): $(JCAPS_DIR)/jcaps-%.mlb: $(CAPS_DIR)/caps-%.mlb
	$(SAVE_CAPS) $^ $(JCAPS_DIR)

.SECONDARY: $(LBUCKS)
$(LBUCKS): $(LBUCKS_DIR)/$(LBUCKS_PREFIX)-%.mlb: $(JCAPS_DIR)/jcaps-%.mlb
	$(DOCBUCKS) $^ $(LBUCKS_DIR)

$(LBLENS): $(LBLENS_DIR)/$(LBLENS_PREFIX)-%.mlb: $(LBUCKS_DIR)/$(LBUCKS_PREFIX)-%.mlb
	$(DOLBLENS) $^ $(LBLENS_DIR)

lblens2: $(LBLENS)

# these can be saved right from save_rbucks, but we like to recheck afterwards:
rblens1:
	for i in $(BASES); do $(DORBLENS) $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-$$i.mlb; done

$(RBLENS): $(RBLENS_DIR)/$(RBLENS_PREFIX)-%.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb
	$(DORBLENS) $^ $(RBLENS_DIR)


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
