all:

LATEX := pdflatex -output-directory=build/

assets:
	octave --eval 'simple_analysis_1(false);'

report: doc/report.tex
	$(LATEX) $?

report_en: doc/report_en.tex
	$(LATEX) $?

presentation: doc/presentation.tex
	$(LATEX) $?
