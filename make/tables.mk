DIRS=\
srates \
overx-dreps \
overx-self \
vols4 \
sbucks-ments \
sbucks-reps \
b2br \
b2bm \
cstaubs

.PHONY: all $(DIRS)

all: $(DIRS)

$(DIRS):
	$(MAKE) --directory=$@ tex sum-tex dir-tex txt sum-txt