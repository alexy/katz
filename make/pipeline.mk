include reps.mk

.PHONY: all denums vols b2br b2bm sbucks

OVERX_DREPS_SUFFIX=dreps
OVERX_SELF_SUFFIX=self

CMD_DIR=../..
DREPS_DIR=dreps
CAPS_DIR=caps
SKEW_DIR=skew
JUMP_DIR=jump
NORMS_DIR=norms
ARANKS_DIR=aranks
RBUCKS_DIR=rbucks
SRATES_DIR=srates
DENUMS_DIR=denums
VOLS4_DIR=vols4
B2BR_DIR=b2br
B2BM_DIR=b2bm
STARS_REPS_DIR=  stars-reps
STARS_MENTS_DIR= stars-ments
SBUCKS_REPS_DIR= sbucks-reps
SBUCKS_MENTS_DIR=sbucks-ments
JCAPS_DIR=jcaps
LBUCKS_DIR=lbucks
LBLENS_DIR=lblens
RBLENS_DIR=rblens
OVERX_DREPS_DIR=overx-$(OVERX_DREPS_SUFFIX)
OVERX_SELF_DIR=overx-$(OVERX_SELF_SUFFIX)

DIRS= \
  $(DREPS_DIR)  \
  $(CAPS_DIR)   \
  $(ARANKS_DIR) \
  $(RBUCKS_DIR) \
  $(SRATES_DIR) \
  $(DENUMS_DIR) \
  $(VOLS4_DIR)  \
  $(B2BR_DIR)   \
  $(B2BM_DIR)   \
  $(STARS_REPS_DIR)  \
  $(STARS_MENTS_DIR)  \
  $(SBUCKS_REPS_DIR) \
  $(SBUCKS_MENTS_DIR) \
  $(JCAPS_DIR)  \
  $(LBUCKS_DIR) \
  $(LBLENS_DIR) \
  $(RBLENS_DIR) \

DOARANKS=$(CMD_DIR)/doaranks.opt
SAVE_RBUCKS=$(CMD_DIR)/save_rbucks.opt
DOSRATES=$(CMD_DIR)/dorates.opt
DOVERSETS=$(CMD_DIR)/doversets.opt
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
SRATES_PREFIX=srates-$(RBUCKS_PREFIX)
OVERX_DREPS_PREFIX=overx-dreps
DENUMS_PREFIX=denums-dreps
VOLS4_PREFIX=vols4-$(RBUCKS_PREFIX)
B2BR_PREFIX=b2br-$(RBUCKS_PREFIX)
B2BM_PREFIX=b2bm-$(RBUCKS_PREFIX)
STARS_REPS_PREFIX=stars-dreps
STARS_MENTS_PREFIX=stars-dments
SBUCKS_REPS_PREFIX=sbucks-$(STARS_REPS_PREFIX)
SBUCKS_MENTS_PREFIX=sbucks-$(STARS_MENTS_PREFIX)
LBUCKS_PREFIX=lb-jcaps
LBLENS_PREFIX=le$(LBUCKS_PREFIX)
RBLENS_PREFIX=rblens-$(RBUCKS_PREFIX)

DREPS= $(BASES:%=$(DREPS_DIR)/dreps-%.mlb)
CAPS_BASE=  $(BASES:%=$(CAPS_DIR)/caps-%.mlb)
CAPS     = $(foreach cap,$(CAPS_BASE),$(wildcard $(cap)*))
ARANKS=$(BASES:%=$(ARANKS_DIR)/$(ARANKS_PREFIX)-%.mlb)
RBUCKS=$(BASES:%=$(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb)
SRATES=$(BASES:%=$(SRATES_DIR)/$(SRATES_PREFIX)-%.mlb)
DENUMS=$(BASES:%=$(DENUMS_DIR)/$(DENUMS_PREFIX)-%.mlb)
VOLS4= $(BASES:%=$(VOLS4_DIR)/$(VOLS4_PREFIX)-%.mlb)
B2BR=  $(BASES:%=$(B2BR_DIR)/$(B2BR_PREFIX)-%.mlb)
B2BM=  $(BASES:%=$(B2BM_DIR)/$(B2BM_PREFIX)-%.mlb)
STARS_REPS=  $(BASES:%=$(STARS_REPS_DIR)/$(STARS_REPS_PREFIX)-%.mlb)
STARS_MENTS= $(BASES:%=$(STARS_MENTS_DIR)/$(STARS_MENTS_PREFIX)-%.mlb)
SBUCKS_REPS= $(BASES:%=$(SBUCKS_REPS_DIR)/$(SBUCKS_REPS_PREFIX)-%.mlb)
SBUCKS_MENTS=$(BASES:%=$(SBUCKS_MENTS_DIR)/$(SBUCKS_MENTS_PREFIX)-%.mlb)
JCAPS= $(BASES:%=$(JCAPS_DIR)/jcaps-%.mlb)
LBUCKS=$(BASES:%=$(LBUCKS_DIR)/$(LBUCKS_PREFIX)-%.mlb)
LBLENS=$(BASES:%=$(LBLENS_DIR)/$(LBLENS_PREFIX)-%.mlb)
RBLENS=$(BASES:%=$(RBLENS_DIR)/$(RBLENS_PREFIX)-%.mlb)
OVERX_DREPS=$(BASES:%=$(OVERX_DREPS_DIR)/$(OVERX_DREPS_PREFIX)-%.mlb)

# assumes OROOTS are defined
# NB BASES can be defined in terms of OROOTS, with the caveat of 0 not available in buckets-specific simulations

# We could define the Os with foreach, with two substitutions instead of one, but cannot have a pattern rule with two stems,
# even when they are identical!  Renaming to one stem, also more compact
O01=$(foreach $(root), $(OROOTS), $(if $(wildcard $(DREPS_DIR)/dreps-$(root)0.mlb), $(OVERX_SELF_DIR)/overx-$(root)-01wk.mlb))
O12=$(OROOTS:%=$(OVERX_SELF_DIR)/overx-%-12wk.mlb)
O23=$(OROOTS:%=$(OVERX_SELF_DIR)/overx-%-23wk.mlb)
O34=$(foreach $(root), $(OROOTS), $(if $(wildcard $(DREPS_DIR)/dreps-$(root)4wk.mlb), $(OVERX_SELF_DIR)/overx-$(root)-34wk.mlb))
OVERX_SELF=$(O01) $(O12) $(O23) $(O34)

# took out $(RBUCKS) from all as they are now compressed, took out $(DREPS) as it's done by simulations preceding the pipeline

ALL= $(SRATES) $(OVERX_DREPS) $(OVERX_SELF) $(VOLS4) $(B2BR) $(B2BM) $(SBUCKS_REPS) $(SBUCKS_MENTS) $(LBLENS) $(RBLENS)
all: $(ALL)

all1: denums1 vols1 b2br1 b2bm1 sbucks1 lblens1 rblens1 show

show:
	@echo caps: $(CAPS)

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

.SECONDARY: $(CAPS) $(ARANKS) $(RBUCKS) $(RBUCKS:%=%.xz )$(STARS_REPS) $(DENUMS) $(STARS_MENTS)

$(ARANKS_DIR)/$(ARANKS_PREFIX)-%.mlb: $(CAPS_DIR)/caps-%.mlb
	$(DOARANKS) $^ $(ARANKS_DIR)

$(ARANKS_DIR)/$(ARANKS_PREFIX)-%.mlb: $(CAPS_DIR)/caps-%.mlb.xz
	$(DOARANKS) $^ $(ARANKS_DIR)

$(RBUCKS): $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb: $(ARANKS_DIR)/$(ARANKS_PREFIX)-%.mlb
	$(SAVE_RBUCKS) $^ $(RBUCKS_DIR)
	
$(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb.xz: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb
	xz $^

rbucks2: $(RBUCKS)
  
$(SRATES_DIR)/$(SRATES_PREFIX)-%.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb
	$(DOSRATES) $^ $(SRATES_DIR)

$(SRATES_DIR)/$(SRATES_PREFIX)-%.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb.xz
	$(DOSRATES) $^ $(SRATES_DIR)

srates2: $(SRATES)

$(OVERX_DREPS_DIR)/$(OVERX_DREPS_PREFIX)-%.mlb:  ../ereps/$(RBUCKS_DIR)/$(RBUCKS_PREFIX)-dreps.mlb    $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb
	$(DOVERSETS) $^ dreps-$* $(OVERX_DREPS_SUFFIX)

$(OVERX_DREPS_DIR)/$(OVERX_DREPS_PREFIX)-%.mlb:  ../ereps/$(RBUCKS_DIR)/$(RBUCKS_PREFIX)-dreps.mlb.xz $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb
	$(DOVERSETS) $^ dreps-$* $(OVERX_DREPS_SUFFIX)

$(OVERX_DREPS_DIR)/$(OVERX_DREPS_PREFIX)-%.mlb:  ../ereps/$(RBUCKS_DIR)/$(RBUCKS_PREFIX)-dreps.mlb.xz $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb.xz
	$(DOVERSETS) $^ dreps-$* $(OVERX_DREPS_SUFFIX)

overx_dreps2: $(OVERX_DREPS)

# $(shell ls $(DREPS_DIR)/dreps-%.mlb) could be used instead of wildcard, especially since there's no wild cards in it!

$(OVERX_SELF_DIR)/overx-%-01wk.mlb:   $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%0.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%1wk.mlb
	$(DOVERSETS) $^ $*-01wk $(OVERX_SELF_SUFFIX)

$(OVERX_SELF_DIR)/overx-%-12wk.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%1wk.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%2wk.mlb
	$(DOVERSETS) $^ $*-12wk $(OVERX_SELF_SUFFIX)

$(OVERX_SELF_DIR)/overx-%-23wk.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%2wk.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%3wk.mlb
	$(DOVERSETS) $^ $*-23wk $(OVERX_SELF_SUFFIX)

$(OVERX_SELF_DIR)/overx-%-34wk.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%3wk.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%4wk.mlb
	$(DOVERSETS) $^ $*-34wk $(OVERX_SELF_SUFFIX)

$(OVERX_SELF_DIR)/overx-%-01wk.mlb:   $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%0.mlb.xz $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%1wk.mlb.xz
	$(DOVERSETS) $^ $*-01wk $(OVERX_SELF_SUFFIX)

$(OVERX_SELF_DIR)/overx-%-12wk.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%1wk.mlb.xz $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%2wk.mlb.xz
	$(DOVERSETS) $^ $*-12wk $(OVERX_SELF_SUFFIX)

$(OVERX_SELF_DIR)/overx-%-23wk.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%2wk.mlb.xz $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%3wk.mlb.xz
	$(DOVERSETS) $^ $*-23wk $(OVERX_SELF_SUFFIX)

$(OVERX_SELF_DIR)/overx-%-34wk.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%3wk.mlb.xz $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%4wk.mlb.xz
	$(DOVERSETS) $^ $*-34wk $(OVERX_SELF_SUFFIX)

overx_self2: $(OVERX_SELF)

# .SECONDARY: $(DENUMS)
$(DENUMS): $(DENUMS_DIR)/$(DENUMS_PREFIX)-%.mlb: $(DREPS_DIR)/dreps-%.mlb
	$(SAVE_DAYS) $^ $(DENUMS_DIR)

denums2: $(DENUMS)

vols1:
	for i in $(BASES); do $(DOVOLS2) $(DENUMS_DIR)/$(DENUMS_PREFIX)-$$i.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-$$i.mlb; done

$(VOLS4_DIR)/vols4-$(RBUCKS_PREFIX)-%.mlb: $(DENUMS_DIR)/$(DENUMS_PREFIX)-%.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb
	$(DOVOLS2) $^ $(VOLS4_DIR)

$(VOLS4_DIR)/vols4-$(RBUCKS_PREFIX)-%.mlb: $(DENUMS_DIR)/$(DENUMS_PREFIX)-%.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb.xz
	$(DOVOLS2) $^ $(VOLS4_DIR)

vols2: $(VOLS4)

b2br1:
	for i in $(BASES); do $(DOB2BS) $(DREPS_DIR)/dreps-$$i.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-$$i.mlb; done

$(B2BR_DIR)/$(B2BR_PREFIX)-%.mlb: $(DREPS_DIR)/dreps-%.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb
	$(DOB2BS) $^ $(B2BR_DIR)

$(B2BR_DIR)/$(B2BR_PREFIX)-%.mlb: $(DREPS_DIR)/dreps-%.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb
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
# .SECONDARY: $(STARS_REPS) $(STARS_REPS:%=%.xz)
$(STARS_REPS_DIR)/$(STARS_REPS_PREFIX)-%.mlb: $(DREPS_DIR)/dreps-%.mlb $(CAPS_DIR)/caps-%.mlb
	$(DOSRANKS) $^ $(STARS_REPS_DIR)

$(STARS_REPS_DIR)/$(STARS_REPS_PREFIX)-%.mlb: $(DREPS_DIR)/dreps-%.mlb $(CAPS_DIR)/caps-%.mlb.xz
	$(DOSRANKS) $^ $(STARS_REPS_DIR)

$(SBUCKS_REPS_DIR)/$(SBUCKS_REPS_PREFIX)-%.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb    $(STARS_REPS_DIR)/$(STARS_REPS_PREFIX)-%.mlb
	$(DOSTARBUCKS) $^ $(SBUCKS_REPS_DIR)

$(SBUCKS_REPS_DIR)/$(SBUCKS_REPS_PREFIX)-%.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb.xz $(STARS_REPS_DIR)/$(STARS_REPS_PREFIX)-%.mlb.xz
	$(DOSTARBUCKS) $^ $(SBUCKS_REPS_DIR)

# .SECONDARY: $(STARS_MENTS) $(STARS_MENTS:%=%.xz)
$(STARS_MENTS_DIR)/$(STARS_MENTS_PREFIX)-%.mlb: $(DREPS_DIR)/dreps-%.mlb $(CAPS_DIR)/caps-%.mlb
	$(DOSRANKS) -i $^ $(STARS_MENTS_DIR)

$(STARS_MENTS_DIR)/$(STARS_MENTS_PREFIX)-%.mlb: $(DREPS_DIR)/dreps-%.mlb $(CAPS_DIR)/caps-%.mlb.xz
	$(DOSRANKS) -i $^ $(STARS_MENTS_DIR)

$(SBUCKS_MENTS_DIR)/$(SBUCKS_MENTS_PREFIX)-%.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb    $(STARS_MENTS_DIR)/$(STARS_MENTS_PREFIX)-%.mlb
	$(DOSTARBUCKS) $^ $(SBUCKS_MENTS_DIR)

$(SBUCKS_MENTS_DIR)/$(SBUCKS_MENTS_PREFIX)-%.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb.xz $(STARS_MENTS_DIR)/$(STARS_MENTS_PREFIX)-%.mlb
	$(DOSTARBUCKS) $^ $(SBUCKS_MENTS_DIR)

sbucks_reps2:  $(SBUCKS_REPS)
sbucks_ments2: $(SBUCKS_MENTS)
sbucks2: sbucks_reps2 sbucks_ments2

lblens1:
	for i in $(BASES); do $(SAVE_CAPS) $(CAPS_DIR)/caps-$$i.mlb; done
	for i in $(BASES); do $(DOCBUCKS) $(JCAPS_DIR)/jcaps-$$i.mlb; done
	for i in $(BASES); do $(DOLBLENS) $(LBUCKS_DIR)/$(LBUCKS_PREFIX)-$$i.mlb; done

.INTERMEDIATE: $(JCAPS)
$(JCAPS_DIR)/jcaps-%.mlb: $(CAPS_DIR)/caps-%.mlb
	$(SAVE_CAPS) $^ $(JCAPS_DIR)

$(JCAPS_DIR)/jcaps-%.mlb: $(CAPS_DIR)/caps-%.mlb.xz
	$(SAVE_CAPS) $^ $(JCAPS_DIR)

.INTERMEDIATE: $(LBUCKS)
$(LBUCKS): $(LBUCKS_DIR)/$(LBUCKS_PREFIX)-%.mlb: $(JCAPS_DIR)/jcaps-%.mlb
	$(DOCBUCKS) $^ $(LBUCKS_DIR)

$(LBLENS): $(LBLENS_DIR)/$(LBLENS_PREFIX)-%.mlb: $(LBUCKS_DIR)/$(LBUCKS_PREFIX)-%.mlb
	$(DOLBLENS) $^ $(LBLENS_DIR)

lblens2: $(LBLENS)

# these can be saved right from save_rbucks, but we like to recheck afterwards:
rblens1:
	for i in $(BASES); do $(DORBLENS) $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-$$i.mlb; done

$(RBLENS_DIR)/$(RBLENS_PREFIX)-%.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb
	$(DORBLENS) $^ $(RBLENS_DIR)

$(RBLENS_DIR)/$(RBLENS_PREFIX)-%.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb.xz
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
	
	
$(MLBPACK): $(ALL)
	tar Jcf $(REPS)-mlb.tar.xz $^

pack: $(MLBPACK)