# citemsp — Citation Locators for LaTeX

A LaTeX package adding per-key citation locators rendered as compact
superscript/subscript pairs on numeric citation labels. Works on top of
either `biblatex` or `natbib`.

## Quick start

**With biblatex:**

```latex
\usepackage[style=numeric, backend=biber]{biblatex}
\addbibresource{refs.bib}
\usepackage{citemsp}
```

**With natbib** (or a class that auto-loads it, e.g. `revtex4-2`,
`aastex`):

```latex
\usepackage[numbers]{natbib}        % omit if your class loads it
\usepackage{citemsp}
```

Build with `latexmk -pdf <file>.tex` (figures out biber vs bibtex
automatically). Manual chains: `pdflatex → biber → pdflatex → pdflatex`
for biblatex; `pdflatex → bibtex → pdflatex → pdflatex` for natbib.

## Syntax

`\citemsp{key/sec/par}` — the part before the first `/` is the citation
key; the second slot is the superscript locator (default §), the third
is the subscript (default ¶). A leading single letter selects a prefix
type from the registry below.

```latex
\citemsp{wald1984/6.1/2}          % [1] with §6.1 (super) and ¶2 (sub)
\citemsp{wald1984/3.2/e4.3}       % [1] with §3.2 (super) and eq.4.3 (sub)
\citemsp{mtw1973/p520}            % [2] with pp.520 (super)
\citemsp{a, b/2.1, c/3/e4}        % comma-separated multi-key list
```

## Built-in prefixes

| Prefix | Type       | Symbol |
|--------|------------|--------|
| `A`    | Appendix   | App.   |
| `C`    | Corollary  | Cor.   |
| `d`    | Definition | ≜      |
| `e`    | Equation   | eq.    |
| `f`    | Figure     | fig.   |
| `L`    | Lemma      | Lem.   |
| `n`    | Footnote   | †      |
| `p`    | Page       | pp.    |
| `t`    | Table      | ⊞      |
| `T`    | Theorem    | Th.    |

Register custom prefixes with `\citemspprefix{letter}{label}`.

## Document class compatibility

| Class                                | Backend to use  | Notes |
|--------------------------------------|-----------------|-------|
| `article`, `report`, `book`, `memoir`, KOMA-Script, `beamer` | either | Pick whichever you prefer. |
| `revtex4-2`, `revtex4-1` (APS)       | natbib (auto)   | Don't try biblatex — it's incompatible with revtex. |
| `aastex` / `aastex631` (AAS)         | natbib (auto)   | Just `\usepackage{citemsp}`. |
| `elsarticle` (Elsevier)              | natbib (manual) | `\usepackage[numbers]{natbib}` first. |
| `IEEEtran` natbib mode               | natbib (manual) | Use `\bibliographystyle{IEEEtranN}`. |
| `IEEEtran` default mode              | unsupported     | Uses `\IEEEbibitem`, neither biblatex nor natbib. |

## Repository structure

```
├── citemsp.sty          Package source (single copy, used by all subdirectories)
├── Makefile             Build docs/paper/sandbox, package CTAN zip
│
├── citemsp/             CTAN submission
│   ├── citemsp-doc.tex      Package documentation source
│   ├── citemsp-doc.pdf      Compiled documentation
│   ├── README.md            CTAN readme
│   └── LICENSE              LPPL 1.3c
│
├── paper/               arXiv paper
│   ├── citemsp-paper.tex    Paper source
│   └── citemsp-paper.pdf    Compiled paper
│
├── sandbox/             Development and compatibility testing
│   ├── sandbox.tex          Main test document
│   ├── test-overleaf.tex    Overleaf compatibility tests
│   └── test-compression.tex Compression (numeric-comp) tests
│
├── CHANGELOG.md        Version history
├── ROADMAP.md
└── LICENSE              LPPL 1.3c
```

Subdirectory builds find `citemsp.sty` via `TEXINPUTS` (set by the Makefile).

## Build commands

```bash
make doc        # Build CTAN documentation
make paper      # Build arXiv paper
make sandbox    # Build sandbox test document
make all        # Build everything
make ctan       # Package CTAN zip
make clean      # Remove build artifacts
```

## License

LPPL 1.3c — see [LICENSE](LICENSE).
