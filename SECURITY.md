# Security

## Data and Tier Posture

- **Pilot tier:** Tier 2 (GitHub Copilot Business; synthetic or non-sensitive data only)
- **Data location:** Synthetic datasets generated locally by scripts in `R/`; never committed. No real participant data is used in this repository.
- **Repository contents:** Code, documentation, extracted source documents (open-access publications), and configuration templates only.

---

## Audit Log

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
