WHATS_UP=cstaubs
DROP=skew-

BASE=$(REPS)-4

FROM_QUAD_SUFFIX=-suffix

include $(MK_DIR)/base.mk

TEXIT=$(TEX4RATES) -x skew- -a
CUTPOS=9
HLINE=$(HLINE_DREPS)

