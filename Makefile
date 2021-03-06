MAIN = document
PDFLATEX = pdflatex -shell-escape -halt-on-error
$(MAIN): check convert bib index build clean

build:
	$(PDFLATEX) $(MAIN).tex

index:
	makeindex -s config/index.ist $(MAIN) 
	makeindex $(MAIN).nlo -s nomencl.ist -o $(MAIN).nls 

check:
	@echo "The following items may contain weak word usage.--------------------"
	@sh ./commands/weasels.sh ./contents/chapters/*.md 1>&2
	@echo "The following items may contain passive language.-------------------"
	@sh ./commands/passive_voice.sh ./contents/chapters/*.md 1>&2
	@echo "The following items may contain unnecessary duplication.------------"
	@perl ./commands/dups ./contents/chapters/*.md 2>&2

convert:
	./commands/convert.sh

open:
	open $(MAIN).pdf
	# evince document.pdf &

bib:
	$(PDFLATEX) $(MAIN).tex
	bibtex $(MAIN)

clean:
	find -E . -path ./.git -prune -o  -regex ".*\.(aux|log|nls|dvi|blg|bbl|out|idx|ilg|ind|lol|lof|nlo|toc|loa|lot|nls)" -exec rm -f {} \;

