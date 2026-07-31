---
type: agent-instruction
title: "AGENTS: Repository Operating Contract"
description: "Operating contract for AI coding tools working in this clinical research analysis repository."
status: active
version: "1.1"
review_owner: BERD AI Pilot Team
last_updated: 2026-07-31
---

# AGENTS.md: Repository Operating Contract

This file is the authoritative operating contract for any AI coding tool working in
this repository (GitHub Copilot, Claude Code, or equivalent). Read it at the start of
every session.

## Read First

At session start, read in this order (see `standards/session-start.md` for the full
procedure):

1. This file.
2. `README.md`.
3. The top entry of `SESSION_LOG.md`.
4. Any standard in `standards/` relevant to the current task. Key standards:
   - `standards/data-handling.md` — data, PHI, and prompt hygiene
   - `standards/r-quarto-tutorial-authoring.md` — workflow for creating R scripts and Quarto tutorials
   - `standards/standards-r-quarto-teaching-materials.md` — quality requirements for teaching materials

## Repository Purpose

This repository contains analysis code, documentation, and simulated-data generation scripts for a CRP 241 introductory clinical research methods course. The teaching case is built around the IVAM-ED randomized clinical trial, which evaluated a voice-activated virtual assistant (Amazon Echo Dot) for mental health promotion and diabetes self-management in 112 older adults with type 2 diabetes (Matzenbacher et al., *JAMA Network Open*, 2026). The primary language is **R**, with analysis documents written in Quarto and the package environment managed with renv. All exercises use a synthetic dataset that approximates the published trial's sample characteristics; no real participant data are stored in this repository.

## Pilot Tier and Data Posture

**Tier 2** — GitHub Copilot Business; synthetic or non-sensitive data only; GitHub remote.

Data rule: This repository contains code and documentation only. The synthetic dataset generated for exercises lives in `data/` (gitignored) and is never committed. No real participant data, PHI, or identifiable information is used at any tier of this project.

The full tier definitions and rationale are in `standards/data-handling.md`.

## Operating Rules

**You may do without asking:**

- Read any file in the repository.
- Write, edit, and refactor analysis code and documentation.
- Run non-destructive local commands: rendering, linting, tests, `git status`, `git diff`.
- Update `SESSION_LOG.md`, `README.md`, and other documentation to reflect completed work.

**Ask before:**

- Any `git commit` or `git push`.
- Installing or updating packages or changing dependency manifests.
- Deleting or moving files the user created.
- Any command that sends repository content to an external service beyond the
  configured AI endpoint.
- Modifying anything in `standards/` (these are shared team standards; changes belong
  upstream in the pilot repository).

**Never:**

- Stage, commit, or transmit data files, in any format, for any reason. The
  `.gitignore` data excludes are a floor, not a ceiling; check `git status` output
  before proposing any commit.
- Echo, print, or quote actual data values into chat responses, code comments,
  generated documentation, or commit messages. Refer to data by structure (column
  names, types, dimensions), never by content.
- Write secrets, API keys, tokens, or connection strings into any file that is not
  gitignored.
- Weaken the `.gitignore` data excludes.

## Data and Prompt Hygiene

The governing behavioral rule from the pilot governance framework: **never paste or
inject data values into a model prompt.** As an agent you enforce your side of this:
when the user asks you to inspect data, work from structure (`str()`, `names()`,
`dim()`, column types) rather than value listings wherever possible, and do not
reproduce data values in your output. If a task genuinely requires viewing values,
say so and let the user decide how to proceed outside the AI channel.

See `standards/data-handling.md` for the tier definitions, approved storage
locations, and the code-up/data-never-down asymmetry between tiers.

## Local Tooling and Terminal Approval

Running R, Python, Quarto, or SAS from the terminal will likely prompt for approval
the first time in a session in both GitHub Copilot agent mode and Claude Code. This
is expected: the approval gate governs *running an unapproved terminal command*, not
whether the target program lives inside or outside the project folder. Installing R
in a project-local `renv` library does not change whether `Rscript` triggers an
approval prompt; it changes whether the project is protected from a system R update
silently breaking analysis code. If repeated prompts for routine commands (a render,
a script run) feel disruptive, allow-list those specific commands in your tool's
settings rather than broadly auto-approving all terminal execution, and keep
destructive commands (package installs, `git push`, deletes) on the ask-first list.

Environment isolation differs by language, and the difference matters here:

- **R:** Use `renv` (`renv::init()`, committed `renv.lock`) to isolate the package
  library per project. This does not pin the R interpreter version; `rig` (the R
  installation manager) is the tool for that if exact-version reproducibility is
  needed.
- **Python:** Use a project-local virtual environment with a committed manifest.
- **SAS:** There is no project-local install. Record the SAS version and environment
  (local desktop SAS, a Duke-provisioned SAS server, or SAS OnDemand/Viya) in the
  README's Environment section, since it cannot be pinned by a lockfile. If SAS runs
  on a remote server, that is the same remote-execution pattern as the pilot's
  Tier 1B, not a local terminal command.

## Session Logging

Every substantive work session ends with a new entry prepended to `SESSION_LOG.md`,
following the format in `standards/repo-baseline.md`: date, status, files changed, a
2-to-5-sentence summary, decisions made, and next steps. Use
`standards/session-wrap-up.md` for the full closeout procedure.

## Verification Commands

```bash
# Confirm the package library matches the lockfile
Rscript -e 'renv::status()'

# Render a Quarto document
quarto render R/01-data-setup.qmd

# Check git status before any commit — confirm no data files are staged
git status
```

> **Note:** `renv` has not yet been initialized. Until the user runs `renv::init()` and commits `renv.lock`, use `Rscript -e 'sessionInfo()'` to verify R is available.

## Security

Security findings and audit history live in `SECURITY.md`. Audits follow
`standards/security-audit.md`. Log any security-relevant change as a new audit-log
entry rather than editing an old one.
