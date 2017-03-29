#!/bin/bash

#pdflatex -output-directory ~/Documents/phd/cs7680/ -file-line-error -halt-on-error "$1" && \
#bibtex "$1.aux" && \
#pdflatex -output-directory ~/Documents/phd/cs7680/ -file-line-error -halt-on-error "$1" && \
#pdflatex -output-directory ~/Documents/phd/cs7680/ -file-line-error -halt-on-error "$1"

mkdir -p /tmp/latex/output
pdflatex -output-directory /tmp/latex/output/ -file-line-error -halt-on-error "$1.tex"
if [[ $? == 0 ]]
then
    cp /tmp/latex/output/$1.pdf ./
fi
#bibtex "$1.aux" && \
#pdflatex -file-line-error -halt-on-error "$1.tex" && \
#pdflatex -file-line-error -halt-on-error "$1.tex"
