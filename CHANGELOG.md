# Changelog

## Unreleased (2026-07-22)

### Changed

- **Sandbox consolidation.** Merged the six separate test files
  (`sandbox.tex`, `test-compression.tex`, `test-overleaf.tex`,
  `test-edges.tex`, `test-moving.tex`, `test-natbib.tex`) into two:
  - `sandbox.tex` — unified biblatex test suite with 16 sections
    covering plain citations, range compression, default and prefixed
    locators, mixed entries, italic/slanted/bold-italic contexts, font
    sizes, scaling, small caps, `\emph` toggle, math adjacency, theorem
    and list environments, table cells, long locators, double-slash edge
    cases, footnotes, and drop-in `\cite` replacement. Includes
    switchable biblatex options (numeric-comp/numeric, biber/bibtex) via
    commented lines for Overleaf-style testing.
  - `test-natbib.tex` — kept separate because natbib is a fundamentally
    different backend that cannot coexist with biblatex in one document.
- **Reverted local v2.3 draft changes to `citemsp.sty`.** Restored the
  released v2.2 source as the canonical `.sty` file.

## v2.2 (2026-07-13)

Compatibility and robustness pass. The user-facing API
(`\citemsp{key/sec/par}`, `\citemspprefix{letter}{label}`, the seven
built-in prefixes, the super/subscript rendering) is unchanged.
Existing documents written against v2.1 compile and render identically.

### Added

- **natbib backend.** `citemsp` now sits on top of either `biblatex` or
  `natbib`. The package detects which is loaded at `\usepackage{citemsp}`
  time and selects the matching code path. This brings support for
  classes that auto-load `natbib` (notably `revtex4-2`, plus
  `IEEEtran`'s natbib mode, `elsarticle`, `aastex`, etc.), where
  `biblatex` was unusable.
- **Improved missing-backend diagnostic.** Loading `citemsp` without
  either `biblatex` or `natbib` now errors with a message naming both
  options instead of mentioning only `biblatex`.

### Changed

- **Default locator symbols use `\textsection` and `\textparagraph`**
  instead of `\S` and `\P`. The rendered glyphs (§, ¶) are unchanged.
  This removes a long-standing collision with the common physics/math
  preamble idioms `\def\S{\mathcal S}` and `\def\P{\mathcal P}`, under
  which v2.1 would crash on any `\citemsp{key/sec}` invocation with a
  default-locator section or paragraph.
- **Internal refactor for backend separation.** The locator-rendering
  body (italic-aware kerning, super/subscript layout, prefix dispatch)
  is now factored into `\@citesp@renderlocators`, shared between the
  biblatex and natbib code paths. Only the citation-number lookup and
  hyperref linkage differ between backends:
  - biblatex: `\bibhyperref{\printfield{labelnumber}}` inside a
    `\DeclareCiteCommand{\citelinksp}`.
  - natbib: `\@citesp@linkwrap{key}{\citenum{key}}`, where
    `\@citesp@linkwrap` becomes `\hyperlink{cite.<key>}{...}` if
    `hyperref` is loaded, and identity otherwise.
- **Added `\RequirePackage{etoolbox}`.** `biblatex` already pulled it
  in transitively for `\forcsvlist`; `natbib` does not, so the package
  now requires it explicitly.

### Compatibility matrix (post-v2.2)

| Backend / class                         | v2.1 | v2.2 |
| --------------------------------------- | :--: | :--: |
| `article`, `report`, `book`, `memoir`, KOMA + `biblatex` | OK   | OK   |
| `revtex4-2` (any options)               | fail | OK (via natbib) |
| `IEEEtran` (natbib mode)                | fail | OK   |
| `elsarticle`, `aastex` + natbib         | fail | OK   |
| Preamble redefining `\S` or `\P`        | broken | OK   |

### Not addressed

- `revtex4-2` + `biblatex` is still incompatible — that conflict lives
  inside biblatex's `\addtocontents` patch and revtex's TOC machinery,
  not in citemsp. Use the natbib code path with revtex.
- `IEEEtran`'s native (non-natbib) `\IEEEbibitem` mode would require a
  third backend; not implemented.
