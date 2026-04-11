SHELL := /bin/bash

.SHELLFLAGS := -ec

VERSION := $(shell cat VERSION)

FILES = \
    README.md.in

all: md-utils markdown html

MARKDOWN=$(FILES:.md.in=.md)
HTML=$(MARKDOWN:.md=.html)

$(MARKDOWN): % : %.in md-utils
	set -x; \
	bin/md-utils.pl $< > $@ || (rm -f $@ && false);

$(HTML): $(MARKDOWN)
	bin/md-utils.pl -r $< > $@ || (rm -f $@ && false);

include release-notes.mk

.PHONY: md-utils
md-utils: bin/md-utils.pl lib/Markdown/Render.pm

.PHONY: markdown
markdown: $(MARKDOWN)

.PHONY: html
html: $(HTML)

.PHONY: cpan
cpan:
	cd cpan && $(MAKE)

lib/Markdown/Render.pm: lib/Markdown/Render.pm.in
	sed -e 's/[@]PACKAGE_VERSION[@]/$(VERSION)/' < $< > $@

PERLSCRIPTS = bin/md-utils.pl.in

GPERLSCRIPTS = $(PERLSCRIPTS:.pl.in=.pl)

$(GPERLSCRIPTS): % : %.in
	sed -e 's/[@]PACKAGE_VERSION[@]/$(VERSION)/' < $< > $@
	chmod +x $@

include version.mk

clean:
	rm -f bin/md-utils.pl lib/Markdown/Render.pm
	rm -rf cpan/lib
	rm -rf cpan/bin
	rm -rf cpan/t
	rm -f cpan/README.md cpan/*.tar.gz
