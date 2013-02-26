# This work is dedicated to the public domain.

texargs = -interaction nonstopmode -halt-on-error -file-line-error

default: mthesis.pdf # default target if you just type "make"


# Resources and rules for the introductory chapter. Sample 'make' rule
# included to show how you can process data as you compile your thesis
# using standard GNU make constructs.

deps += intro/intro.tex intro/processed.tex
cleans += intro/intro.aux intro/processed.tex

intro/processed.tex: intro/sample.tex
	sed -e s/terrible/wonderful/ $< >$@


# Chapter Two

## deps += ...
## cleans += ...
## etc


# The thesis itself. We move the PDF to a new filename so that viewers
# don't keep on trying to reload the file as it's being written and
# rewritten by pdfLaTeX. Instead we pseudo-atomically rename after all
# the processing is done. (You might think that a 'mv' would be the
# way to do this, but on Linux, Evince doesn't try to reload the file
# that it's currently looking at unless the file gets opened in write
# mode and closed, so we 'cp' instead.)

deps += myucthesis.cls uct12.clo aasmacros.sty mydeluxetable.sty \
  setup.tex thesis.bib yahapj.bst
cleans += thesis.aux thesis.bbl thesis.blg thesis.lof thesis.log \
  thesis.lot thesis.out thesis.toc mthesis.pdf setup.aux
toplevels += mthesis.pdf

mthesis.pdf: thesis.tex $(deps)
	pdflatex $(texargs) $(basename $<) >& chatter.txt
	bibtex $(basename $<)
	pdflatex $(texargs) $(basename $<) >& chatter.txt
	pdflatex $(texargs) $(basename $<) >& chatter.txt
	cp -f thesis.pdf $@ && rm -f thesis.pdf


# Approval page

cleans += approvalpage.aux approvalpage.log approvalpage.pdf
toplevels += approvalpage.pdf

approvalpage.pdf: approvalpage.tex $(deps)
	pdflatex $(texargs) $(basename $<)


# Helpers

all: $(toplevels)

clean:
	-rm -f $(cleans)
