PACKAGE = $(shell grep '^Package: ' DESCRIPTION | awk '{ print $$2 }')
VERSION = $(shell grep '^Version: ' DESCRIPTION | awk '{ print $$2 }')
PARENTDIR = ..
TARBALL = $(PACKAGE)_$(VERSION).tar.gz
TARBALL_LOC = $(PARENTDIR)/$(TARBALL)
CHECKDIR = $(PARENTDIR)/$(PACKAGE).Rcheck

all: doc check install

data:
	Rscript tools/get-data.R

doc:
	Rscript -e 'devtools::document(roclets=c("rd", "collate", "namespace", "vignette"))'

check:
	Rscript -e 'devtools::check()'

test:
	Rscript -e 'devtools::test()'

install:
	Rscript -e 'devtools::install()'

build:
	Rscript -e 'devtools::build()'

vignettes:
	Rscript -e 'devtools::build_vignettes()'

clean:
	rm -f $(TARBALL_LOC)
	rm -rf $(CHECKDIR)

.PHONY: data vignettes
