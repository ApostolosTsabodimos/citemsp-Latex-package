# citemsp — Per-key Citation Locators for LaTeX

A LaTeX package that attaches section, paragraph, and other locators
directly to numeric citation labels as compact superscript/subscript
pairs. Works on top of either `biblatex` or `natbib`.

## Quick start

**With biblatex:**

```latex
\usepackage[style=numeric, backend=biber]{biblatex}
\addbibresource{refs.bib}
\usepackage{citemsp}
```

**With natbib** (or a class that auto-loads it, e.g. `revtex4-2`,
`aastex631`):

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
\citemsp{smith2003/6.1/2}          % [1] with §6.1 (super) and ¶2 (sub)
\citemsp{smith2003/3.2/e4.3}       % [1] with §3.2 (super) and eq.4.3 (sub)
\citemsp{wang2020/p520}            % [2] with pp.520 (super)
\citemsp{a, b/2.1, c/3/e4}        % comma-separated multi-key list
```

## Built-in prefixes

| Prefix | Type       | Symbol |
|--------|------------|--------|
| `A`    | Appendix   | App.   |
| `C`    | Corollary  | Cor.   |
| `L`    | Lemma      | Lem.   |
| `T`    | Theorem    | Th.    |
| `d`    | Definition | ≜      |
| `e`    | Equation   | eq.    |
| `f`    | Figure     | fig.   |
| `n`    | Footnote   | †      |
| `p`    | Page       | pp.    |
| `t`    | Table      | ⊞      |

Register custom prefixes with `\citemspprefix{letter}{label}`.

## Document class compatibility

| Class                                | Backend to use  | Notes |
|--------------------------------------|-----------------|-------|
| `article`, `report`, `book`, `memoir`, KOMA-Script, `beamer` | either | Pick whichever you prefer. |
| `revtex4-2`, `revtex4-1` (APS)       | natbib (auto)   | Don't try biblatex — it's incompatible with revtex. |
| `aastex` / `aastex631` (AAS)         | natbib (auto)   | Just `\usepackage{citemsp}`. |
| `elsarticle` (Elsevier)              | natbib (manual) | `\usepackage[numbers]{natbib}` first. |
| `IEEEtran` natbib mode               | natbib (manual) | Use `\bibliographystyle{IEEEtranN}`. |

## Installation

### Per-project

Copy `citemsp.sty` into the same directory as your `.tex` file.

### System-wide

```bash
mkdir -p ~/texmf/tex/latex/citemsp
cp citemsp.sty ~/texmf/tex/latex/citemsp/
texhash ~/texmf
```

## Configuration

Adjust the locator glyph size and vertical offset after loading:

```latex
\usepackage{citemsp}
\renewcommand{\citemspscale}{0.4}           % default is 0.35
\renewcommand{\citemspraiseoffset}{2pt}     % default is 1.5pt
```

## Documentation

Full documentation with examples is in [`CTAN/citemsp-doc.pdf`](CTAN/citemsp-doc.pdf).

## Build commands

```bash
make doc        # Build CTAN documentation
make ctan       # Package CTAN zip
make ctan-tds   # Package TDS zip for system-wide install
make clean      # Remove build artifacts
```

## Requirements

- LaTeX2e (2020/10/01 or later)
- `biblatex` or `natbib` (any numeric style)
- `graphicx`, `etoolbox`
- `amssymb` recommended (for best glyph quality; not required)

## License

LPPL 1.3c — see [LICENSE](LICENSE).

## Authors

- Apostolos Tsampodimos — [apostolos.tsampodimos@ftmc.lt](mailto:apostolos.tsampodimos@ftmc.lt)
- Nathaniel Sherrill
- Agnese Mariotti
