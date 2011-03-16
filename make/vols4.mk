MK_DIR=../../../make
LS_DIR=../../list

WHATS_UP=vols4

include $(MK_DIR)/base.vols4.mk
include $(MK_DIR)/list1.mk
include $(MK_DIR)/rates1.mk
include $(MK_DIR)/list.vols4.mk
include $(MK_DIR)/tex.vols4.mk
include $(MK_DIR)/dir.vols4.mk
include $(MK_DIR)/txt.vols4.mk

hline:
	@echo HLINE: $(HLINE)