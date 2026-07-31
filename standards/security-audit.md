---
type: standard
title: "Repository Security Review"
description: "Lightweight security review procedure for analysis repositories: secrets, committed data, dependency posture, and logging."
status: active
version: "1.0"
review_owner: BERD AI Pilot Team
last_updated: 2026-07-08
---

# STANDARD: Repository Security Review

A right-sized security review for clinical research analysis repositories. The three
questions that matter most here: are there secrets in the repository or its history,
are data files excluded from version control, and is the dependency posture known.

## When to Apply

- At bootstrap (the first `SECURITY.md` entry).
- Before pushing a repository to a remote for the first time.
- After dependency changes or at a tier change (see `standards/data-handling.md`).
- Periodically for active projects; quarterly is a reasonable default.

## Check 1: Committed Data Files

Verify no data files are tracked or stageable.

```bash
# Anything tracked that looks like data?
git ls-files | grep -iE '\.(csv|rds|rdata|sas7bdat|xlsx?|dta|parquet|feather)$'

# Anything untracked that .gitignore fails to cover?
git status --short

# Confirm the data directory is ignored
git check-ignore -v data/ || echo "WARNING: data/ is not ignored"
```

Any hit on tracked data files is at least a High finding. If a data file was ever
committed, removing it from the working tree is not enough; it remains in git
history. Flag this for a human decision (history rewrite vs. repository
re-creation), especially if the repository has already been pushed.

## Check 2: Secrets

Scan for credentials in tracked files. Use a dedicated scanner when available:

```bash
trufflehog filesystem .   # if installed
```

Fallback when no scanner is installed:

```bash
git grep -inE '(api[_-]?key|token|secret|passw(or)?d|connection[_-]?string)' -- . \
  ':!*.md' ':!standards/*'
git ls-files | grep -E '^\.env|\.Renviron$|\.pem$'
```

Review hits manually; variable names alone are fine, literal values are findings. A
committed live credential is a Critical finding: rotate it immediately and record the
rotation in `SECURITY.md`.

## Check 3: Dependency Posture

Scope audits to the repository's own manifest.

- **R with `renv`:** confirm `renv.lock` is committed and current
  (`Rscript -e 'renv::status()'`).
- **Python:** `pip-audit -r requirements.txt` when available.
- **Multi-ecosystem or when installed:** `osv-scanner scan --recursive .`

If an audit tool is missing or blocked by the network, record the check as skipped
with the reason. A skipped check without a reason is an audit failure. Do not disable
workstation protection software to make a scan pass.

## Check 4: Repository Boundary

- Confirm the remote matches the tier guidance in `standards/data-handling.md`
  (Duke GitLab for Tier 1A/1B; GitHub EMU private for Tier 2): `git remote -v`.
- Confirm the repository is private.
- Review rendered output (`.html`, `.docx`, `.pdf`) for embedded data values before
  any such file is committed or shared; `output/` stays gitignored by default.
- If `.github/workflows/` exists: least-privilege `permissions:`, secrets via GitHub
  Secrets only, and pinned versions for third-party actions.

## Logging

Record every review, including clean ones, as a new Audit Log entry in `SECURITY.md`
using the findings-table format from `standards/repo-baseline.md`, and note the
review in `SESSION_LOG.md`. Accepted risks must state the tradeoff, the compensating
control, and the condition that would reopen the finding.
