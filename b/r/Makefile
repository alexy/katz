WEEKS=../../weeks.byte
OSELF=overx-self-medians.txt
WEEKS_DIR=weeks
AH_DIR=$(WEEKS_DIR)/a10d
DH_DIR=$(WEEKS_DIR)/d10d
AH3_DIR=$(AH_DIR)3wk
DH3_DIR=$(DH_DIR)3wk

TABLE_DIRS=$(AH_DIR) $(DH_DIR) $(AH3_DIR) $(DH3_DIR)
PDF_MK=../../../../make/make.weeks

WEEKS_HT=$(WEEKS)\ -a\ -h10
WEEKS_AH=$(WEEKS_HT)\ -j\ -o\ $(AH_DIR)
WEEKS_DH=$(WEEKS_HT)\ -d\ -o\ $(DH_DIR)
WEEKS_AH3=$(WEEKS_HT)\ -j\ -w3\ -o\ $(AH3_DIR)
WEEKS_DH3=$(WEEKS_HT)\ -d\ -w3\ -o\ $(DH3_DIR)

.PHONY: all $(TABLE_DIRS) tables

all:
	for p in $(WEEKS_AH) $(WEEKS_DH) $(WEEKS_AH3) $(WEEKS_DH3); do (cat katz.list | xargs -n1 $$p); $$p -r $(OSELF); done
#	for p in $(WEEKS_AH) $(WEEKS_DH) $(WEEKS_AH3) $(WEEKS_DH3); do echo $$p; done

clean:
	rm -fr $(AH_DIR) $(DH_DIR) $(AH3_DIR) $(DH3_DIR)
	
$(TABLE_DIRS):
	$(MAKE) --directory=$@ -f $(PDF_MK) $(TARGET)
	
tables: $(TABLE_DIRS)