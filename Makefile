.PHONY: doc all check ctan ctan-tds clean

STY = citemsp.sty
VERSION = 2.3

# Root directory (where the canonical .sty lives)
ROOT := $(CURDIR)

# Export TEXINPUTS so that subdirectory builds find the root .sty
export TEXINPUTS := $(ROOT):$(TEXINPUTS)

# ── Build targets ────────────────────────────────────────────────────────────
doc:
	cd CTAN && latexmk -pdf -interaction=nonstopmode -halt-on-error citemsp-doc.tex

all: doc

# ── Reproducible local validation ────────────────────────────────────────────
check: all
	test -s CTAN/citemsp-doc.pdf

# ── CTAN zip ─────────────────────────────────────────────────────────────────
#  Packages only what CTAN expects: .sty, docs (.tex + .pdf), README, LICENSE.
ctan: doc
	rm -rf _ctan citemsp.zip
	mkdir -p _ctan/citemsp
	cp $(STY) CTAN/citemsp-doc.tex CTAN/citemsp-doc.pdf \
	   CTAN/README.md CTAN/LICENSE CHANGELOG.md _ctan/citemsp/
	cd _ctan && zip -qr ../citemsp.zip citemsp/
	rm -rf _ctan

# ── TDS archive for system-wide install ──────────────────────────────────────
ctan-tds: doc
	rm -rf _ctan-tds citemsp-$(VERSION)-tds.zip
	mkdir -p _ctan-tds/tex/latex/citemsp
	mkdir -p _ctan-tds/doc/latex/citemsp
	cp $(STY) _ctan-tds/tex/latex/citemsp/
	cp CTAN/citemsp-doc.tex CTAN/citemsp-doc.pdf CTAN/README.md \
	   CTAN/LICENSE CHANGELOG.md _ctan-tds/doc/latex/citemsp/
	cd _ctan-tds && zip -qr ../citemsp-$(VERSION)-tds.zip .
	rm -rf _ctan-tds

# ── Clean build artifacts ───────────────────────────────────────────────────
clean:
	cd CTAN && latexmk -c citemsp-doc.tex 2>/dev/null; rm -f refs-citemsp.bib
	rm -rf _ctan _ctan-tds citemsp.zip citemsp-$(VERSION)-tds.zip
