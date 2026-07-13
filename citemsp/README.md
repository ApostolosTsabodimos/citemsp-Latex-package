# citemsp — Per-key citation locators for LaTeX

`citemsp` is a LaTeX package that adds section (§) and paragraph (¶)
locators — plus equation, figure, box, and other prefix types — directly
to numeric citation labels. It works on top of either `biblatex` or
`natbib`.

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

## Syntax

Each entry in the comma-separated list has the form:

| Input | Output |
|---|---|
| `\citemsp{key}` | `[1]` — plain citation |
| `\citemsp{key/sec}` | `[1^{§sec}]` — section only |
| `\citemsp{key/sec/par}` | `[1^{§sec}_{¶par}]` — section + paragraph |

A leading single letter selects a prefix type from the registry:

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

Entries can be freely mixed: `\citemsp{key1/3.2/5, key2, key3/e4.3}`.

## Document class compatibility

| Class                                | Backend to use  |
|--------------------------------------|-----------------|
| `article`, `report`, `book`, KOMA    | either          |
| `revtex4-2`, `revtex4-1` (APS)      | natbib (auto)   |
| `aastex` / `aastex631` (AAS)        | natbib (auto)   |
| `elsarticle` (Elsevier)             | natbib (manual) |
| `IEEEtran` natbib mode              | natbib (manual) |

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

Adjust the locator glyph size by redefining `\citemspscale` after loading:

```latex
\usepackage{citemsp}
\renewcommand{\citemspscale}{0.4}  % default is 0.35
```

## Requirements

- LaTeX2e (2020/10/01 or later)
- `biblatex` or `natbib` (any numeric style)
- `graphicx`, `etoolbox`

## License

LaTeX Project Public License, version 1.3c or later.

## Author

Apostolos Tsampodimos — [apostolos.tsampodimos@ftmc.lt](mailto:apostolos.tsampodimos@ftmc.lt)
