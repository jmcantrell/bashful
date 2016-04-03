CWD := $(shell pwd)
PREFIX ?= /usr/local

DIRS=bin share/man/man1 share/zsh/functions

install:
	install -d $(foreach d,$(DIRS),$(PREFIX)/$(d))
	$(foreach d,$(DIRS),install $(d)/* $(PREFIX)/$(d);)

gpp_build:
	./tool/get_function.sh "./bin/*" lib
	./tool/depend-clac.sh "./lib/gpp*/*"
