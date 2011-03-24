LS_DIR=../../list

WHATS_UP=sbucks

include $(MK_DIR)/head.2x4.mk

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

include $(MK_DIR)/tail.2x4.mk

clean:
	rm -fr tex txt
	
text: tex txt sum-tex dir-tex sum-txt