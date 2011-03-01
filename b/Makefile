ROOTS=ereps lreps freps ureps-deux freps-deux
SRATES=${ROOTS:%=%/srates}
OVERX=${ROOTS:%=%/overx}
ALL=$(SRATES) $(OVERX)

.PHONY: all $(ALL)

all: $(ALL)
    
$(ALL):
	$(MAKE) --directory=$@ $(TARGET)

show:
	@echo $(ALL)
