MK_DIR=../../../make
LS_DIR=../../list

WHATS_UP=vols4

# safe separate dirs for 2x4 testing
V2      = -2x4
TEX_DIR = tex$(V2)
TXT_DIR = txt$(V2)

include $(MK_DIR)/base.vols4.mk
include $(MK_DIR)/list1.mk
include $(MK_DIR)/rates1.mk

R1=int
R2=norm

K1=re
K2=ru
K3=me
K4=mu

CUTPOS_R1 = 14
CUTPOS_R2 = 15

include $(MK_DIR)/list.2x4.mk
include $(MK_DIR)/tex.2x4.mk
include $(MK_DIR)/dir.2x4.mk
include $(MK_DIR)/txt.2x4.mk

hline:
	@echo HLINE: $(HLINE)