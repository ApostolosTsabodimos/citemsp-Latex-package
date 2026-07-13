# citemsp & citewhy — Development and Publication Roadmap

> This document captures all design decisions, implementation details, and publication
> strategy discussed between Apostolos Tsampodimos and collaborators.
> It is split into two phases: **Phase 1** (reader-facing, citemsp) and
> **Phase 2** (writer/collaborator-facing, citewhy).

---

## Phase 1 — citemsp: Reader-Facing Improvements + Publication

### 1.1 Package Fixes (before any submission)

#### 1.1.1 Fix GitHub URLs

The repository URL is inconsistent across files:

| File | Current URL |
|------|------------|
| `paper/citemsp-paper.tex` (line 97) | `https://github.com/apostolostsampodimos/citemsp` |
| `ctan/citemsp-doc.tex` (line 28) | `https://github.com/ApostolosTsabodimos/citemsp-Latex-package` |

**Action:** Pick one canonical URL and update all references. The URL must match the
actual GitHub repository. Both the paper footnote and the `\githublink` macro in the
CTAN doc need to point to the same place.

#### 1.1.2 Remove "Draft:" from paper title

`paper/citemsp-paper.tex` line 72 currently reads:

```latex
\title{Draft: \textbf{\texttt{citemsp}: Citation Locators for \LaTeX}}
```

**Action:** Remove the `Draft:` prefix before arXiv submission.

#### 1.1.3 Add paragraph locator disclaimer

The paragraph locator (¶) is the only locator type that references content without
explicit numbering in the source document. Unlike sections, equations, figures, tables,
and pages — which all have printed numbers — paragraphs must be counted manually.

**Problems with paragraph counting:**
- Ambiguous: does a displayed equation break a paragraph? Does an indented block count?
- Edition-dependent: reprintings may reflow text, changing paragraph boundaries.
- Unverifiable: a reviewer cannot quickly check the count without doing it themselves.

**Action:** Add a note to the Conventions section of `ctan/citemsp-doc.tex` (after line 371):

> *Note:* Paragraph locators rely on manual counting from the start of the referenced
> section. Since paragraphs are not explicitly numbered in published sources, these
> locators may be ambiguous across editions or between readers. When using ¶ locators,
> consider providing additional context in the surrounding text so the reader can locate
> the passage independently (e.g., "Wald's discussion of the Bianchi identity
> \citemsp{wald1984/3.2/2}").

A similar note should be added to the arXiv paper.

#### 1.1.4 Add `\PackageWarning` for malformed input

Currently, malformed input like `\citemsp{wald1984/6.1/2/extra}` or `\citemsp{wald1984/}`
is silently consumed by the delimited `\def` parser and may produce unexpected output.

**Action:** Add validation in `\@citemsp@parse` to detect:
- Empty citation keys
- Trailing slashes producing empty locator slots (if unintentional)
- More than two locator slots (extra `/` delimiters)

Implementation approach — after the `\def\@citemsp@parse#1/#2/#3/#4\@nil` pattern,
check whether `#4` is non-empty (it should always be empty in well-formed input):

```latex
\def\@citemsp@parse#1/#2/#3/#4\@nil{%
  \def\@citesp@tmp{#4}%
  \ifx\@citesp@tmp\empty\else
    \PackageWarning{citemsp}{Malformed entry '#1/#2/#3/#4' — too many slash
      segments. Only key/loc1/loc2 is supported}%
  \fi
  \def\@citesp@sec{#2}%
  \def\@citesp@par{#3}%
  \citelinksp{#1}%
}
```

Note: the `#4` in the delimited pattern already captures everything after the third
slash. If it's non-empty, the user provided too many segments.

#### 1.1.5 Expand Section 3 — Comparison with Standard Biblatex

This is currently two sentences in the paper and a commented-out table in the CTAN doc.
It should be the strongest persuasive section — it must make the reader *feel* the
verbosity problem.

**Action — arXiv paper:** Expand Section 3 to include:

1. **Side-by-side source comparison** showing three sources with locators:

   Standard biblatex:
   ```latex
   \autocites[§6.1, ¶2]{wald1984}[Box~21.1]{mtw1973}[§1, eq.~4.3]{hawking1974}
   ```

   citemsp:
   ```latex
   \citemsp{wald1984/6.1/2, mtw1973/b21.1, hawking1974/1/e4.3}
   ```

2. **Character count comparison** — the citemsp version is shorter, flatter (no nested
   brackets), and separates keys from locators with a consistent delimiter.

3. **Scaling argument** — show what happens in a dense review paragraph with 6-8
   citations, each with locators. The `\autocites` version becomes nearly unreadable
   in the `.tex` source; the `\citemsp` version remains scannable.

4. **Rendered output comparison** — standard biblatex postnotes append locator text
   after the citation number inside the brackets (e.g., `[1, §6.1]`), consuming
   horizontal space. citemsp renders locators as superscript/subscript pairs, which
   are visually compact and don't widen the citation bracket.

**Action — CTAN doc:** Fill in the commented-out comparison table at lines 216-242 of
`ctemsp-doc.tex` with the same material.

#### 1.1.6 Expand the built-in prefix registry (v3 locators)

Add case-sensitive single-letter prefixes for common mathematical/scientific structure
types. This requires **no parser changes** — the existing single-character dispatch
handles uppercase letters identically to lowercase.

**New built-in prefixes to add to `citemsp.sty`:**

| Prefix | Type | Renders as | Registration |
|--------|------|-----------|--------------|
| `T` | Theorem | Thm. | `\citemspprefix{T}{Thm.}` |
| `L` | Lemma | Lem. | `\citemspprefix{L}{Lem.}` |
| `C` | Corollary | Cor. | `\citemspprefix{C}{Cor.}` |
| `R` | Proposition | Prop. | `\citemspprefix{R}{Prop.}` |
| `A` | Appendix | App. | `\citemspprefix{A}{App.}` |

Note: `P` is taken by the default ¶ (paragraph) behavior, so Proposition uses `R`
(from "pRoposition" — this is the weakest mapping and may need discussion).
Alternatively, since `P` as a *prefix letter* doesn't conflict with the default
paragraph slot behavior (which only triggers when no prefix is recognized), this
needs careful testing.

**Important design note:** The uppercase convention (T, L, C, etc.) naturally
separates the "structural element" prefixes from the "content container" prefixes
(b, d, e, f, n, p, t). This is a good convention to document.

**Action:** Add these prefixes to `citemsp.sty`, update the prefix table in both the
paper and CTAN doc, and add at least one example showing theorem/lemma usage.

---

### 1.2 Overleaf and Journal Compatibility Testing

#### 1.2.1 Overleaf testing

**Why this matters:** An estimated 60-70% of LaTeX users in academia write on Overleaf.
If citemsp doesn't work there out of the box, the majority of potential users are lost.

**Action:**
- Create a minimal Overleaf project that loads biblatex + citemsp
- Verify compilation with Overleaf's default TeX Live version
- Test with both `pdflatex` and `lualatex` engines
- Document any Overleaf-specific issues or workarounds

#### 1.2.2 Journal style compatibility

Test citemsp with the following major journal LaTeX templates:

| Template | Covers | Priority |
|----------|--------|----------|
| RevTeX 4.2 | APS journals (PRL, PRD, PRA, etc.) | High — largest physics audience |
| MNRAS (`mnras.cls`) | Monthly Notices of the Royal Astronomical Society | High — astrophysics |
| A&A (`aa.cls`) | Astronomy & Astrophysics | Medium |
| JHEP | Journal of High Energy Physics | Medium |
| Springer (`svjour3.cls`) | Various Springer journals | Medium |
| Elsevier (`elsarticle.cls`) | Elsevier journals | Medium |
| IOP (`iopart.cls`) | Institute of Physics journals | Medium |

**Key compatibility question:** Many of these templates use `natbib` rather than
`biblatex`. Since citemsp requires biblatex, it is **incompatible** with any template
that mandates natbib. This is the single biggest adoption blocker.

**Action:**
- For each template: attempt to compile a minimal document with biblatex + citemsp
- Record which templates work, which conflict, and what the error is
- If the conflict is natbib vs biblatex: document this as a known limitation
- Consider whether a natbib-compatible mode is feasible for a future version

**Deliverable:** A compatibility table in the README and CTAN doc.

#### 1.2.3 Create a public Overleaf template

**Why:** This is probably the single highest-ROI adoption action. It removes all
installation friction — users fork the template and start writing.

**Action:**
- Create a clean, realistic example document (not just a syntax demo — a short
  physics paper that *uses* citemsp naturally)
- Publish it to the Overleaf Gallery
- Link to it from the README, CTAN doc, and any TeX.SE answers

---

### 1.3 Publication Strategy

#### 1.3.1 arXiv preprint

**Category:** `cs.DL` (Digital Libraries) or `cs.OH` (Other), cross-listed to the
relevant physics category (e.g., `gr-qc`).

**Audience:** Physicists who browse arXiv daily and discover tools through preprints.

**Format:** Longer than JOSS, tutorial-style. Should include:
- Motivation (the verbosity problem, with concrete examples)
- Full syntax and prefix table
- The expanded comparison section (1.1.5 above)
- All current examples (single source, multiple, mixed, custom prefixes)
- At least one new example using the v3 theorem/lemma prefixes
- Implementation overview
- Conventions and best practices (including the paragraph disclaimer)

**The paper should NOT:**
- Claim to be a research contribution (it's a tool announcement)
- Be overly formal — physicists respond to practical, direct writing

**Current paper status:** Close to ready. Needs items 1.1.1–1.1.6 applied, then
one final editing pass.

#### 1.3.2 JOSS submission

**What is JOSS:** The Journal of Open Source Software publishes peer-reviewed short
papers about research software. The review focuses on software quality (not novelty).
It provides a citeable DOI.

**Why:** Career credit, institutional legitimacy, discoverability outside arXiv.

**JOSS allows simultaneous arXiv preprints** — this is standard practice and explicitly
permitted.

**JOSS paper format:** Not LaTeX — it's a `paper.md` (Markdown with YAML frontmatter).
Typically 1-2 pages of actual text. Content:
- Statement of need (why citemsp exists)
- Summary of functionality
- Comparison to existing tools
- Link to documentation
- Acknowledgements and references

**Repository requirements for JOSS acceptance:**

| Requirement | Current status | Action needed |
|-------------|---------------|---------------|
| Open-source license | LPPL 1.3c (present) | None |
| Installation docs | README + CTAN doc | None |
| Example usage | Present | None |
| Automated tests | **Missing** | Create a test `.tex` file that compiles; add a CI script (GitHub Actions) that runs `latexmk` and checks for zero errors |
| `CONTRIBUTING.md` | **Missing** | Write contribution guidelines |
| `paper.md` | **Missing** | Write JOSS paper in Markdown format |
| Community guidelines | **Missing** | Add issue templates, code of conduct |
| API documentation | CTAN doc covers this | None |

**Deliverables for JOSS:**
1. `paper/joss/paper.md` — the JOSS paper
2. `paper/joss/paper.bib` — references for the JOSS paper
3. `.github/workflows/test.yml` — CI that compiles the example document
4. `CONTRIBUTING.md` — contribution guidelines
5. `tests/test-basic.tex` — minimal document exercising all features

#### 1.3.3 TeX StackExchange presence

**Strategy:** Find existing questions about per-key locators, section-specific
citations, or biblatex postnote limitations. Answer them with citemsp. This is where
LaTeX users discover new packages — not through CTAN announcements.

**Example questions to target:**
- "How to cite specific section of a reference in biblatex?"
- "Compact multi-source citations with locators"
- "Superscript locators on citation numbers"

**Important:** Answers must be genuinely helpful, not promotional. Show the solution,
mention citemsp is on CTAN, link to the docs. Let the tool speak for itself.

---

### 1.4 Future Considerations (not in scope for Phase 1)

- **natbib compatibility mode:** Would dramatically expand the addressable audience
  but requires significant engineering (natbib's cite machinery is fundamentally
  different from biblatex's). Consider for v4+.
- **Author-year style support:** Currently only numeric styles work. Author-year
  rendering with superscript/subscript locators is visually more complex
  (e.g., `[Wald, 1984]^{§3.2}`) and needs design thought.
- **Multi-character prefix dispatch:** The current single-character dispatch covers
  most use cases (especially with uppercase letters). True multi-character prefixes
  (`thm`, `def`, `lem`) would require parser changes. Defer unless user demand
  materializes.

---

## Phase 2 — citewhy: Writer/Collaborator-Facing Citation Intent

### 2.1 Problem Statement

`citemsp` tells the reader *where* in a source to look. It does not tell collaborators
*why* the citation is there. In multi-author papers, the recurring question is: "why
did you cite this here?" Reviewers and co-authors waste time determining whether a
reference supports, contradicts, extends, or merely contextualizes a claim.

No existing LaTeX package addresses citation intent at the document level. biblatex's
`\textcite`, `\parencite`, etc. control *formatting*, not *semantics*. The CiTO
ontology (Citation Typing Ontology) defines citation intent categories for metadata
systems, but no authoring tool implements them.

### 2.2 Design Decisions

#### 2.2.1 Standalone with optional citemsp integration

`citewhy` is an **independent package** that optionally integrates with `citemsp`.

- If `citemsp` is loaded: `\citewhy` passes key+locators through `\citemsp` internally
- If `citemsp` is not loaded: `\citewhy` falls back to `\cite`

This doubles the potential user base. The detection is a single
`\@ifpackageloaded{citemsp}` check.

```latex
% With citemsp loaded:
\citewhy[supports]{wald1984/3.2/e4.3}
% → renders via \citemsp{wald1984/3.2/e4.3} + margin annotation

% Without citemsp:
\citewhy[supports]{wald1984}
% → renders via \cite{wald1984} + margin annotation
```

#### 2.2.2 Draft/final mode

**Default behavior:** Respect the document class option.

| Document class | citewhy behavior |
|---------------|-----------------|
| `\documentclass[draft]{article}` | Show margin annotations |
| `\documentclass[final]{article}` | Hide all annotations |
| `\documentclass{article}` (no option) | Show annotations (draft is default) |

**Package-level override:**

```latex
\usepackage[final]{citewhy}   % force-hide annotations regardless of doc class
\usepackage[draft]{citewhy}   % force-show annotations regardless of doc class
```

**Implementation:** Use a boolean `\if@citewhy@showintents` set at load time by
checking `\ifclassloaded` options and package options. The `\citewhy` command checks
this boolean before emitting margin notes.

#### 2.2.3 Intent taxonomy (v1 — 6 built-in intents)

These six intents are chosen to be **maximally distinct** and to map directly to
the questions collaborators actually ask about citations:

| Tag | Symbol | Collaborator question it answers | Description |
|-----|--------|----------------------------------|-------------|
| `supports` | `✓` (checkmark) | "Does this back up our claim?" | Reference supports or corroborates |
| `contradicts` | `✗` (ballot x) | "Doesn't this disagree with us?" | Reference contradicts or corrects |
| `extends` | `→` (right arrow) | "Are we building on this?" | This work extends or generalizes |
| `uses` | `⊢` (turnstile) | "Do we use a result/method from here?" | Specific result, method, or notation adopted |
| `context` | `◇` (diamond) | "Is this just background?" | Background, review, or motivation |
| `compares` | `↔` (double arrow) | "Are we comparing to their approach?" | Compared against, different approach |

**Why these six and not nine:**
- `derives` merged into `supports` or `uses` — the distinction is too subtle in practice
- `formalizes` and `notation-from` merged into `uses` — both mean "we adopted something"
- `motivates` and `reviews` merged into `context` — both are "background" citations

**Extensibility:** Users register custom intents via `\citewhyintent{tag}{symbol}{description}`.

#### 2.2.4 `\printcitationintents` behavior

- **Draft mode (default):** Prints a full intent map, suitable as a review appendix:

  ```
  Citation Intent Map
  ───────────────────
  Supports:      [1] Wald §3.2, [4] Hawking §1, [7] Penrose
  Contradicts:   [2] Rovelli §4
  Extends:       [3] Ghilencea, [9] Ashtekar §5.1
  Uses:          [5] Noether, [8] Olver §2.1
  Context:       [6] Weinberg
  ```

- **Final mode (default):** Produces nothing. Can be overridden with:
  ```latex
  \usepackage[final, showmap]{citewhy}   % final mode but still print the map
  ```

#### 2.2.5 Rendering details

**Margin annotations (draft mode):**
- Small, muted color (MidnightBlue by default)
- Shows intent symbol + short description
- Uses `\marginnote` from the `marginnote` package (better positioning than `\marginpar`)
- Font size: `\scriptsize`
- Does not alter the inline citation rendering at all

**Optional inline mode (opt-in):**
```latex
\usepackage[inline]{citewhy}
```
This adds a tiny superscript intent symbol directly on the citation: `[1^{§3.2}]^✓`.
Off by default because it gets visually noisy with many citations.

#### 2.2.6 Structured metadata output (v2 preparation)

Not implemented in v1, but the architecture should support it.

**Current design:** `\@citewhy@record{intent}{key}` accumulates citation-intent pairs
in memory using etoolbox list macros.

**v2 extension point:** At `\AtEndDocument`, write accumulated data to a `.citewhy`
auxiliary file in a structured format (one line per record):

```
\citewhyentry{supports}{wald1984}{3.2}{e4.3}
\citewhyentry{contradicts}{rovelli2004}{4}{}
```

This feeds into CiTO-compatible workflows and could be consumed by publishers or
metadata tools. The key architectural decision for v1 is: **do not discard the
accumulated data** — keep `\@citewhy@record` writing to expandable lists that can
be iterated at end-of-document.

---

### 2.3 Implementation Plan

#### 2.3.1 Package file: `citewhy.sty`

```
citewhy.sty — approximately 120-150 lines, structured as:

1. Package declaration and options (draft/final/inline/showmap)
2. Dependencies: biblatex (optional), marginnote, etoolbox, xcolor
3. Intent registry (\citewhyintent + 6 built-ins)
4. Intent storage (\@citewhy@record using \csgdef/\csgappto)
5. Main command (\citewhy with citemsp detection and fallback)
6. Margin rendering (conditional on draft mode)
7. \printcitationintents command (iterates all intents, prints grouped lists)
```

#### 2.3.2 Core command interface

```latex
% Default intent is "uses" if omitted
\citewhy[supports]{wald1984/3.2/e4.3}
\citewhy{wald1984}                        % defaults to [uses]

% Multiple citations with same intent
\citewhy[extends]{ghilencea2024, ashtekar2004/5.1}

% Register custom intent
\citewhyintent{refutes}{\ensuremath{\lightning}}{refutes}
\citewhy[refutes]{rovelli2004/4}

% Print the intent map (typically at end of document, before \printbibliography)
\printcitationintents
```

#### 2.3.3 Dependencies

| Package | Purpose | Required? |
|---------|---------|-----------|
| `biblatex` | Citation backend | Yes (for `\cite` fallback) |
| `citemsp` | Enhanced locator rendering | Optional (auto-detected) |
| `marginnote` | Margin annotations | Yes |
| `etoolbox` | List macros for intent storage | Yes (already loaded by biblatex) |
| `xcolor` | Colored annotations | Yes |

#### 2.3.4 Key implementation details

**citemsp detection and fallback:**

```latex
\AtBeginDocument{%
  \@ifpackageloaded{citemsp}{%
    \def\@citewhy@cite#1{\citemsp{#1}}%
  }{%
    \def\@citewhy@cite#1{\cite{#1}}%
    % When falling back to \cite, strip any /loc1/loc2 from the key
    % so \citewhy[supports]{wald1984/3.2} doesn't pass "wald1984/3.2" to \cite
  }%
}
```

**Important edge case:** If citemsp is NOT loaded but the user writes
`\citewhy[supports]{wald1984/3.2}`, the fallback must strip the `/3.2` before
passing to `\cite`. This requires parsing the key to extract everything before
the first `/`.

**Margin note positioning:** `\marginnote` can conflict with two-column layouts.
Test with `twocolumn` document class option and with RevTeX two-column. If margins
are too narrow, fall back to `\footnote`-style rendering or suppress with a warning.

---

### 2.4 Publication Strategy

#### 2.4.1 Separate arXiv preprint

**Positioning:** "First document-level implementation of citation intent annotation
in LaTeX."

**Key references to cite:**
- Shotton, D. (2010). CiTO, the Citation Typing Ontology. *Journal of Biomedical
  Semantics*, 1(S1), S6. — The foundational ontology for citation intent
- Teufel, S., Siddharthan, A., & Tidhar, D. (2006). Automatic classification of
  citation function. — Citation function classification in NLP
- JATS XML citation typing — structured metadata standards

**Structure:**
1. Motivation (the "why did you cite this?" problem in collaborative writing)
2. Relation to CiTO and existing work
3. Package usage and intent taxonomy
4. `\printcitationintents` — the intent map
5. Integration with citemsp
6. Implementation overview
7. Future work (structured metadata output, publisher integration)

#### 2.4.2 Separate CTAN submission

Submitted as a companion package to citemsp. Cross-referenced in both packages'
documentation. The CTAN doc should be self-contained (not require reading the
citemsp docs to understand citewhy).

#### 2.4.3 Possible journal submission

If expanded with a user study or formal comparison to CiTO-based workflows, this
could target:
- PeerJ Computer Science
- Journal of Biomedical Semantics (where CiTO was published)
- Quantitative Science Studies (scientometrics)

This is optional and depends on whether the co-authors want to invest in a user
study. The arXiv + CTAN route is sufficient for initial release.

---

### 2.5 Future Considerations (not in scope for Phase 2 v1)

- **Structured `.citewhy` output file** — write intent data to an auxiliary file
  for external tool consumption (v2)
- **CiTO-compatible export** — map internal intent tags to CiTO ontology URIs (v2)
- **Integration with collaborative platforms** — Overleaf commenting integration,
  though this likely requires Overleaf-side support
- **AI-assisted intent suggestion** — given the rise of LLM-assisted writing tools,
  a future version could suggest intent tags based on citation context. Out of scope
  but worth noting as a direction.

---

## Sequencing and Dependencies

```
Phase 1 (immediate)
  ├── 1.1 Package fixes (1.1.1–1.1.6)
  ├── 1.2 Overleaf + journal testing
  ├── 1.3.1 arXiv submission (after 1.1 fixes applied)
  ├── 1.3.2 JOSS submission (after CI + tests + paper.md written)
  └── 1.3.3 TeX.SE presence (ongoing, after CTAN acceptance)

Phase 2 (after Phase 1 arXiv + CTAN submissions are done)
  ├── 2.3 Implementation of citewhy.sty
  ├── 2.4.1 arXiv preprint for citewhy
  └── 2.4.2 CTAN submission for citewhy

Ongoing
  ├── 1.2.3 Overleaf template (can happen any time after 1.1)
  └── 1.3.3 TeX.SE engagement
```

---

## Open Questions

These decisions are flagged for discussion before implementation begins:

1. **Proposition prefix letter:** `R` for Proposition (from "pRoposition") is
   awkward. Alternatives: use `P` (test whether it conflicts with paragraph
   default), or skip Proposition as a built-in and let users register it.

2. **natbib compatibility:** Is this worth investigating for citemsp v4, or is
   biblatex-only acceptable for the foreseeable future?

3. **citewhy default intent:** The current sketch defaults to `uses` when no
   intent is specified. Is this the right default, or should it be `context`
   (the least committal option)?

4. **Margin note vs footnote fallback:** In narrow-margin templates (RevTeX
   two-column), should citewhy fall back to footnotes, inline annotations,
   or just suppress with a warning?

5. **Co-author contributions:** Mariotti and Sherrill are contributing — which
   parts of Phase 1 / Phase 2 are they responsible for? This affects the
   timeline and task distribution.
