CARDS_SRC=cards.xml
CARDS=ws-cards.rkt
CARD_FIELDS=ws-card-fields.rkt
XSL_BASE=../utils/xsl
CARDS_XSL_BASE=$(XSL_BASE)/cards
CARDS_XSL=$(CARDS_XSL_BASE)/base.xsl
CARD_FIELDS_XSL=$(CARDS_XSL_BASE)/generate-card-fields.xsl
OUT=$(CARDS) $(CARD_FIELDS)
VC_IGNORE_LIST=schemas.xml


all: $(CARDS) $(CARD_FIELDS) .gitignore
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

.gitignore:
	for out in $(OUT); do \
	  echo $$out; \
	done >$@

	for ign in $(VC_IGNORE_LIST); do \
	  echo $$ign; \
	done >>$@
