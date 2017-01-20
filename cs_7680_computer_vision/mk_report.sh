#!/bin/bash

#pdflatex -output-directory ~/Documents/phd/cs7680/ -file-line-error -halt-on-error "$1" && \
#bibtex "$1.aux" && \
#pdflatex -output-directory ~/Documents/phd/cs7680/ -file-line-error -halt-on-error "$1" && \
#pdflatex -output-directory ~/Documents/phd/cs7680/ -file-line-error -halt-on-error "$1"

pdflatex -file-line-error -halt-on-error "$1.tex" && \
bibtex "$1.aux" && \
pdflatex -file-line-error -halt-on-error "$1.tex" && \
pdflatex -file-line-error -halt-on-error "$1.tex"
