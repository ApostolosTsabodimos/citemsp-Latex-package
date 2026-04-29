# Changelog

## v2.2 (2026-04-28)

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

- **Mode-safe locator rendering.** The super/subscript pair is now
  emitted via `\ensuremath{...}` instead of bare `$...$`. Calling
  `\citemsp{...}` inside math mode (e.g. inside `$...$`, an `equation`
  environment, or a math-processed caption/title) no longer toggles the
  surrounding math mode off, which previously caused downstream
  `\mathcal`/`\mathsf` calls to fail with "only allowed in math mode".
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
| Any class with `\citemsp{...}` inside `$...$` / `equation` | broken | OK |
| Preamble redefining `\S` or `\P`        | broken | OK   |

### Not addressed

- `revtex4-2` + `biblatex` is still incompatible — that conflict lives
  inside biblatex's `\addtocontents` patch and revtex's TOC machinery,
  not in citemsp. Use the natbib code path with revtex.
- `IEEEtran`'s native (non-natbib) `\IEEEbibitem` mode would require a
  third backend; not implemented.
