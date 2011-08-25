BASH_BASE=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))../bash
GO_MAKE_SUBDIRS=$(BASH_BASE)/go-make-subdirs
RM_AUX_FILES=$(BASH_BASE)/rm-aux-files

.PHONY: clean
all: build

clean:
	$(RM_AUX_FILES)
	$(GO_MAKE_SUBDIRS) clean $(BASH_BASE)

build:
	$(GO_MAKE_SUBDIRS) all $(BASH_BASE)
