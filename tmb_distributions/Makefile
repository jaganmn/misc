output = README.html distributions.Rout distributions.pdf

.PHONY: all
all: $(output)

%.html: %.md
	pandoc --shift-heading-level-by=-1 $< -s -o $@

%.Rout: %.R %.cpp %.hpp
	R CMD BATCH --vanilla $<

%.pdf: %.tex
	pdflatex $<
	pdflatex $<

.PHONY: clean
clean:
	rm -f *.{o,so,aux,log,out}

.PHONY: distclean
distclean: clean
	rm -f $(output)
