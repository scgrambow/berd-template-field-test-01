# IVAM-ED CRP 241 Teaching Case

Analysis code, documentation, and simulated-data generation scripts for a CRP 241 introductory clinical research methods course. The teaching case is built around the IVAM-ED randomized clinical trial, which evaluated a voice-activated virtual assistant for mental health promotion and diabetes self-management in older adults with type 2 diabetes (Matzenbacher et al., *JAMA Network Open*, 2026).

## Purpose

This repository supports a sequence of CRP 241 course activities — from data structure and reproducibility through descriptive statistics, visualization, regression modeling, missing-data sensitivity analyses, and protocol-to-publication comparison. All analysis is performed on a synthetic dataset that approximates the sample sizes, distributions, and treatment effects reported in the published trial. No real participant data are stored here.

## Pilot Tier and Data Rules

**Tier 2** — GitHub Copilot Business; synthetic or non-sensitive data only.

The repository contains code, documentation, and configuration only. The synthetic dataset used for exercises is generated locally by scripts in `R/`; it is never committed. Output (rendered Quarto documents, tables, figures) is excluded by default. See [standards/data-handling.md](standards/data-handling.md) for the full data-handling and prompt-hygiene rules.

## Folder Structure

```text
.
├── README.md
├── AGENTS.md                  Agent operating contract
├── BOOTSTRAP.md               Repository initialization record
├── SESSION_LOG.md             Reverse-chronological work log
├── SECURITY.md                Security posture and audit log
├── .gitignore
├── standards/                 Shared BERD pilot standards (do not edit here)
│   ├── data-handling.md
│   ├── repo-baseline.md
│   ├── security-audit.md
│   ├── session-start.md
│   └── session-wrap-up.md
├── R/                         Analysis and simulation scripts
├── data/                      Local-only data staging — never committed
│   └── README.md
├── output/                    Generated tables, figures, rendered documents — excluded from git
├── docs/                      Protocols, notes, and documentation
│   └── extracted/             Markdown extractions of source PDFs and DOCX files
└── source/                    Original source documents (PDFs and DOCX — not committed as data)
```

## Source Documents

| File | Description |
|---|---|
| [docs/extracted/matzenbacher-2026-ivam-ed-results-paper.md](docs/extracted/matzenbacher-2026-ivam-ed-results-paper.md) | Primary results paper (JAMA Network Open, 2026) |
| [docs/extracted/da-costa-2024-ivam-ed-protocol-sap.md](docs/extracted/da-costa-2024-ivam-ed-protocol-sap.md) | Trial protocol and SAP (Trials, 2024) |
| [docs/extracted/matzenbacher-2026-supplement-1.md](docs/extracted/matzenbacher-2026-supplement-1.md) | JAMA supplement 1 — study protocol and SAP embedded in results paper |
| [docs/extracted/matzenbacher-2026-supplement-2.md](docs/extracted/matzenbacher-2026-supplement-2.md) | JAMA supplement 2 — supplemental online content |
| [docs/extracted/matzenbacher-2026-supplement-3.md](docs/extracted/matzenbacher-2026-supplement-3.md) | JAMA supplement 3 — data sharing statement |
| [docs/extracted/da-costa-2024-supplement-1.md](docs/extracted/da-costa-2024-supplement-1.md) | Trials supplementary material |
| [source/paper-case-study-description.md](source/paper-case-study-description.md) | Case study rationale and planned CRP 241 activity sequence |

## Getting Started / Reproducing the Environment

This project uses R with [renv](https://rstudio.github.io/renv/) for package isolation.

```r
# After cloning, restore the package library
renv::restore()
```

> **Note:** `renv` has not yet been initialized in this repository. Run `renv::init()` to create the lockfile, then commit `renv.lock` and the `renv/` folder (excluding `renv/library/` and `renv/staging/`, which are already gitignored).

Data for exercises is generated locally by running the simulation script (to be created in `R/`). The simulated dataset lives in `data/` and is never committed.

## Contributing / Conventions

- Naming: lowercase kebab-case for files (`01-data-setup.qmd`, `02-descriptive.qmd`).
- Every substantive work session ends with a new entry prepended to `SESSION_LOG.md`. Use [standards/session-wrap-up.md](standards/session-wrap-up.md).
- Start each session by reading the top entry of `SESSION_LOG.md`. Use [standards/session-start.md](standards/session-start.md).

## File Reference

| File | Purpose | When to reach for it |
|---|---|---|
| `AGENTS.md` | Agent operating contract | Start of every AI session |
| `SESSION_LOG.md` | Work history (newest entry first) | Before starting any task |
| `SECURITY.md` | Security posture and audit log | Before any git operation or dependency change |
| `standards/data-handling.md` | Data, PHI, and prompt hygiene rules | When handling data or output |
| `standards/session-start.md` | Session start procedure | Beginning of every session |
| `standards/session-wrap-up.md` | Session wrap-up procedure | End of every session |
