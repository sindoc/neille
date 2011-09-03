#!/bin/bash

TARGET=$1
BASH_BASE=$2

GO_MAKE=$BASH_BASE/neille-go-make.bash

find . -ipath './*/Makefile' -exec $GO_MAKE {} $TARGET ';'
