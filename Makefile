.PHONY: sync doc paper sandbox all ctan clean

STY = citemsp.sty

# ── Sync the canonical .sty into every subfolder ─────────────────────────────
sync:
	cp $(STY) citemsp/$(STY)
	cp $(STY) paper/$(STY)
	cp $(STY) sandbox/$(STY)

# ── Build targets ────────────────────────────────────────────────────────────
doc: sync
	cd citemsp && latexmk -pdf citemsp-doc.tex

paper: sync
	cd paper && latexmk -pdf citemsp-paper.tex

sandbox: sync
	cd sandbox && latexmk -pdf sandbox.tex

all: doc paper sandbox

# ── CTAN zip ─────────────────────────────────────────────────────────────────
#  Packages only what CTAN expects: .sty, docs (.tex + .pdf), README, LICENSE.
ctan: doc
	mkdir -p _ctan/citemsp
	cp citemsp/$(STY) citemsp/citemsp-doc.tex citemsp/citemsp-doc.pdf \
	   citemsp/README.md citemsp/LICENSE ../CHANGELOG.md _ctan/citemsp/
	cd _ctan && zip -r ../citemsp.zip citemsp/
	rm -rf _ctan

# ── Clean build artifacts (all subfolders) ───────────────────────────────────
clean:
	cd citemsp && latexmk -c citemsp-doc.tex 2>/dev/null; rm -f refs-citemsp.bib
	cd paper && latexmk -c citemsp-paper.tex 2>/dev/null; rm -f refs-citemsp.bib
	cd sandbox && latexmk -c sandbox.tex 2>/dev/null; rm -f sandbox-refs.bib overleaf-refs.bib test-refs.bib
	rm -rf _ctan citemsp.zip
