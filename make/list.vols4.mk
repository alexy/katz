X1=r
X2=m
Y1=e
Y2=u
X1Y1=$(X1)$(Y1)
X1Y2=$(X1)$(Y2)
X2Y1=$(X2)$(Y1)
X2Y2=$(X2)$(Y2)
Z1=int
Z2=norm

REI=$(X1Y1)-$(Z1)
RUI=$(X1Y2)-$(Z1)
MEI=$(X2Y1)-$(Z1)
MUI=$(X2Y2)-$(Z1)

REN=$(X1Y1)-$(Z2)
RUN=$(X1Y2)-$(Z2)
MEN=$(X2Y1)-$(Z2)
MUN=$(X2Y2)-$(Z2)

LIST_REI=$(BASE_LIST:%=$(REI)-$(WHATS_UP)-%)
LIST_RUI=$(BASE_LIST:%=$(RUI)-$(WHATS_UP)-%)
LIST_MEI=$(BASE_LIST:%=$(MEI)-$(WHATS_UP)-%)
LIST_MUI=$(BASE_LIST:%=$(MUI)-$(WHATS_UP)-%)
LIST_REN=$(BASE_LIST:%=$(REN)-$(WHATS_UP)-%)
LIST_RUN=$(BASE_LIST:%=$(RUN)-$(WHATS_UP)-%)
LIST_MEN=$(BASE_LIST:%=$(MEN)-$(WHATS_UP)-%)
LIST_MUN=$(BASE_LIST:%=$(MUN)-$(WHATS_UP)-%)