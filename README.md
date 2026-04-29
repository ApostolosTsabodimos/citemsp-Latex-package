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
\citemsp{mtw1973/b21.1}           % [2] with □21.1 (sub)
\citemsp{a, b/2.1, c/3/e4}        % comma-separated multi-key list
```

## Built-in prefixes

| Prefix | Type       | Symbol |
|--------|------------|--------|
| `b`    | Box        | □      |
| `d`    | Definition | ≜      |
| `e`    | Equation   | eq.    |
| `f`    | Figure     | ⊡      |
| `n`    | Footnote   | †      |
| `p`    | Page       | pp.    |
| `t`    | Table      | ⊞      |

Register custom prefixes with `\citemspprefix{letter}{label}`.

## Document class compatibility

| Class                                | Backend to use  | Notes |
|--------------------------------------|-----------------|-------|
| `article`, `report`, `book`, `memoir`, KOMA-Script, `beamer` | either | Pick whichever you prefer. |
| `revtex4-2`, `revtex4-1` (APS)       | natbib (auto)   | Don't try biblatex — it's incompatible with revtex. Put `\title`/`\author`/`\affiliation` *inside* `\begin{document}`. |
| `aastex` / `aastex631` (AAS)         | natbib (auto)   | Just `\usepackage{citemsp}`. |
| `elsarticle` (Elsevier)              | natbib (manual) | `\usepackage[numbers]{natbib}` first. |
| `IEEEtran` natbib mode               | natbib (manual) | Use `\bibliographystyle{IEEEtranN}`. |
| `IEEEtran` default mode              | unsupported     | Uses `\IEEEbibitem`, neither biblatex nor natbib. |

If neither `biblatex` nor `natbib` is loaded when `citemsp` loads, the
package errors with a message naming both options.

## Repository structure

```
├── ctan/               CTAN upload material
│   ├── citemsp.sty         Package source (v2.2)
│   ├── citemsp-doc.tex     Package documentation source
│   └── citemsp-doc.pdf     Compiled documentation
│
├── paper/              arXiv paper
│   ├── citemsp-paper.tex   Paper source
│   ├── citemsp-paper.pdf   Compiled paper
│   └── citemsp.sty         Package copy (for self-contained build)
│
├── CHANGELOG.md        Version history
└── LICENSE             LPPL 1.3c
```

## License

LPPL 1.3c — see [LICENSE](LICENSE).
