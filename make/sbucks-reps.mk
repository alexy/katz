MK_DIR=../../../make

REPS_KIND = reps
CUTPOS    = 16

# invoke make like:
# v2x4=1 make ... 
# or export v2x4=1 to use 2x4 versions!

include $(MK_DIR)/v2x4.mk

include $(MK_DIR)/sbucks.$(v2x4)mk
