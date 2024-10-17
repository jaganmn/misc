.PHONY: all
all: doc check

%.Rout: %.R %.cpp %.hpp
	R CMD BATCH --vanilla $<

%.pdf: %.tex
	pdflatex $<
	pdflatex $<

.PHONY: check
check: distributions.Rout

.PHONY: doc
doc: distributions.pdf

.PHONY: clean
clean:
	rm -f *.{o,so,aux,log,out}

.PHONY: distclean
distclean: clean
	rm -f README.html distributions.Rout distributions.pdf

README.html: README.md
	pandoc --shift-heading-level-by=-1 $< -s -o $@
