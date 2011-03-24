LS_DIR=../../list

WHATS_UP=b2b$(REPS_KIND)
ROGUE=--norogue
include $(MK_DIR)/base.b2b.mk

# safe separate dirs for 2x4 testing
V2      = -2x4
TEX_DIR = tex$(V2)
TXT_DIR = txt$(V2)

include $(MK_DIR)/list1.mk
include $(MK_DIR)/rates1.mk
R1=abs
R2=rel
K1=befr
K2=aftr
K3=self
K4=srev
include $(MK_DIR)/list.2x4.mk
include $(MK_DIR)/tex.2x4.mk
include $(MK_DIR)/dir.2x4.mk
include $(MK_DIR)/txt.2x4.mk

clean:
	rm -fr tex txt
	
text: tex txt sum-tex dir-tex sum-txt