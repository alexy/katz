MK_DIR=../../../make
LS_DIR=../../list

WHATS_UP=sbucks

include $(MK_DIR)/base.sbucks.mk
include $(MK_DIR)/list1.mk
include $(MK_DIR)/rates1.mk

include $(LS_DIR)/$(REPS).hline.mk

include $(MK_DIR)/list.sbucks.mk
include $(MK_DIR)/tex.sbucks.mk
include $(MK_DIR)/dir.sbucks.mk
include $(MK_DIR)/txt.sbucks.mk