# if this is unset here, set on command line
v2x4 = 1

v2x4 := $(if $(v2x4),2x4.,)
