---
type: standard
title: "Data Handling and Prompt Hygiene"
description: "Data, PHI, repository hygiene, and prompt hygiene rules for AI-assisted analysis repositories, mapped to the BERD pilot governance tiers."
status: active
version: "1.0"
review_owner: BERD AI Pilot Team
last_updated: 2026-07-08
---

# STANDARD: Data Handling and Prompt Hygiene

This standard translates the BERD AI Coding Pilot governance framework (v2,
2026-05-28) into operating rules for a single analysis repository. The framework is a
draft pending DHTS review; treat these rules as working policy and update this file
if the framework changes.

## The Tier Model

The pilot organizes AI-assisted coding into tiers. Every repository declares its tier
at bootstrap, and the tier determines the data rules.

| Tier | IDE | AI layer | Data permitted | Git remote |
| --- | --- | --- | --- | --- |
| **Tier 0** | RStudio | None | PHI (runtime only) | GitLab or GitHub (code only) |
| **Tier 1A** | VS Code (local) | Duke Azure OpenAI private endpoint | PHI-adjacent; no data values in prompts | Duke GitLab preferred |
| **Tier 1B** | VS Code Remote SSH to Duke VM | Duke Azure OpenAI private endpoint | PHI (execution on the VM) | Duke GitLab (internal network) |
| **Tier 2** | VS Code or Positron | GitHub Copilot Business | No PHI; synthetic or non-sensitive only | GitHub EMU private repos |

If the tier is unclear, apply Tier 1A rules until it is resolved.

## Rule 1: Data Never Enters the Repository

The repository contains code logic only: scripts, rendered-document sources,
configuration templates without secrets, and documentation. Data lives in a Duke
approved storage location (Duke Health Network Storage, REDCap exports to approved
storage, Duke OneDrive, Duke Box) and is read into memory at runtime.

- The `.gitignore` categorically excludes all data formats (`.csv`, `.rds`, `.RData`,
  `.sas7bdat`, `.xlsx`, `.dta`, `.parquet`, and similar) and the `data/` directory.
- GitHub and GitLab are not approved storage locations for Sensitive Data under
  Duke's data classification matrix. This applies to data files; it does not prohibit
  code repositories.
- Rendered output (`.html`, `.docx`, `.pdf` from Quarto or R Markdown) can embed data
  values in tables and figures. The `output/` directory is excluded by default;
  review any rendered file individually before it leaves the repository boundary.
- If a small genuinely public or synthetic file must be versioned (a lookup table, a
  simulated dataset), force-add it deliberately (`git add -f`) and record the
  decision in `SESSION_LOG.md`. Do not weaken the default excludes.

## Rule 2: Never Paste Data Values into a Model Prompt

This is the central behavioral discipline of the pilot, and it is deliberately
context-independent: it applies even on the BAA-covered Azure private endpoint.

- Describing data in the abstract is appropriate: column names, variable types,
  dimensions, missingness patterns, analytical intent.
- Pasting data listings, printed data frames, or variable output containing values
  is not, in any tier.

The channel being safe does not make the practice safe. Model completions can quote
values back into chat history, code comments, and documentation, which do not carry
the endpoint's governance controls and can propagate to ungoverned contexts. Azure
OpenAI retains prompt content for abuse monitoring for up to 30 days by default. And
HIPAA's minimum necessary standard applies to use: the purpose of the AI interaction
is code assistance, and data values are not necessary for that purpose.

For AI agents operating in the repository: inspect data through structure
(`str()`, `names()`, `dim()`, `dplyr::glimpse()` without value output where
possible) and do not reproduce data values in responses, comments, or commit
messages.

## Rule 3: Code Moves Up, Data Never Moves Down

The two-tier workflow is asymmetric by design. Code is developed and iterated in
Tier 2 against synthetic data, then validated code artifacts, and only code
artifacts, are transferred to Tier 1A or 1B for execution against real study data.
Data never moves from a Tier 1 environment to a Tier 2 environment, and neither does
output that embeds data values.

## Rule 4: Secrets Stay Out of Code

API keys, tokens, and connection strings live in environment variables or gitignored
local files (`.Renviron`, `.env`), never in scripts, notebooks, rendered documents,
or commit history. If a secret is ever committed, treat it as compromised: rotate it
and record the event in `SECURITY.md`.

## Rule 5: Environment Hygiene

Per the pilot recommendations for all tiers:

- VS Code telemetry off (`Settings > Telemetry: Telemetry Level > off`; on Tier 1B,
  apply this on the VM server instance, not only the local client).
- Extensions restricted to first-party Microsoft and GitHub publishers for pilot
  work; third-party extensions have full workspace read access and unrestricted
  outbound network capability with no permission prompt.
- Tier 1A sessions require the VPN active; this is a procedural control, so build
  the habit of checking before starting the AI layer.
- Use isolated project environments (`renv` for R, a project-local virtual
  environment for Python) rather than global installs.

## Bootstrap and Audit Hooks

- At bootstrap, the declared tier and data posture are recorded in `AGENTS.md` and in
  the first `SECURITY.md` audit entry.
- Security reviews under `standards/security-audit.md` verify Rules 1 and 4 with
  evidence: `.gitignore` coverage, `git status` output, and a secret scan.
- If the repository's tier changes (for example, synthetic-data development graduates
  to real-data execution), update `AGENTS.md`, re-run the security review, and log
  the change in `SESSION_LOG.md`.
