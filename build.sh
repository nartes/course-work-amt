#!/usr/bin/zsh

if [[ ! -e build/simple_analysis_nmf.png ||
      ! -e build/simple_analysis_dtfs.png ]] then
	octave --eval 'simple_analysis_1(false)'
fi

pdflatex -output-directory=build/ doc/report_en.tex
#pdflatex -output-directory=build/ doc/report.tex
#pdflatex -output-directory=build/ doc/presentation.tex
