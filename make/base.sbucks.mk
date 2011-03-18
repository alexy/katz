DREPS ?= d$(REPS_KIND)
DROP  =  stars-$(DREPS)-

SUMMARY_PREFIX = $(REPS)-$(WHATS_UP)-$(REPS_KIND)

include $(MK_DIR)/base.mk

TEXIT=$(TEXSTARBUCKS)
#we don't really need averages, as they are too overwhelmed by outliers,
#but we do it anyways... smiley...
RUN2=-a
XARGS_N = 1
