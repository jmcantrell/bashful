CWD := $(shell pwd)
PREFIX ?= /usr/local

DIRS=bin share/man/man1 share/zsh/functions

install:
	install -d $(foreach d,$(DIRS),$(PREFIX)/$(d))
	$(foreach d,$(DIRS),install $(d)/* $(PREFIX)/$(d);)
