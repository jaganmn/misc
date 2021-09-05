all: README.html distributions.Rout notes.pdf

%.html: %.md
	pandoc $< -s -o $@ 

%.Rout: %.R %.cpp %.h
	R CMD BATCH --vanilla $<

%.pdf: %.tex
	pdflatex $<
	pdflatex $<

.PHONY: clean
clean:
	rm -f *.{o,so,aux,log,out} *~

new: clean
	rm -f *.{Rout,pdf,html}
