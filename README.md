# citemsp — Citation Locators for LaTeX

A LaTeX package extending `biblatex` with per-key citation locators rendered as compact superscript/subscript pairs on numeric citation labels.

## Quick start

```latex
\usepackage[style=numeric, backend=biber]{biblatex}
\usepackage{citemsp}
```

```latex
\citemsp{wald1984/6.1/2}          % [1] with §6.1 (super) and ¶2 (sub)
\citemsp{wald1984/3.2/e4.3}       % [1] with §3.2 (super) and eq.4.3 (sub)
\citemsp{mtw1973/b21.1}           % [2] with □21.1 (sub)
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

Custom prefixes can be registered with `\citemspprefix{letter}{label}`.

## License

LPPL 1.3c — see [LICENSE](LICENSE).
