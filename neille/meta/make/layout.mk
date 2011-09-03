HERE=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))
LAYOUT_SRC=layout.xml
LAYOUT_OUT=base.rkt
META=$(BASE)/meta
XSL_BASE=$(META)/xsl
LAYOUT_XSL_BASE=$(XSL_BASE)/layout
LAYOUT_XSL=$(LAYOUT_XSL_BASE)/base.xsl
LAYOUT_XSL_CUSTOM=$(LAYOUT_XSL_BASE)/custom.xsl
OUT=$(LAYOUT_OUT)

include $(HERE)/vcignore.mk

all: $(OUT) $(VC_IGNORE_FILE)
.PHONY: clean

$(LAYOUT_XSL_CUSTOM):
$(LAYOUT_XSL):

$(LAYOUT_OUT): $(LAYOUT_XSL) $(LAYOUT_SRC)
	xsltproc \
	$(LAYOUT_XSL_PARAMS) \
	-o $@ $^

clean:
	touch $(OUT)
	rm $(OUT)

