-include Makefile.local

CV_SHORT:= mehrshad-lotfi

TEX := $(shell find ./ -type f -name "*.tex")
CLS := $(shell find ./ -type f -name "*.cls")
BIB := $(shell find ./ -type f -name "*.bib")

include .devcontainer/rules.mk

GNUPLOTS   := $(addsuffix .pdf,$(basename $(shell find ./figures -type f -name "*.gnuplot" | grep -v common)))
PAPER_DEPS := $(TEX) $(CLS) $(BIB) $(FIG) $(GNUPLOTS)

LATEX := python3 ./bin/latexrun --color auto --bibtex-args="-min-crossrefs=9000"

all: $(CV_SHORT).pdf

%.eps: %.dia
	dia -e $@ -t eps $<

%.pdf: %.eps
	epspdf $< $@.tmp.pdf
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 \
	  -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH \
	  -sOutputFile=$@ $@.tmp.pdf
	rm -f $@.tmp.pdf

%.pdf: %.gnuplot %.dat figures/common.gnuplot
	(cd $(dir $@) ; gnuplot $(notdir $<)) | pdfcrop - $@

build: $(CV_SHORT).pdf

$(CV_SHORT).pdf: $(PAPER_DEPS)
	$(LATEX) main.tex -O .latex.out -o $@

check-hadolint:
	@hadolint .devcontainer/texlive.Dockerfile

help:
	@printf "Usage: make [target]\n"
	@printf "\n"
	@printf "Available targets:\n"
	@printf "\n"
	@printf "\thelp                     Show this help message\n";
	@printf "$(HELP_MSG)"
	@printf "\n";

clean:
	$(LATEX) --clean-all -O .latex.out
	@rm -frv .latex.out $(PDFS) $(GNUPLOTS) arxiv arxiv.tar.gz
	@rm -rfv $(CV_SHORT)
