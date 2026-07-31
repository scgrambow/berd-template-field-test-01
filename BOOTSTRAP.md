---
type: strategy
subtype: skill-prompt
title: "Repository Bootstrap"
description: "Seed prompt directing an AI agent to interview the user, inspect existing files, and scaffold a clinical research analysis repository."
status: active
version: "1.1"
review_owner: BERD AI Pilot Team
last_updated: 2026-07-10
---

# BOOTSTRAP: Set Up This Repository

You are an AI coding agent. The user has copied this kit into a project folder and
asked you to set it up. Follow this file top to bottom. Do not skip the interview,
and do not invent answers the user has not given.

## Step 0: Read the Ground Rules First

Before doing anything else, read these files in the current folder:

1. `AGENTS.md` (the operating contract you will follow in this repository)
2. `standards/repo-baseline.md` (specification for the files you will generate)
3. `standards/data-handling.md` (data, PHI, and prompt hygiene rules)

Two rules apply during bootstrap and forever after:

- **Never commit, stage, or suggest committing data files.** If you find data files
  in the folder, leave them where they are and make sure the `.gitignore` covers them.
- **Never move, delete, or overwrite existing user files without asking.** Bootstrap
  builds around what exists; it does not reorganize it.

## Step 1: Inventory What Already Exists

List the files and folders already present (ignore this kit's own files:
`BOOTSTRAP.md`, `AGENTS.md`, `standards/`). Classify what you find:

- **Empty or kit-only folder:** this is a fresh project; you will generate the full layout.
- **Existing code** (`.R`, `.qmd`, `.Rmd`, `.py`, `.ipynb`, `.sas`): note the languages
  and apparent structure; you will scaffold around it and propose (not perform) moves.
- **Existing data files** (`.csv`, `.rds`, `.RData`, `.sas7bdat`, `.xlsx`, `.dta`, or a
  data directory): flag these to the user in Step 2 and confirm they are covered by
  `.gitignore` before any git operation ever happens.
- **Existing git repository:** check `git status`; do not initialize over it.
- **Existing README, log, or security files:** you will update rather than replace,
  and you will show the user the proposed changes first.

## Step 2: Interview the User

Ask these questions before generating anything. Ask them together as one short list,
then wait for answers. If the user already answered some in their opening message,
skip those.

1. **Project name and one-sentence purpose.** Used in the README and session log.
2. **Primary language(s).** R, Python, both, or other. Determines folder layout and
   `.gitignore` content.
3. **Pilot tier.** Which BERD pilot tier does this work fall under? (See
   `standards/data-handling.md` for definitions.)
   - Tier 1A: local VS Code + Duke Azure OpenAI private endpoint, PHI-adjacent
   - Tier 1B: Remote SSH to a Duke-provisioned VM, PHI execution on the VM
   - Tier 2: GitHub Copilot Business, synthetic or non-sensitive data only
   - Not sure: default to the strictest interpretation (treat as Tier 1A rules)
4. **Data sensitivity.** Will this project touch real study data (PHI or identifiable),
   de-identified data, or only synthetic/simulated/public data?
5. **Git remote (if any).** Duke GitLab, GitHub under the Duke EMU account, or no
   remote yet. Per the governance framework, Duke GitLab is preferred for Tier 1A/1B
   work; GitHub EMU private repositories are appropriate for Tier 2.
6. **Environment management.** For R, initialize `renv` now unless the user declines
   (see Step 3i; this isolates the package library from the system R installation).
   For Python, is there an existing virtual environment or manifest? For SAS, there is
   no project-local install; ask for the SAS version and environment instead (local
   desktop SAS, a Duke-provisioned SAS server, or SAS OnDemand/Viya) so it can be
   recorded in the README, since it cannot be pinned by a lockfile.

## Step 3: Generate the Repository Structure

Using the interview answers and the specifications in `standards/repo-baseline.md`,
generate the following. Create only what is missing; update rather than replace
anything that exists.

### 3a. Folder layout

For an R project (adapt for Python or mixed: use `src/` instead of or alongside `R/`):

```text
project-root/
├── README.md
├── AGENTS.md            (from the kit; you will fill in its placeholders)
├── BOOTSTRAP.md         (this file; leave in place)
├── SESSION_LOG.md
├── SECURITY.md
├── .gitignore
├── standards/           (from the kit; leave in place)
├── R/                   Analysis code
├── data/                Local-only data staging; never committed
│   └── README.md        One-paragraph warning that contents must never be committed
├── output/              Generated tables, figures, rendered documents
└── docs/                Protocols, notes, documentation
```

### 3b. `.gitignore`

Always exclude, regardless of interview answers:

```gitignore
# Data files: never committed, per standards/data-handling.md
data/
*.csv
*.rds
*.RData
*.Rdata
*.sas7bdat
*.xlsx
*.xls
*.dta
*.parquet
*.feather

# Credentials and environment
.env
.Renviron
*.pem
*_key*

# Output that may embed data values
output/

# R clutter
.Rhistory
.RData
.Rproj.user/
renv/library/
renv/staging/

# Python clutter
__pycache__/
.venv/
venv/
.ipynb_checkpoints/

# OS clutter
.DS_Store
Thumbs.db
```

Trim the language sections that do not apply. If the user needs a specific data file
committed (for example, a small public lookup table), they can force-add it
deliberately with `git add -f`; do not weaken the default excludes.

### 3c. `README.md`

Follow the README specification in `standards/repo-baseline.md`. Include the project
purpose from the interview, the folder structure, the pilot tier and its data rules
(one short paragraph, pointing to `standards/data-handling.md`), and how to reproduce
the environment (`renv::restore()`, `pip install -r requirements.txt`, or equivalent).

### 3d. `SESSION_LOG.md`

Create it using the template in `standards/repo-baseline.md`, and write the bootstrap
itself as the first entry: date, files created, interview decisions (tier, data
sensitivity, remote), and next steps.

### 3e. `SECURITY.md`

Create it using the template in `standards/repo-baseline.md`. Record the bootstrap as
the first audit-log entry: state the declared tier, the data posture from the
interview, that the `.gitignore` data excludes are in place, and whether any data
files were found in the folder during Step 1.

### 3f. Fill in `AGENTS.md`

`AGENTS.md` ships with placeholder sections marked `<!-- BOOTSTRAP: ... -->`. Fill in
the repository purpose, the declared tier, and the verification commands appropriate
to the language (for example `Rscript -e 'renv::status()'`, lint or test commands).
Remove the placeholder comments when done.

### 3g. Tool pointer files (optional)

If the user's tool does not read `AGENTS.md` natively, create a short pointer file
and nothing more:

- `CLAUDE.md` or `.github/copilot-instructions.md` containing:
  "Read `AGENTS.md` first. It is the authoritative operating contract for this repository."

### 3h. Git initialization

If the folder is not a git repository and the user wants one, run `git init`, confirm
`.gitignore` is in place **before** the first add, and propose (do not run without
confirmation) the first commit containing only the scaffolded files. Verify with
`git status` that no data files are staged.

### 3i. Local Tooling Setup

Configure the language environment based on the Step 2 interview answer, and record
the result in the generated `README.md` under a short "Environment" section.

- **R:** Unless the user declined, run `renv::init()` (ask for confirmation before
  running it, per the operating rules) so the project gets its own package library
  and lockfile (`renv.lock`), isolated from the system R installation. This protects
  the project when the system R or its packages update. It does not pin the R
  interpreter version itself; if exact-version reproducibility of R matters (for
  example, work feeding a manuscript or regulatory submission), note in the README
  that `rig` (the R installation manager) is the tool for pinning the interpreter
  version, but do not install it automatically.
- **Python:** Set up or confirm a project-local virtual environment and a manifest
  (`requirements.txt` or `pyproject.toml`); do not rely on a global or conda base
  environment.
- **SAS:** There is no project-local install for SAS. Record the SAS version and
  environment (local desktop SAS, a Duke-provisioned SAS server, or SAS
  OnDemand/Viya) as a plain statement in the README's Environment section, since it
  cannot be pinned by a lockfile the way R and Python dependencies can. If SAS runs
  on a remote server rather than the local machine, note that this is the same
  remote-execution pattern as the pilot's Tier 1B (VS Code Remote SSH to a
  provisioned VM), not a local terminal command.

**Regardless of language**, tell the user in the closing report (Step 4) that
running R, Python, Quarto, or SAS from the terminal will likely prompt for approval
the first time in a session, whether or not the interpreter lives inside the
project folder. This is expected behavior in both GitHub Copilot agent mode and
Claude Code: the approval gate governs *running an unapproved terminal command*, not
whether the target program is installed inside or outside the workspace folder.
Users who find repeated prompts disruptive should allow-list the specific safe,
repeated commands (`Rscript`, `quarto render`) in their tool's settings, while
leaving destructive commands (installs, `git push`, deletes) on the ask-first list.

## Step 4: Verify and Report

Run this checklist and show the results:

- [ ] All baseline files exist and follow `standards/repo-baseline.md`.
- [ ] `.gitignore` excludes every data format listed above; if data files exist in the
      folder, `git status` (when applicable) shows none of them as untracked-and-addable.
- [ ] `AGENTS.md` placeholders are filled in; no `<!-- BOOTSTRAP:` markers remain.
- [ ] `SESSION_LOG.md` first entry records the bootstrap and interview decisions.
- [ ] No existing user file was moved, deleted, or overwritten without confirmation.
- [ ] No secrets or credentials appear in any generated file.
- [ ] The README's Environment section records the language setup from Step 3i
      (`renv` status, Python virtual environment, or SAS version and environment).

Close with a short report: what was created, what was found and left untouched, the
declared tier and its one-line data rule, the environment setup from Step 3i, and
suggested next steps (typically: review the generated README, confirm `renv` or the
virtual environment, make the first commit, and allow-list frequently used render
commands if terminal approval prompts feel repetitive).

From the next session onward, use `standards/session-start.md` to open work sessions
and `standards/session-wrap-up.md` to close them.
