REPS=freps
BASE1=$(REPS)-4
BASE2=$(REPS)-3
BASES=$(BASE1) $(BASE2)

QUE_PASA=overx-dreps
QUAD_PREFIX=$(QUE_PASA)-
#QUAD_SUFFIX=
#DROP=
TABLE_PREFIX=$(QUAD_PREFIX)$(DROP)

SUMMARY_PREFIX=$(BASE)-$(QUE_PASA)
SUMMARY_PREFIX1=$(SUMMARY_PREFIX)-4
SUMMARY_PREFIX2=$(SUMMARY_PREFIX)-3
INPUT_PATH=$(BASE)/$(QUE_PASA)/tex