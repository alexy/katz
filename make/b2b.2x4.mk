LS_DIR=../../list

WHATS_UP=b2b$(REPS_KIND)

include $(MK_DIR)/head.2x4.mk

ROGUE=--norogue
include $(MK_DIR)/base.b2b.mk
include $(MK_DIR)/list1.mk
include $(MK_DIR)/rates1.mk

R1=abs
R2=rel

K1=befr
K2=aftr
K3=self
K4=srev

include $(MK_DIR)/tail.2x4.mk

clean:
	rm -fr $(TEX_DIR) $(TXT_DIR)
	
text: tex txt sum-tex dir-tex sum-txt