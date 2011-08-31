BASE=..
UTILS=$(BASE)/utils
MAKE_BASE=$(UTILS)/make
VC_IGNORE=$(MAKE_BASE)/vcignore.mk
XSL_BASE=$(UTILS)/xsl
CARDS_SRC=cards.xml
CARDS=ws-cards.rkt
CARD_FIELDS=ws-card-fields.rkt
CARDS_XSL_BASE=$(XSL_BASE)/cards
CARDS_XSL=$(CARDS_XSL_BASE)/base.xsl
CARD_FIELDS_XSL=$(CARDS_XSL_BASE)/generate-card-fields.xsl
OUT=$(CARDS) $(CARD_FIELDS)

VC_IGNORE_LIST=schemas.xml
include $(VC_IGNORE)

all: $(CARDS) $(CARD_FIELDS) $(VC_IGNORE_FILE)
.PHONY: clean

$(CARDS_XSL):
$(CARD_FIELDS_XSL):

$(CARDS): $(CARDS_XSL) $(CARDS_SRC)
	xsltproc -o $@ $^

$(CARD_FIELDS): $(CARD_FIELDS_XSL) $(CARDS_SRC)
	xsltproc -o $@ $^

clean:
	touch $(OUT)
	rm $(OUT)
