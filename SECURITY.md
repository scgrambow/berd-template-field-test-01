# Security

## Data and Tier Posture

- **Pilot tier:** Tier 2 (GitHub Copilot Business; synthetic or non-sensitive data only)
- **Data location:** Synthetic datasets generated locally by scripts in `R/`; never committed. No real participant data is used in this repository.
- **Repository contents:** Code, documentation, extracted source documents (open-access publications), and configuration templates only.

---

## Audit Log

### 2026-07-31: Pre-Public-Release Security Audit

**Auditor:** GitHub Copilot (automated scan)
**Scope:** Full repository scan before changing visibility from private to public

#### Findings

| # | Category | Finding | Severity | Status | Evidence |
|---|---|---|---|---|---|
| 1 | Credentials | Keyword scan (password, token, secret, api_key, bearer) matched only documentation files (BOOTSTRAP.md, AGENTS.md, SECURITY.md, standards/) — all occurrences are governance rules saying "never include credentials," not actual credentials | None | N/A | `grep -rI -i "password\|token\|secret"` across all tracked files |
| 2 | Data files | No CSV, RDS, RData, SAS, XLSX, DTA, or Parquet files found in working tree or git history | None | N/A | `git log --all --name-only` + `git ls-files` filtered for data extensions |
| 3 | PHI / identifiers | PHI keyword matches in R/ and .qmd files are all educational references (explaining what PHI is), not actual patient data | None | N/A | `grep -rI "patient name\|date of birth\|ssn\|mrn"` |
| 4 | .env / secret files | No .env, .pem, or *_key* files found anywhere in the working tree | None | N/A | `find . -name "*.env" -o -name "*.pem" -o -name "*_key*"` |
| 5 | Personal identifiers | GitHub username `scgrambow` and "Steve Grambow" (review_owner) appear in README, SESSION_LOG, _quarto.yml, standards, and rendered HTML | Low / Accepted | Accepted | `git ls-files \| xargs grep -lI sgrambow` — expected for a public academic repository |
| 6 | Source PDFs / DOCX | Six source documents in `source/` and `source/extracted/` are open-access publications under CC-BY 4.0 license — appropriate to distribute publicly | None | N/A | DOIs verified: 10.1001/jamanetworkopen.2025.53508 and 10.1186/s13063-024-08055-3 |
| 7 | Internal institutional info | SESSION_LOG.md references the BERD AI Pilot program (Tier 2, GitHub Copilot Business). This is process/governance documentation describing publicly available tooling, not internal infrastructure details | Low / Accepted | Accepted | SESSION_LOG.md reviewed in full |
| 8 | `.Rprofile` | Contains only `source("renv/activate.R")` — standard renv activation, no secrets | None | N/A | `cat .Rprofile` |
| 9 | GitHub Actions workflow | `.github/workflows/render-book.yml` uses `actions/checkout`, `r-lib/actions`, and `quarto-dev/quarto-actions` from official registries. No secrets, tokens, or external API calls | None | N/A | Workflow reviewed in full |
| 10 | `renv.lock` | Lists CRAN package names and versions; no proprietary packages, no secrets, no internal registry URLs | None | N/A | `renv.lock` reviewed |

#### Remediations Applied

- None required. Repository is clean for public release.

#### Verdict

**CLEAR FOR PUBLIC RELEASE.** No credentials, no data files (in working tree or history), no PHI, no internal infrastructure details. All source documents are open-access CC-BY. Personal identifiers are appropriate and expected for a public academic teaching repository.

#### Known Accepted Limitations

- **Personal identifiers:** The GitHub username `scgrambow` and name "Steve Grambow" in standards files will be publicly visible. This is intentional and appropriate for a public teaching repository.
- **BERD AI Pilot references:** The SESSION_LOG documents use of GitHub Copilot Business under the Duke BERD pilot program. This is disclosed governance documentation; the pilot program itself is not confidential.

---

### 2026-07-31: Bootstrap Security Audit

**Auditor:** GitHub Copilot (automated bootstrap)
**Scope:** Initial repository setup — gitignore coverage, credential exposure, data file presence, tier declaration

#### Findings

| # | Category | Finding | Severity | Status | Evidence |
|---|---|---|---|---|---|
| 1 | Data exclusion | `.gitignore` created with categorical exclusion of all standard data formats and the `data/` directory | None | N/A | `.gitignore` lines 1–10 |
| 2 | Credentials | No credentials, tokens, API keys, or secrets found in any file | None | N/A | Full file scan at bootstrap |
| 3 | Data files in repo | Source folder contains PDF and DOCX files that are open-access publications, not data files; no CSV, RDS, or other data formats present | None | N/A | `source/` directory listing |
| 4 | Output exclusion | `output/` directory excluded by `.gitignore` to prevent rendered documents embedding data values from being committed inadvertently | None | N/A | `.gitignore` line for `output/` |
| 5 | Tier declaration | Tier 2 declared; repository is on GitHub (appropriate for Tier 2); no PHI or real study data used | None | N/A | README.md, AGENTS.md |

#### Remediations Applied

- `.gitignore` created to exclude all data formats, `data/`, `output/`, credentials, and R/OS clutter.
- `data/README.md` created with an explicit warning that directory contents must never be committed.

#### Known Accepted Limitations

- **Source PDFs not gitignored:** The open-access publication PDFs in `source/` are not excluded by `.gitignore`. These are published papers under CC-BY licenses, not data files, and are appropriate to version-control. If this policy changes, add `source/*.pdf` and `source/*.docx` to `.gitignore`.
- **renv not yet initialized:** The R package library is not yet isolated. Until `renv::init()` is run and `renv.lock` is committed, the environment is not reproducible across machines. This is a reproducibility limitation, not a security finding; it does not affect data or credential safety.

---

*Audits follow [standards/security-audit.md](standards/security-audit.md).*
