#!/bin/bash

#output_directory="/tmp/latex/output"
#mkdir -p ${output_directory}
#current_directory=$(pwd)

# first pass through the document
#pdflatex -output-directory ${output_directory} -file-line-error -halt-on-error "$1.tex"
pdflatex -file-line-error -halt-on-error $1.tex
bibtex -min-crossrefs=0 $1.aux
pdflatex -file-line-error -halt-on-error $1.tex
exit $?

# run bibtex. need to do this in the output directory
cp references.bib ${output_directory}
cd ${output_directory} 
bibtex -min-crossrefs=0 "$1.aux"
cd ${current_directory}

pdflatex -output-directory ${output_directory} -file-line-error -halt-on-error "$1.tex"
if [[ $? == 0 ]]
then
    cp /tmp/latex/output/$1.pdf ~/Documents/struck.pdf
fi

