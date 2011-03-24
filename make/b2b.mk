LS_DIR=../../list

WHATS_UP=b2b$(REPS_KIND)

ROGUE=--rogue
include $(MK_DIR)/base.b2b.mk
include $(MK_DIR)/list1.mk
include $(MK_DIR)/rates1.mk
include $(MK_DIR)/list.b2b.mk
include $(MK_DIR)/tex.b2b.mk
include $(MK_DIR)/dir.b2b.mk
include $(MK_DIR)/txt.b2b.mk

clean:
	rm -fr $(TEX_DIR) $(TXT_DIR)
	
text: tex txt sum-tex dir-tex sum-txt