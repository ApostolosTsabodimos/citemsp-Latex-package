# Changelog

## v2.3 (2026-07-22)

### Added

- **Slanted font detection.** The locator renderer now detects slanted
  (`\textsl`) font shape in addition to italic (`\textit`), applying
  the same kerning adjustment to both.
- **Configurable raisebox offset.** New `\citemspraiseoffset` command
  (default 1.5pt) lets users tune the vertical offset of superscript
  locators via `\renewcommand`.

### Changed

- **Namespace consolidation.** All internal macros renamed from
  `@citesp@` to `@citemsp@` for consistency with the package name.
- **Removed amssymb dependency.** The package no longer loads `amssymb`.
  Fallback definitions are provided via `\providecommand` for
  `\triangleq`, `\boxplus`, and `\square`. Loading `amssymb` is
  recommended for best glyph quality but not required.
- **Idiomatic math anchors.** Replaced `\mbox{}` with `{}` in
  math-mode super/subscript anchors.
- **Safer key expansion.** Uses `\unexpanded{#1}` in the `\edef`
  accumulator for plain-key batching.
- **Removed `\citesize` alias.** First CTAN release; no installed base.
- **Copyright year.** Updated to 2025--2026.
- **File manifest.** Updated to list all five distributed files.
- **Documentation overhaul.** Comprehensive rewrite with all ten
  prefixes, comparison table, natbib section, limitations,
  compatibility matrix, subscript-only examples, font context demos,
  and non-physics examples.

### Sandbox

- Merged six separate test files into two (`sandbox.tex` for biblatex,
  `test-natbib.tex` for natbib).

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
