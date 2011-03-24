MK_DIR=../../../make

REPS_KIND = r

# invoke make like:
# v2x4=1 make ... 
# or export v2x4=1 to use 2x4 versions!

v2x4 := $(if $(v2x4),2x4.,)

include $(MK_DIR)/b2b.$(v2x4)mk
