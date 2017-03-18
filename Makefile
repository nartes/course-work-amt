all:

LATEX := pdflatex -output-directory=build/

assets-5-2: src/simple_analysis_1.m
	octave --eval 'simple_analysis_1(false);'

assets-5-3: src/realaudio_nmf_post.m
	octave --eval 'realaudio_nmf_post;'

report: doc/report.tex
	$(LATEX) $?

report_en: doc/report_en.tex
	$(LATEX) $?

presentation: doc/presentation.tex
	$(LATEX) $?

realaudio-nmf-post: doc/realaudio-nmf-post.tex
	$(LATEX) $?
