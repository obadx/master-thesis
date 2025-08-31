# Makefile for LaTeX project

MAIN = main
LATEX = xelatex -shell-escape -interaction=nonstopmode
BIBTEX = bibtex

.PHONY: all bib build clean cleanall

all: build

bib:
	$(BIBTEX) $(MAIN)

build:
	$(LATEX) $(MAIN).tex
	@if grep -q "Citation" $(MAIN).log; then \
		echo "Citations found, running BibTeX..."; \
		$(BIBTEX) $(MAIN); \
		$(LATEX) $(MAIN).tex; \
	fi
	$(LATEX) $(MAIN).tex

quick:
	$(LATEX) $(MAIN).tex

clean:
	rm -f *.aux *.bbl *.blg *.log *.out *.toc *.lof *.lot *.lol *.gls *.glo *.ist *.glg *.xdy *.nav *.snm *.vrb *.synctex.gz

cleanall: clean
	rm -f $(MAIN).pdf

watch:
	@echo "Watching for changes... (Ctrl+C to stop)"
	@while true; do \
		inotifywait -q -e modify *.tex *.bib; \
		make quick; \
	done

help:
	@echo "Available targets:"
	@echo "  all      - Build complete document (default)"
	@echo "  bib      - Run BibTeX only"
	@echo "  build    - Build document with BibTeX if needed"
	@echo "  quick    - Single pass compilation (no BibTeX)"
	@echo "  clean    - Remove auxiliary files"
	@echo "  cleanall - Remove auxiliary files and PDF"
	@echo "  watch    - Watch for changes and recompile"
	@echo "  help     - Show this help message"
