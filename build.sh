#!/usr/bin/zsh

if [[ ! -e build/spectrum.png ]] then
	octave --eval 'simple_analysis_1(false)'
fi

#pdflatex -output-directory=build/ doc/report_en.tex
pdflatex -output-directory=build/ doc/report.tex
