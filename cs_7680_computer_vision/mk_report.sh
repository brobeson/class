#!/bin/bash

pdflatex -output-directory ~/Documents/phd/cs7680/ -file-line-error -halt-on-error "$1.tex" && \
bibtex "$1.aux" && \
pdflatex -output-directory ~/Documents/phd/cs7680/ -file-line-error -halt-on-error "$1.tex" && \
pdflatex -output-directory ~/Documents/phd/cs7680/ -file-line-error -halt-on-error "$1.tex"
