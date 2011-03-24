LS_DIR=../../list

WHATS_UP=sbucks

# safe separate dirs for 2x4 testing
V2      = -2x4
TEX_DIR = tex$(V2)
TXT_DIR = txt$(V2)

include $(MK_DIR)/base.sbucks.mk
include $(MK_DIR)/list1.mk
include $(MK_DIR)/rates1.mk

R1=avg
R2=med

K1=self
K2=star
K3=auds
#K4=

KIND_BASE = $(DREPS)
DIR_BASE  = $(DREPS)

include $(MK_DIR)/list.2x4.mk
include $(MK_DIR)/tex.2x4.mk
include $(MK_DIR)/dir.2x4.mk
include $(MK_DIR)/txt.2x4.mk

clean:
	rm -fr tex txt
	
text: tex txt sum-tex dir-tex sum-txt