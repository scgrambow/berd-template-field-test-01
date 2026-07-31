---
type: standard
title: "Repository Baseline Files"
description: "Specification for the baseline files every analysis repository carries: README.md, AGENTS.md, SESSION_LOG.md, and SECURITY.md."
status: active
version: "1.0"
review_owner: BERD AI Pilot Team
last_updated: 2026-07-08
---

# STANDARD: Repository Baseline Files

Every repository built from this kit contains four baseline files before
project-specific work begins. These files provide human orientation, agent operating
rules, institutional memory, and security accountability. `BOOTSTRAP.md` generates
them; this standard defines what they must contain.

## When to Apply

At repository initialization, before committing the first substantive project file.
If a repository already exists without these files, add them retroactively and log
the addition in the session log.

## File 1: README.md

### Purpose

Human and agent orientation. The first file anyone reads. It answers what the
repository is, what it is not, how it is organized, and how to use it.

### Required Sections

1. **Purpose:** What this project is for, the analytical goal, and the primary
   language(s).
2. **Pilot Tier and Data Rules:** The declared tier and a one-paragraph summary of
   the data rules, pointing to `standards/data-handling.md`.
3. **Folder Structure:** A fenced code block with a tree diagram.
4. **Getting Started / Reproducing the Environment:** How to restore the environment
   (`renv::restore()`, `pip install -r requirements.txt`, or equivalent) and where
   data is expected to live (an approved storage location, never the repo).
5. **Contributing / Conventions:** Naming conventions and session-logging expectation.

### Format Rules

- Single H1 as the title.
- A File Reference table (File, Purpose, When to reach for it) once the repository
  has five or more meaningful files.
- No bare URLs; use Markdown links.

## File 2: AGENTS.md

### Purpose

Agent operating contract. Tells AI tools what to read first, what is authoritative,
what work can proceed autonomously, and what must never happen. The kit ships a
pre-written `AGENTS.md`; bootstrap fills in its placeholders rather than generating
it from scratch.

### Format Rules

- GitHub Copilot and Claude Code read `AGENTS.md` natively. When a tool needs its own
  file, keep it as a short pointer:

```markdown
# CLAUDE.md

Read `AGENTS.md` first. It is the authoritative operating contract for this repository.
```

- Do not maintain divergent copies. If both `AGENTS.md` and a tool-specific file
  exist, the tool-specific file must be a pointer.
- No hardcoded secrets, tokens, or credentials, ever.

### Required Sections

1. **Read First:** Files the agent reads at session start.
2. **Repository Purpose:** One paragraph naming the project.
3. **Pilot Tier and Data Posture:** The declared tier and its data rule.
4. **Operating Rules:** May-do, ask-first, and never lists.
5. **Session Logging:** Location and format.
6. **Verification Commands:** Local validation, render, lint, or test checks.

## File 3: SESSION_LOG.md

### Purpose

Institutional memory. Records discrete units of work in reverse chronological order.
The most recent entry is always at the top, so a reader who sees only the first entry
has the current state without loading the full history.

### Format Rules

- Title is `# SESSION LOG`, with a one-line project description below it.
- A `**Rule:**` block below the description states the prepend-at-top discipline.
  Copy it from the template verbatim.
- Entries are separated by `---` rules; headers use `## YYYY-MM-DD: Title`.
- Subsections within entries use `**Bold labels:**` only, never `###` headings.

### Required Entry Fields

- **Status:** `Completed`, `In Progress`, or `Deferred`.
- **Files changed:** Comma-separated list.
- **Summary:** 2 to 5 sentences; what was done and why.
- **Decisions Made:** Bullet list with rationale, or "No decisions requiring documentation."
- **Next Steps:** Bullet list of concrete actions, or "None."

### Template

```markdown
# SESSION LOG

[One-sentence description of the project.]

**Rule:** Read the top entry before every task. Prepend new entries at the top,
directly below this header block. Use `**Bold labels:**` for sub-sections (`Summary`,
`Decisions Made`, `Next Steps`); never use `### headings`. Entry headers use the
format `## YYYY-MM-DD: Title`.

---

## YYYY-MM-DD: [Short description of work completed]

**Status:** Completed

**Files changed:** `filename.R`, `filename.qmd`

**Summary:**
[2 to 5 sentences describing what was done and why.]

**Decisions Made:**

- [Decision with rationale.]

**Next Steps:**

- [Next action item.]
```

## File 4: SECURITY.md

### Purpose

Security accountability: the repository's security posture, audit history, and
accepted risks. For an analysis repository the recurring questions are narrow: are
there secrets in the history, are data files excluded, and is the dependency posture
known.

### Format Rules

- Title is `# Security`.
- Findings tables use columns: `#`, `Category`, `Finding`, `Severity`, `Status`, `Evidence`.
- Severity values: `Critical`, `High`, `Medium`, `Low`, `None`. Status values:
  `Open`, `Fixed`, `Accepted`, `Resolved`, `N/A`.
- Audit log entries are reverse chronological; log each security-relevant change as a
  new entry rather than editing an old one.

### Required Sections

1. **Data and Tier Posture:** The declared tier, where data lives, and confirmation
   that the repository is code-only.
2. **Audit Log:** One subsection per audit event, headed `### YYYY-MM-DD: Description`,
   containing auditor, scope, findings table, remediations, and accepted limitations.
3. **Audit Standard Reference:** Audits follow `standards/security-audit.md`.

### Template

```markdown
# Security

## Data and Tier Posture

- **Pilot tier:** [1A / 1B / 2]
- **Data location:** [Approved storage location; never this repository]
- **Repository contents:** Code, documentation, and configuration templates only.

---

## Audit Log

### YYYY-MM-DD: [Audit Description]

**Auditor:** [Name or tool]
**Scope:** [What was covered]

#### Findings

| # | Category | Finding | Severity | Status | Evidence |
|---|---|---|---|---|---|
| 1 | [Category] | [Finding] | [Severity] | [Status] | [Command, file, or line reference] |

#### Remediations Applied

- [Change with rationale, or "None required."]

#### Known Accepted Limitations

- **[Limitation]:** [Tradeoff, compensating control, and reopening condition.]

---

## Audit Standard Reference

Audits follow `standards/security-audit.md`.
```

## Environment Configuration

Repositories containing executable code must document local environment requirements:

- **Isolated environments:** R projects use `renv`; Python projects use a
  project-local virtual environment with a committed manifest (`requirements.txt` or
  `pyproject.toml`). Do not rely on global or conda base environments.
- **Manifest-scoped audits:** Dependency audits target the repository's own manifest,
  not the global tool environment.
- **Network caveats:** On managed Duke devices, corporate TLS inspection can affect
  package installs and audit tools. Record a blocked scan as blocked, with the exact
  error; do not disable workstation protection to make a scan pass.

## Baseline File Creation Order

1. `README.md`: orientation first; everything else references it.
2. `AGENTS.md`: fill in the kit copy's placeholders.
3. `SESSION_LOG.md`: create immediately and log the bootstrap as the first entry.
4. `SECURITY.md`: create at bootstrap with the tier posture and first audit entry.
