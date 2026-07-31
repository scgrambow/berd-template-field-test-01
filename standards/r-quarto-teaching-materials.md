---
type: standard
title: "R and Quarto Teaching Materials"
description: "Quality requirements for R scripts and Quarto tutorials intended for instruction, guided practice, or independent student review."
status: active
version: "1.1"
review_owner: "Steve Grambow"
last_updated: 2026-07-31
---

# STANDARD: R and Quarto Teaching Materials

## Purpose

This standard defines the quality requirements for R scripts and Quarto tutorials intended for instruction, guided practice, or independent student review.

Use `r-quarto-tutorial-authoring.md` (in this same `standards/` folder) for the operational workflow. This standard defines the output contract and remains authoritative when local skill adaptations differ.

## Required Outputs

Produce both artifacts unless the task explicitly narrows the scope:

1. A readable `.R` script that can be run line by line or as a complete file.
2. A `.qmd` tutorial that executes the analysis and explains each decision, output, limitation, and interpretation.

Keep generated drafts separate from reviewed or published materials. In this repository, executable analysis documents in `R/` are the working layer; once an instructor has reviewed and approved a module, note its status in `SESSION_LOG.md`. There is no separate `generated/` or `drafts/` directory — use file name prefixes (e.g., `draft-`) and SESSION_LOG entries to track review state.

## Source and Provenance Rules

- Identify the source dataset, source script, lecture material, and prior version when they exist.
- State when no predecessor script exists rather than implying that generated code was inherited.
- Preserve source variable names, analytic specifications, and order of operations unless an approved change is documented.
- Record substantial AI assistance in `SESSION_LOG.md` under the session's **Decisions Made** block, noting which files were AI-generated and the prompts or tools used.
- Never include student names, credentials, private links, or restricted source text in instructional outputs.

## R Script Requirements

The script must include:

- Audience and learning goals.
- Data source and expected file location.
- Required R and package versions when version sensitivity matters.
- A concise data dictionary for variables used in the lesson.
- Clear sections for setup, loading, inspection, analysis, interpretation, and verification.
- Plain-language explanations after major transformations, tables, plots, tests, or models.
- Separate statistical and applied interpretation when the distinction improves understanding.

Prefer transparent intermediate objects over compressed pipelines for introductory audiences. Use packages when they support the learning goal, and explain why each non-base dependency is needed.

Do not install packages automatically inside teaching scripts by default. Declare dependencies in the repository's capability record or environment manifest, then install them through an explicit, approved setup step.

## Quarto Tutorial Requirements

The tutorial must include:

- Title, audience, learning objectives, source notes, and AI-use disclosure when applicable.
- Setup and data-loading instructions that work from the documented project root.
- Question-led or task-led sections connecting code to the lesson purpose.
- A short purpose statement before each executable code block.
- A plain-language explanation after every decision-relevant output.
- Limitations, practice exercises, and reproducibility information.
- `sessionInfo()` or an equivalent environment capture when R code executes.

Configure output formats according to the target repository and verified environment. HTML should be the portable review baseline; add PDF only when a working LaTeX engine is documented.

## Dependency and Environment Controls

Before rendering:

1. Run `Rscript -e 'renv::status()'` to confirm the package library matches `renv.lock`.
2. Run `quarto --version` and `Rscript -e 'sessionInfo()'` to record active versions.
3. Confirm required packages are in `renv.lock`; add new ones with `renv::install()` then `renv::snapshot()`.
4. Use project-relative paths and set the Quarto execution directory explicitly when needed (`execute-dir: project` in `_quarto.yml` or the document YAML).
5. Stop and report missing dependencies before changing the workstation or repository environment without approval.

## Verification

Verify the source and every requested output:

- Run the R script in a clean or documented session.
- Render the Quarto document in each requested format.
- Confirm code execution, tables, plots, links, callouts, and navigation.
- Inspect HTML in a browser and PDF pages visually when PDF is requested.
- Confirm that outputs contain no private material or student information.
- Record commands, versions, limitations, and review status in the repository session log.

## Acceptance Checklist

- [ ] Source and AI provenance are explicit.
- [ ] Dependencies are declared and were not silently installed.
- [ ] Project-relative paths resolve from the documented execution root.
- [ ] Major outputs receive immediate plain-language interpretation.
- [ ] The R script runs successfully in the documented environment.
- [ ] Every requested Quarto format renders successfully.
- [ ] Visual review covers each rendered format.
- [ ] Draft and reviewed output locations remain distinct.
- [ ] Privacy and publication boundaries pass review.

## Version Log

| Version | Date | Description |
|---|---|---|
| 1.0 | 2026-07-17 | Initial portable standard derived from CRP241F26. |
| 1.1 | 2026-07-31 | Adapted for berd-template-field-test-01: updated YAML type, fixed `skills/` path to `standards/`, replaced `CAPABILITIES.md` with `renv::status()` pattern, replaced `standards-ai-use-disclosure.md` with SESSION_LOG convention, adapted draft-layer language to this repo's structure. |
