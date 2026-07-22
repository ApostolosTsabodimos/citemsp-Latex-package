.PHONY: doc paper sandbox all ctan clean

STY = citemsp.sty

# Root directory (where the canonical .sty lives)
ROOT := $(CURDIR)

# Export TEXINPUTS so that subdirectory builds find the root .sty
export TEXINPUTS := $(ROOT):$(TEXINPUTS)

# ── Build targets ────────────────────────────────────────────────────────────
doc:
	cd CTAN && latexmk -pdf citemsp-doc.tex

paper:
	cd paper && latexmk -pdf citemsp-paper.tex

sandbox:
	cd sandbox && latexmk -pdf sandbox.tex

all: doc paper sandbox

# ── CTAN zip ─────────────────────────────────────────────────────────────────
#  Packages only what CTAN expects: .sty, docs (.tex + .pdf), README, LICENSE.
ctan: doc
	mkdir -p _ctan/citemsp
	cp $(STY) CTAN/citemsp-doc.tex CTAN/citemsp-doc.pdf \
	   CTAN/README.md CTAN/LICENSE CHANGELOG.md _ctan/citemsp/
	cd _ctan && zip -r ../citemsp.zip citemsp/
	rm -rf _ctan

# ── Clean build artifacts (all subfolders) ───────────────────────────────────
clean:
	cd CTAN && latexmk -c citemsp-doc.tex 2>/dev/null; rm -f refs-citemsp.bib
	cd paper && latexmk -c citemsp-paper.tex 2>/dev/null; rm -f refs-citemsp.bib
	cd sandbox && latexmk -c sandbox.tex 2>/dev/null; rm -f sandbox-refs.bib
	rm -rf _ctan citemsp.zip
