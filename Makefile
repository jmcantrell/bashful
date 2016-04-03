CWD := $(shell pwd)
PREFIX ?= /usr/local

DIRS=bin share/man/man1 share/zsh/functions

default: gpp_build

install:
	install -d $(foreach d,$(DIRS),$(PREFIX)/$(d))
	$(foreach d,$(DIRS),install $(d)/* $(PREFIX)/$(d);)

gpp_clean:
	rm -rf lib

gpp_build: gpp_clean
	./tool/get_function.sh "./bin/*" lib
	./tool/depend-clac.sh "./lib/*/*"
	rm -rf lib
