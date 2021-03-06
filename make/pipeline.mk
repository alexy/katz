include reps.mk

.PHONY: all denums vols b2br b2bm sbucks

MLBPACK=$(REPS)-mlb.tar.xz

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
CSTAU_DIR=cstau
BUCKET_SUFFIX=bs
CSTAUBS_DIR=$(CSTAU_DIR)$(BUCKET_SUFFIX)

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
  $(CSTAU_DIR)  \
  $(CSTAUBS_DIR)

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
DOSKA=$(CMD_DIR)/uberdoska.opt
DOSKABS=$(DOSKA) --buckets

CAPS_PREFIX=caps
ARANKS_PREFIX=aranks-$(CAPS_PREFIX)
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
JCAPS_PREFIX=jcaps
LBUCKS_PREFIX=lb-$(JCAPS_PREFIX)
LBLENS_PREFIX=le$(LBUCKS_PREFIX)
RBLENS_PREFIX=rblens-$(RBUCKS_PREFIX)
SKEW_PREFIX=skew
CSTAU_PREFIX_PROPER=cstau
CSTAU_PREFIX=$(CSTAU_PREFIX_PROPER)-$(SKEW_PREFIX)
CSTAUBS_PREFIX_PROPER=$(CSTAU_PREFIX_PROPER)$(BUCKET_SUFFIX)
CSTAUBS_PREFIX=$(CSTAUBS_PREFIX_PROPER)-$(SKEW_PREFIX)

DREPS= $(BASES:%=$(DREPS_DIR)/dreps-%.mlb)
CAPS_BASE=  $(BASES:%=$(CAPS_DIR)/$(CAPS_PREFIX)-%.mlb)
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
JCAPS= $(BASES:%=$(JCAPS_DIR)/$(JCAPS_PREFIX)-%.mlb)
LBUCKS=$(BASES:%=$(LBUCKS_DIR)/$(LBUCKS_PREFIX)-%.mlb)
LBLENS=$(BASES:%=$(LBLENS_DIR)/$(LBLENS_PREFIX)-%.mlb)
RBLENS=$(BASES:%=$(RBLENS_DIR)/$(RBLENS_PREFIX)-%.mlb)
OVERX_DREPS=$(BASES:%=$(OVERX_DREPS_DIR)/$(OVERX_DREPS_PREFIX)-%.mlb)

# assumes OROOTS are defined
# NB BASES can be defined in terms of OROOTS, with the caveat of 0 not available in buckets-specific simulations
# We could define the Os with foreach, with two substitutions instead of one, but cannot have a pattern rule with two stems,
# even when they are identical!  Renaming to one stem, also more compact
O01=$(foreach root, $(OROOTS), $(if $(wildcard $(DREPS_DIR)/dreps-$(root)0.mlb), $(OVERX_SELF_DIR)/overx-$(root)-01wk.mlb,))
O12=$(OROOTS:%=$(OVERX_SELF_DIR)/overx-%-12wk.mlb)
O23=$(OROOTS:%=$(OVERX_SELF_DIR)/overx-%-23wk.mlb)
O34=$(foreach root, $(OROOTS), $(if $(wildcard $(DREPS_DIR)/dreps-$(root)4wk.mlb), $(OVERX_SELF_DIR)/overx-$(root)-34wk.mlb,))
OVERX_SELF=$(O01) $(O12) $(O23) $(O34)

CSTAU=$(BASES:%=$(CSTAU_DIR)/$(CSTAU_PREFIX)-%.mlb)
CSTAUBS=$(BASES:%=$(CSTAUBS_DIR)/$(CSTAUBS_PREFIX)-%.mlb)

# took out $(RBUCKS) from ALL as they are now compressed, took out $(DREPS) as it's done by simulations preceding the pipeline
ALL= $(SRATES) $(OVERX_DREPS) $(OVERX_SELF) $(VOLS4) $(B2BR) $(B2BM) $(SBUCKS_REPS) $(SBUCKS_MENTS) \
     $(LBLENS) $(RBLENS) $(CSTAU) $(CSTAUBS)
  
.PHONY: all   
all: $(ALL)

# all1: denums1 vols1 b2br1 b2bm1 sbucks1 lblens1 rblens1 show

%.xz: %
	xz $^

XZABLE = $(CAPS) $(RBUCKS) $(SKEW)
XZED   = $(XZABLE:%=%.xz)

DREPS_XZ  =$(DREPS:%=%.xz)
RBUCKS_XZ =$(RBUCKS:%=%.xz)
CAPS_XZ   =$(CAPS:%=%.xz)

.PHONY: dreps_xz rbucks_xz caps_xz
dreps_xz:  $(DREPS_XZ)
rbucks_xz: $(RBUCKS_XZ)
caps_xz:   $(CAPS_XZ)

# denums1:
#   for i in $(BASES); do $(SAVE_DAYS) $(DREPS_DIR)/dreps-$$i.mlb; done

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

.SECONDARY:    $(CAPS) $(RBUCKS)
.INTERMEDIATE: $(ARANKS) $(DENUMS) $(STARS_REPS) $(STARS_MENTS)

# $(ARANKS_DIR)/$(ARANKS_PREFIX)-%.mlb: $(CAPS_DIR)/$(CAPS_PREFIX)-%.mlb
#   $(DOARANKS) $^ $(ARANKS_DIR)

$(ARANKS_DIR)/$(ARANKS_PREFIX)-%.mlb: $(CAPS_DIR)/$(CAPS_PREFIX)-%.mlb.xz
	$(DOARANKS) $^ $(ARANKS_DIR)

# ARANKS are intermediate, we don't compress them
$(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb: $(ARANKS_DIR)/$(ARANKS_PREFIX)-%.mlb
	$(SAVE_RBUCKS) $^ $(RBUCKS_DIR)

# $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb: $(ARANKS_DIR)/$(ARANKS_PREFIX)-%.mlb.xz
#   $(SAVE_RBUCKS) $^ $(RBUCKS_DIR)

.PHONY: rbucks
rbucks: $(RBUCKS)
  
# $(SRATES_DIR)/$(SRATES_PREFIX)-%.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb
#   $(DOSRATES) $^ $(SRATES_DIR)

$(SRATES_DIR)/$(SRATES_PREFIX)-%.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb.xz
	$(DOSRATES) $^ $(SRATES_DIR)

.PHONY: srates
srates: $(SRATES)

# $(OVERX_DREPS_DIR)/$(OVERX_DREPS_PREFIX)-%.mlb:  ../ereps/$(RBUCKS_DIR)/$(RBUCKS_PREFIX)-dreps.mlb    $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb
#   $(DOVERSETS) $^ dreps-$* $(OVERX_DREPS_SUFFIX)
# 
# $(OVERX_DREPS_DIR)/$(OVERX_DREPS_PREFIX)-%.mlb:  ../ereps/$(RBUCKS_DIR)/$(RBUCKS_PREFIX)-dreps.mlb.xz $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb
#   $(DOVERSETS) $^ dreps-$* $(OVERX_DREPS_SUFFIX)

$(OVERX_DREPS_DIR)/$(OVERX_DREPS_PREFIX)-%.mlb:  ../ereps/$(RBUCKS_DIR)/$(RBUCKS_PREFIX)-dreps.mlb.xz $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb.xz
	$(DOVERSETS) $^ dreps-$* $(OVERX_DREPS_SUFFIX)

.PHONY: overx_dreps
overx_dreps: $(OVERX_DREPS)

# $(shell ls $(DREPS_DIR)/dreps-%.mlb) could be used instead of wildcard, especially since there's no wild cards in it!

# $(OVERX_SELF_DIR)/overx-%-01wk.mlb:   $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%0.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%1wk.mlb
#   $(DOVERSETS) $^ $*-01wk $(OVERX_SELF_SUFFIX)
# 
# $(OVERX_SELF_DIR)/overx-%-12wk.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%1wk.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%2wk.mlb
#   $(DOVERSETS) $^ $*-12wk $(OVERX_SELF_SUFFIX)
# 
# $(OVERX_SELF_DIR)/overx-%-23wk.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%2wk.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%3wk.mlb
#   $(DOVERSETS) $^ $*-23wk $(OVERX_SELF_SUFFIX)
# 
# $(OVERX_SELF_DIR)/overx-%-34wk.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%3wk.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%4wk.mlb
#   $(DOVERSETS) $^ $*-34wk $(OVERX_SELF_SUFFIX)

$(OVERX_SELF_DIR)/overx-%-01wk.mlb:   $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%0.mlb.xz $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%1wk.mlb.xz
	$(DOVERSETS) $^ $*-01wk $(OVERX_SELF_SUFFIX)

$(OVERX_SELF_DIR)/overx-%-12wk.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%1wk.mlb.xz $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%2wk.mlb.xz
	$(DOVERSETS) $^ $*-12wk $(OVERX_SELF_SUFFIX)

$(OVERX_SELF_DIR)/overx-%-23wk.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%2wk.mlb.xz $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%3wk.mlb.xz
	$(DOVERSETS) $^ $*-23wk $(OVERX_SELF_SUFFIX)

$(OVERX_SELF_DIR)/overx-%-34wk.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%3wk.mlb.xz $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%4wk.mlb.xz
	$(DOVERSETS) $^ $*-34wk $(OVERX_SELF_SUFFIX)


.PHONY: overx_self
overx_self: $(OVERX_SELF)

# .SECONDARY: $(DENUMS)
# $(DENUMS_DIR)/$(DENUMS_PREFIX)-%.mlb: $(DREPS_DIR)/dreps-%.mlb
#   $(SAVE_DAYS) $^ $(DENUMS_DIR)

$(DENUMS_DIR)/$(DENUMS_PREFIX)-%.mlb: $(DREPS_DIR)/dreps-%.mlb.xz
	$(SAVE_DAYS) $^ $(DENUMS_DIR)

.PHONY: denums
denums: $(DENUMS)

# vols1:
#   for i in $(BASES); do $(DOVOLS2) $(DENUMS_DIR)/$(DENUMS_PREFIX)-$$i.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-$$i.mlb; done

# $(VOLS4_DIR)/vols4-$(RBUCKS_PREFIX)-%.mlb: $(DENUMS_DIR)/$(DENUMS_PREFIX)-%.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb
#   $(DOVOLS2) $^ $(VOLS4_DIR)

$(VOLS4_DIR)/vols4-$(RBUCKS_PREFIX)-%.mlb: $(DENUMS_DIR)/$(DENUMS_PREFIX)-%.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb.xz
	$(DOVOLS2) $^ $(VOLS4_DIR)

.PHONY: vols
vols: $(VOLS4)

# b2br1:
#   for i in $(BASES); do $(DOB2BS) $(DREPS_DIR)/dreps-$$i.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-$$i.mlb; done

# $(B2BR_DIR)/$(B2BR_PREFIX)-%.mlb: $(DREPS_DIR)/dreps-%.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb
#   $(DOB2BS) $^ $(B2BR_DIR)
# 
# $(B2BR_DIR)/$(B2BR_PREFIX)-%.mlb: $(DREPS_DIR)/dreps-%.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb.xz
#   $(DOB2BS) $^ $(B2BR_DIR)

$(B2BR_DIR)/$(B2BR_PREFIX)-%.mlb: $(DREPS_DIR)/dreps-%.mlb.xz $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb.xz
	$(DOB2BS) $^ $(B2BR_DIR)

.PHONY: b2br
b2br: $(B2BR)

# b2bm1:
#   for i in $(BASES); do $(DOB2BS) -i -k m $(DREPS_DIR)/dreps-$$i.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-$$i.mlb; done

# $(B2BM): $(B2BM_DIR)/$(B2BM_PREFIX)-%.mlb: $(DREPS_DIR)/dreps-%.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb
#   $(DOB2BS) -i -k m $^ $(B2BM_DIR)
# 
# $(B2BM): $(B2BM_DIR)/$(B2BM_PREFIX)-%.mlb: $(DREPS_DIR)/dreps-%.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb.xz
#   $(DOB2BS) -i -k m $^ $(B2BM_DIR)

$(B2BM): $(B2BM_DIR)/$(B2BM_PREFIX)-%.mlb: $(DREPS_DIR)/dreps-%.mlb.xz $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb.xz
	$(DOB2BS) -i -k m $^ $(B2BM_DIR)

.PHONY: b2bm
b2bm: $(B2BM)

# sbucks1:
#   for i in $(BASES); do $(DOSRANKS) $(DREPS_DIR)/dreps-$$i.mlb $(CAPS_DIR)/$(CAPS_PREFIX)-$$i.mlb; done
#   for i in $(BASES); do $(DOSTARBUCKS) $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-$$i.mlb $(STARS_DIR)/$(STARS_PREFIX)-$$i.mlb; done

# $(STARS_REPS_DIR)/$(STARS_REPS_PREFIX)-%.mlb: $(DREPS_DIR)/dreps-%.mlb $(CAPS_DIR)/$(CAPS_PREFIX)-%.mlb
#   $(DOSRANKS) $^ $(STARS_REPS_DIR)
# 
# $(STARS_REPS_DIR)/$(STARS_REPS_PREFIX)-%.mlb: $(DREPS_DIR)/dreps-%.mlb $(CAPS_DIR)/$(CAPS_PREFIX)-%.mlb.xz
#   $(DOSRANKS) $^ $(STARS_REPS_DIR)

$(STARS_REPS_DIR)/$(STARS_REPS_PREFIX)-%.mlb: $(DREPS_DIR)/dreps-%.mlb.xz $(CAPS_DIR)/$(CAPS_PREFIX)-%.mlb.xz
	$(DOSRANKS) $^ $(STARS_REPS_DIR)

# $(SBUCKS_REPS_DIR)/$(SBUCKS_REPS_PREFIX)-%.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb    $(STARS_REPS_DIR)/$(STARS_REPS_PREFIX)-%.mlb
#   $(DOSTARBUCKS) $^ $(SBUCKS_REPS_DIR)

$(SBUCKS_REPS_DIR)/$(SBUCKS_REPS_PREFIX)-%.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb.xz $(STARS_REPS_DIR)/$(STARS_REPS_PREFIX)-%.mlb
	$(DOSTARBUCKS) $^ $(SBUCKS_REPS_DIR)

# $(STARS_MENTS_DIR)/$(STARS_MENTS_PREFIX)-%.mlb: $(DREPS_DIR)/dreps-%.mlb $(CAPS_DIR)/$(CAPS_PREFIX)-%.mlb
#   $(DOSRANKS) -i $^ $(STARS_MENTS_DIR)
# 
# $(STARS_MENTS_DIR)/$(STARS_MENTS_PREFIX)-%.mlb: $(DREPS_DIR)/dreps-%.mlb $(CAPS_DIR)/$(CAPS_PREFIX)-%.mlb.xz
#   $(DOSRANKS) -i $^ $(STARS_MENTS_DIR)

$(STARS_MENTS_DIR)/$(STARS_MENTS_PREFIX)-%.mlb: $(DREPS_DIR)/dreps-%.mlb.xz $(CAPS_DIR)/$(CAPS_PREFIX)-%.mlb.xz
	$(DOSRANKS) -i $^ $(STARS_MENTS_DIR)

# $(SBUCKS_MENTS_DIR)/$(SBUCKS_MENTS_PREFIX)-%.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb    $(STARS_MENTS_DIR)/$(STARS_MENTS_PREFIX)-%.mlb
#   $(DOSTARBUCKS) $^ $(SBUCKS_MENTS_DIR)

$(SBUCKS_MENTS_DIR)/$(SBUCKS_MENTS_PREFIX)-%.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb.xz $(STARS_MENTS_DIR)/$(STARS_MENTS_PREFIX)-%.mlb
	$(DOSTARBUCKS) $^ $(SBUCKS_MENTS_DIR)

.PHONY: sbucks_reps sbucks_ments sbucks
sbucks_reps:  $(SBUCKS_REPS)
sbucks_ments: $(SBUCKS_MENTS)
sbucks:       sbucks_reps2 sbucks_ments2

# lblens1:
#   for i in $(BASES); do $(SAVE_CAPS) $(CAPS_DIR)/$(CAPS_PREFIX)-$$i.mlb; done
#   for i in $(BASES); do $(DOCBUCKS) $(JCAPS_DIR)/$(JCAPS_PREFIX)-$$i.mlb; done
#   for i in $(BASES); do $(DOLBLENS) $(LBUCKS_DIR)/$(LBUCKS_PREFIX)-$$i.mlb; done

.SECONDARY: $(JCAPS)
# $(JCAPS_DIR)/$(JCAPS_PREFIX)-%.mlb: $(CAPS_DIR)/$(CAPS_PREFIX)-%.mlb
#   $(SAVE_CAPS) $^ $(JCAPS_DIR)

$(JCAPS_DIR)/$(JCAPS_PREFIX)-%.mlb: $(CAPS_DIR)/$(CAPS_PREFIX)-%.mlb.xz
	$(SAVE_CAPS) $^ $(JCAPS_DIR)

.INTERMEDIATE: $(LBUCKS)
$(LBUCKS): $(LBUCKS_DIR)/$(LBUCKS_PREFIX)-%.mlb: $(JCAPS_DIR)/$(JCAPS_PREFIX)-%.mlb
	$(DOCBUCKS) $^ $(LBUCKS_DIR)

$(LBLENS): $(LBLENS_DIR)/$(LBLENS_PREFIX)-%.mlb: $(LBUCKS_DIR)/$(LBUCKS_PREFIX)-%.mlb
	$(DOLBLENS) $^ $(LBLENS_DIR)

.PHONY: lblens
lblens: $(LBLENS)

# these can be saved right from save_rbucks, but we like to recheck afterwards:
# rblens1:
#   for i in $(BASES); do $(DORBLENS) $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-$$i.mlb; done

# $(RBLENS_DIR)/$(RBLENS_PREFIX)-%.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb
#   $(DORBLENS) $^ $(RBLENS_DIR)

$(RBLENS_DIR)/$(RBLENS_PREFIX)-%.mlb: $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb.xz
	$(DORBLENS) $^ $(RBLENS_DIR)

# $(CSTAU_DIR)/$(CSTAU_PREFIX)-%.mlb: $(CAPS_DIR)/$(CAPS_PREFIX)-%.mlb $(SKEW_DIR)/$(SKEW_PREFIX)-%.mlb
#   $(DOSKA) $^ $(CSTAU_DIR)

$(CSTAU_DIR)/$(CSTAU_PREFIX)-%.mlb: $(CAPS_DIR)/$(CAPS_PREFIX)-%.mlb.xz $(SKEW_DIR)/$(SKEW_PREFIX)-%.mlb
	$(DOSKA) $^ $(CSTAU_DIR)

.PHONY: cstau
cstau: $(CSTAU)


$(CSTAUBS_DIR)/$(CSTAUBS_PREFIX)-%.mlb: $(CAPS_DIR)/$(CAPS_PREFIX)-%.mlb.xz $(SKEW_DIR)/$(SKEW_PREFIX)-%.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb.xz
	$(DOSKABS) $^ $(CSTAUBS_DIR)

# $(CSTAUBS_DIR)/$(CSTAUBS_PREFIX)-%.mlb: $(CAPS_DIR)/$(CAPS_PREFIX)-%.mlb $(SKEW_DIR)/$(SKEW_PREFIX)-%.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb.xz
#   $(DOSKABS) $^ $(CSTAUBS_DIR)

#$(CSTAUBS_DIR)/$(CSTAUBS_PREFIX)-%.mlb: $(CAPS_DIR)/$(CAPS_PREFIX)-%.mlb.xz $(SKEW_DIR)/$(SKEW_PREFIX)-%.mlb $(RBUCKS_DIR)/$(RBUCKS_PREFIX)-%.mlb
#	$(DOSKABS) $^ $(CSTAUBS_DIR)

.PHONY: cstaubs
cstaubs: $(CSTAUBS)

show:
	@echo CSTAUBS_DIR/CSTAUBS_PREFIX: $(CSTAUBS_DIR)/$(CSTAUBS_PREFIX)
	@echo CSTAUBS: $(CSTAUBS)

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


$(MLBPACK): $(ALL) $(JUMP_DIR) $(NORMS_DIR)
	tar Jcf $@ $^

pack: $(MLBPACK)