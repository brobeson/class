#!/bin/bash

pdflatex -file-line-error -halt-on-error "$1.tex" && \
bibtex "$1.aux" && \
pdflatex -file-line-error -halt-on-error "$1.tex" && \
pdflatex -file-line-error -halt-on-error "$1.tex"
