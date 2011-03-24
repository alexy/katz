# two runs:
#R1
#R2

# of four kinds each:
#K1
#K2
#K3
#K4


KIND_BASE ?= $(WHATS_UP)
KIND_LIST=$(BASE_LIST:%=$(KIND_BASE)-%)

kind_list:
	@echo KIND_LIST: $(KIND_LIST)

LIST_R1=$(KIND_LIST:%=$(R1)-%)
LIST_R2=$(KIND_LIST:%=$(R2)-%)

LIST_R1_K1=$(LIST_R1:%=$(K1)-%)
LIST_R1_K2=$(LIST_R1:%=$(K2)-%)
LIST_R1_K3=$(LIST_R1:%=$(K3)-%)
LIST_R1_K4=$(if $(K4),$(LIST_R1:%=$(K4)-%),)

LIST_R2_K1=$(LIST_R2:%=$(K1)-%)
LIST_R2_K2=$(LIST_R2:%=$(K2)-%)
LIST_R2_K3=$(LIST_R2:%=$(K3)-%)
LIST_R2_K4=$(if $(K4),$(LIST_R2:%=$(K4)-%),)
