ROOTS=ereps lreps freps ureps-deux freps-deux
SRATES=${ROOTS:%=%/srates}
OVERX_DREPS=${ROOTS:%=%/overx-dreps}
OVERX_SELF=${ROOTS:%=%/overx-self}
OVERX=$(OVERX_DREPS) $(OVERX_SELF)

RDIR = r
REPS=ereps lreps freps


ODREPS_NAME=overx-dreps
ODREPS_NAME_1=$(ODREPS_NAME)-medians
ODREPS_LIST=$(foreach reps,$(REPS),$(reps)/overx-dreps/txt/$(reps)-$(ODREPS_NAME_1).txt)
ODREPS=$(RDIR)/$(ODREPS_NAME_1).txt

SBUCKS_KIND_1=sbucks-ments
SBUCKS_NAME_1=$(SBUCKS_KIND_1)-star-med-medians
SBUCKS_LIST_1=$(foreach reps,$(REPS),$(reps)/$(SBUCKS_KIND_1)/txt/$(reps)-$(SBUCKS_NAME_1).txt)
SBUCKS_1=$(RDIR)/$(SBUCKS_NAME_1).txt

SBUCKS_KIND_2=sbucks-reps
SBUCKS_NAME_2=$(SBUCKS_KIND_2)-star-med-medians
SBUCKS_LIST_2=$(foreach reps,$(REPS),$(reps)/$(SBUCKS_KIND_2)/txt/$(reps)-$(SBUCKS_NAME_2).txt)
SBUCKS_2=$(RDIR)/$(SBUCKS_NAME_2).txt


VOLS_KIND_1=re-norm-medians
VOLS_LIST_1=$(foreach reps,$(REPS),$(reps)/vols4/txt/$(reps)-$(VOLS_KIND_1).txt)
VOLS_1=$(RDIR)/vols4-$(VOLS_KIND_1).txt

ALL=$(SRATES) $(OVERX)

.PHONY: all $(ALL)

all: $(ALL)
    
$(ALL):
	$(MAKE) --directory=$@ $(TARGET)

show:
	@echo $(ALL)
	
$(ODREPS): $(ODREPS_LIST)
	cat $^ > $@
	
$(SBUCKS_1): $(SBUCKS_LIST_1)
	cat $^ > $@

$(SBUCKS_2): $(SBUCKS_LIST_2)
	cat $^ > $@
		
$(VOLS_1): $(VOLS_LIST_1)
	cat $^ > $@
	
odreps:  $(ODREPS)	
sbucks1: $(SBUCKS_1)
sbucks2: $(SBUCKS_2)
vols1:   $(VOLS_1)

cp:
	cp -p t.pdf ~/Dropbox/Public/Thesis/khrabrov-mindeconomy-thesis.pdf