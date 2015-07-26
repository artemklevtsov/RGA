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
	Rscript -e 'devtools::check(quiet = TRUE)'

test:
	Rscript -e 'devtools::test()'

install:
	Rscript -e 'devtools::install()'

build:
	Rscript -e 'devtools::build(quiet = TRUE)'

build-win:
	Rscript -e 'devtools::build_win(quiet = TRUE)'

vignettes:
	Rscript -e 'devtools::build_vignettes()'

submit:
	Rscript -e 'devtools::submit_cran()'

clean:
	rm -f $(TARBALL_LOC)
	rm -rf $(CHECKDIR)

.PHONY: build data vignettes
