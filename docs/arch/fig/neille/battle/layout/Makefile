BASE=../..
LAYOUT_SRC=layout.xml
LAYOUT_OUT=base.rkt
XSL_BASE=$(BASE)/utils/xsl
LAYOUT_XSL_BASE=$(XSL_BASE)/layout
LAYOUT_XSL=$(LAYOUT_XSL_BASE)/base.xsl
LAYOUT_XSL_CUSTOM=$(LAYOUT_XSL_BASE)/custom.xsl
OUT=$(LAYOUT_OUT)

all: $(LAYOUT_OUT)
.PHONY: clean

$(LAYOUT_XSL_CUSTOM):
$(LAYOUT_XSL):

$(LAYOUT_OUT): $(LAYOUT_XSL) $(LAYOUT_SRC)
	xsltproc -o $@ $^

clean:
	touch $(OUT)
	rm $(OUT)
