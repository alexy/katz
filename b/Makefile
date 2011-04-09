REPS=ereps lreps freps
RDIR=r

SRATES_NAME=srates
SRATES_NAME_1=$(SRATES_NAME)-medians
SRATES_LIST=$(foreach reps,$(REPS),$(reps)/$(SRATES_NAME)/txt/$(reps)-$(SRATES_NAME_1).txt)
SRATES=$(RDIR)/$(SRATES_NAME_1).txt

ODREPS_NAME=overx-dreps
ODREPS_NAME_1=$(ODREPS_NAME)-medians
ODREPS_LIST=$(foreach reps,$(REPS),$(reps)/$(ODREPS_NAME)/txt/$(reps)-$(ODREPS_NAME_1).txt)
ODREPS=$(RDIR)/$(ODREPS_NAME_1).txt

OSELF_NAME=overx-self
OSELF_MEASURE=medians
OSELF_NAME_1=$(OSELF_NAME)-$(OSELF_MEASURE)
OSELF_BASE_1=overx-$(OSELF_MEASURE)
OSELF_LIST=$(foreach reps,$(REPS),$(reps)/$(OSELF_NAME)/txt/$(reps)-$(OSELF_BASE_1).txt)
OSELF=$(RDIR)/$(OSELF_NAME_1).txt

SBUCKS_KIND_1=sbucks-ments
SBUCKS_NAME_1=$(SBUCKS_KIND_1)-star-med-medians
SBUCKS_LIST_1=$(foreach reps,$(REPS),$(reps)/$(SBUCKS_KIND_1)/txt/$(reps)-$(SBUCKS_NAME_1).txt)
SBUCKS_1=$(RDIR)/$(SBUCKS_NAME_1).txt

SBUCKS_KIND_2=sbucks-reps
SBUCKS_NAME_2=$(SBUCKS_KIND_2)-star-med-medians
SBUCKS_LIST_2=$(foreach reps,$(REPS),$(reps)/$(SBUCKS_KIND_2)/txt/$(reps)-$(SBUCKS_NAME_2).txt)
SBUCKS_2=$(RDIR)/$(SBUCKS_NAME_2).txt
SBUCKS=$(SBUCKS_1) $(SBUCKS_2)

VOLS_KIND_1=re-norm-medians
VOLS_LIST_1=$(foreach reps,$(REPS),$(reps)/vols4/txt/$(reps)-$(VOLS_KIND_1).txt)
VOLS_1=$(RDIR)/vols4-$(VOLS_KIND_1).txt
VOLS_KIND_2=me-norm-medians
VOLS_LIST_2=$(foreach reps,$(REPS),$(reps)/vols4/txt/$(reps)-$(VOLS_KIND_2).txt)
VOLS_2=$(RDIR)/vols4-$(VOLS_KIND_2).txt
VOLS=$(VOLS_1) $(VOLS_2)

CSTAUBS_NAME=cstaubs
CSTAUBS_NAME_1=$(CSTAUBS_NAME)-medians
CSTAUBS_LIST=$(foreach reps,$(REPS),$(reps)/$(CSTAUBS_NAME)/txt/$(reps)-$(CSTAUBS_NAME_1).txt)
CSTAUBS=$(RDIR)/$(CSTAUBS_NAME_1).txt

B2B_KIND_1=b2br
B2B_MEASURES=medians
B2B_NAME_1=$(B2B_KIND_1)-befr-rel-$(B2B_MEASURES)
B2B_LIST_1=$(foreach reps,$(REPS),$(reps)/$(B2B_KIND_1)/txt/$(reps)-$(B2B_NAME_1).txt)
B2B_1=$(RDIR)/$(B2B_NAME_1).txt

B2B_KIND_2=b2br
B2B_NAME_2=$(B2B_KIND_2)-aftr-rel-$(B2B_MEASURES)
B2B_LIST_2=$(foreach reps,$(REPS),$(reps)/$(B2B_KIND_2)/txt/$(reps)-$(B2B_NAME_2).txt)
B2B_2=$(RDIR)/$(B2B_NAME_2).txt

B2B_KIND_3=b2br
B2B_NAME_3=$(B2B_KIND_3)-self-rel-$(B2B_MEASURES)
B2B_LIST_3=$(foreach reps,$(REPS),$(reps)/$(B2B_KIND_3)/txt/$(reps)-$(B2B_NAME_3).txt)
B2B_3=$(RDIR)/$(B2B_NAME_3).txt

B2B_KIND_4=b2bm
B2B_NAME_4=$(B2B_KIND_4)-befr-rel-$(B2B_MEASURES)
B2B_LIST_4=$(foreach reps,$(REPS),$(reps)/$(B2B_KIND_4)/txt/$(reps)-$(B2B_NAME_4).txt)
B2B_4=$(RDIR)/$(B2B_NAME_4).txt

B2B_KIND_5=b2bm
B2B_NAME_5=$(B2B_KIND_5)-aftr-rel-$(B2B_MEASURES)
B2B_LIST_5=$(foreach reps,$(REPS),$(reps)/$(B2B_KIND_5)/txt/$(reps)-$(B2B_NAME_5).txt)
B2B_5=$(RDIR)/$(B2B_NAME_5).txt

B2B_KIND_6=b2bm
B2B_NAME_6=$(B2B_KIND_6)-self-rel-$(B2B_MEASURES)
B2B_LIST_6=$(foreach reps,$(REPS),$(reps)/$(B2B_KIND_6)/txt/$(reps)-$(B2B_NAME_6).txt)
B2B_6=$(RDIR)/$(B2B_NAME_6).txt

B2B=$(B2B_1) $(B2B_2) $(B2B_3) $(B2B_4) $(B2B_5) $(B2B_6)

CSTAU_NAME=cstau
CSTAU_TXT=txt
CSTAU_LIST=$(foreach root,$(REPS),$(root)/$(CSTAU_NAME)/$(CSTAU_TXT)/$(root)-$(CSTAU_NAME).txt)
CSTAU=$(RDIR)/$(CSTAU_NAME).txt

JOBS=$(SRATES) $(ODREPS) $(OSELF) $(VOLS) $(SBUCKS) $(B2B) $(CSTAU) $(CSTAUBS)

.PHONY: all jobs $(REPS) $(JOBS)

all:  $(REPS)
jobs: $(JOBS)
    
$(REPS):
	$(MAKE) --directory=$@ $(TARGET)

show:
	@echo $(ALL)
	
$(SRATES): $(SRATES_LIST)
	cat $^ > $@
	
$(ODREPS): $(ODREPS_LIST)
	cat $^ > $@
	
$(OSELF): $(OSELF_LIST)
	cat $^ > $@
	
$(SBUCKS_1): $(SBUCKS_LIST_1)
	cat $^ > $@

$(SBUCKS_2): $(SBUCKS_LIST_2)
	cat $^ > $@
		
$(VOLS_1): $(VOLS_LIST_1)
	cat $^ > $@

$(VOLS_2): $(VOLS_LIST_2)
	cat $^ > $@
	
# can $$ and secondexpand be used to automate these:

$(B2B_1): $(B2B_LIST_1)
	cat $^ > $@

$(B2B_2): $(B2B_LIST_2)
	cat $^ > $@

$(B2B_3): $(B2B_LIST_3)
	cat $^ > $@

$(B2B_4): $(B2B_LIST_4)
	cat $^ > $@

$(B2B_5): $(B2B_LIST_5)
	cat $^ > $@

$(B2B_6): $(B2B_LIST_6)
	cat $^ > $@
	
$(CSTAU): $(CSTAU_LIST)
	cat $^ > $@

$(CSTAUBS): $(CSTAUBS_LIST)
	cat $^ > $@

	
odreps:  $(ODREPS)
oself:   $(OSELF)
srates:  $(SRATES)
sbucks:  $(SBUCKS)
vols:    $(VOLS)
b2b:     $(B2B)
cstau:   $(CSTAU)
cstaubs: $(CSTAUBS)

clean-odreps:
	rm -f $(ODREPS)
	
clean-srates:
	rm -f $(SRATES)
	
cpt:
	cp -p t.pdf ~/Dropbox/Public/Thesis/khrabrov-mindeconomy-thesis.pdf