# citemsp — Per-key citation locators for biblatex

`citemsp` is a LaTeX package that extends `biblatex` with section (§) and paragraph (¶) locators attached directly to numeric citation labels.

## Quick start

```latex
\usepackage[style=numeric, backend=biber]{biblatex}
\usepackage{citemsp}
```

```latex
The Schwarzschild metric~\citemsp{wald1984/6.1/2} describes ...
% Output: The Schwarzschild metric [1^{§6.1}_{¶2}] describes ...

General covariance~\citemsp{einstein1915, wald1984/4, hawking1974/1/2}
% Output: General covariance [1, 2^{§4}, 3^{§1}_{¶2}]
```

## Syntax

Each entry in the comma-separated list has the form:

| Input | Output |
|---|---|
| `\citemsp{key}` | `[1]` — plain citation |
| `\citemsp{key/sec}` | `[1^{§sec}]` — section only |
| `\citemsp{key/sec/par}` | `[1^{§sec}_{¶par}]` — section + paragraph |

Entries can be freely mixed: `\citemsp{key1/3.2/5, key2, key3/1}`.

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
- `biblatex` (any numeric style)
- `graphicx`

## License

LaTeX Project Public License, version 1.3c or later.

## Author

Apostolos Tsampodimos — [apostolos.tsampodimos@ftmc.lt](mailto:apostolos.tsampodimos@ftmc.lt)
