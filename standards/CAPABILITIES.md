---
type: environment-record
title: "Verified Capabilities"
description: "Records the verified versions of R, Quarto, Pandoc, and key packages for this repository. Update this file after any tool upgrade or environment change."
status: active
last_verified: 2026-07-31
---

# CAPABILITIES.md

Verified environment for this repository. Run the commands in the **How to verify** column to confirm your local environment matches before rendering or running analyses.

## Core Tools

| Tool | Verified version | How to verify |
|---|---|---|
| R | 4.6.1 | `Rscript -e 'R.version$version.string'` |
| Quarto | 1.10.18 | `quarto --version` |
| Pandoc | 3.10.0 | `quarto check` or `pandoc --version` |
| renv | 1.2.3 | `Rscript -e 'packageVersion("renv")'` |

## R Packages (key rendering dependencies)

All packages are managed by renv. The full list is in `renv.lock`.

| Package | Version in renv.lock | Role |
|---|---|---|
| knitr | 1.51 | Executes R code in Quarto documents |
| rmarkdown | 2.31 | Quarto HTML rendering support |
| yaml | 2.3.12 | Parses Quarto YAML front matter |
| dplyr | (in lockfile) | Data manipulation in exercises |
| labelled | (in lockfile) | Variable labels on the synthetic dataset |
| tibble | (in lockfile) | Tidy data frames |

## Rendering

```bash
# Restore the full package library from renv.lock
Rscript -e 'renv::restore()'

# Always render from the project root (renv .Rprofile activates the library there)
quarto render R/01-data-setup.qmd --to html
quarto render R/02-descriptive.qmd --to html

# Render all modules (once _quarto.yml is configured)
quarto render
```

**PDF rendering:** Not configured. A working LaTeX engine (TinyTeX or MacTeX) is required.
Install TinyTeX with `Rscript -e 'tinytex::install_tinytex()'` when PDF output is needed.
Record the installation date and version here when that step is taken.

## Output formats

| Format | Status | Notes |
|---|---|---|
| HTML | ✓ Verified | Primary review format for all modules |
| PDF | Not yet configured | Requires TinyTeX or system LaTeX |
| Word (.docx) | Not tested | Pandoc can produce .docx without LaTeX |

## Known issues

- `renv::status()` may show "out-of-sync" on a fresh clone until `renv::restore()` is run.
- The `yaml` package must be installed for Quarto to parse R chunk dependencies; it is included in `renv.lock`.
