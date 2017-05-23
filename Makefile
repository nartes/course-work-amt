all:

LATEX := pdflatex -output-directory=build/

init:
	mkdir build -p
	mkdir build/doc -p

assets-5-2: src/simple_analysis_1.m
	octave --eval 'simple_analysis_1(false);'

assets-5-3: src/realaudio_nmf_post.m
	octave --eval 'realaudio_nmf_post;'

report: doc/report.tex
	$(LATEX) $?

report_pre: doc/report_pre_diploma_practice.tex
	$(LATEX) $?

report_en: doc/report_en.tex
	$(LATEX) $?

presentation: doc/presentation.tex
	$(LATEX) $?

realaudio-nmf-post: doc/realaudio-nmf-post.tex
	$(LATEX) $?

report_diploma: doc/report-diploma.tex
	$(LATEX) $?

presentation_diploma: doc/presentation-diploma.tex
	$(LATEX) $?
