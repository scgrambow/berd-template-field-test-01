---
type: skill
title: "Author an R and Quarto Tutorial"
description: "Workflow for turning source analysis or lesson material into a readable R script and verified Quarto tutorial for instruction."
status: active
version: "1.1"
review_owner: "Steve Grambow"
last_updated: 2026-07-31
---

# Skill: Author an R and Quarto Tutorial

## Purpose

Create an instructional R script and executable Quarto tutorial from an existing analysis, dataset, lesson plan, or reviewed source material.

Read `standards/standards-r-quarto-teaching-materials.md` (in this same folder). That standard controls output quality, dependency handling, provenance, and verification.

## Required Inputs

- Target audience and learning objectives.
- Source R script, or an explicit statement that no predecessor exists.
- Dataset and data dictionary.
- Reviewed lesson notes, readings, or extraction output.
- Repository instructions, output locations, and publication boundaries.
- Capability record or permission to run read-only environment checks.

## Preflight

1. Inspect repository instructions, session state, and unrelated working-tree changes.
2. Identify authoritative sources and record their filenames.
3. Confirm the draft and reviewed output locations.
4. Verify R, Quarto, Pandoc, and package versions: run `Rscript -e 'renv::status()'` and `quarto --version`. Check `renv.lock` for the declared package library.
5. Stop before installing packages or changing the environment unless that action is approved. Use `renv::install()` followed by `renv::snapshot()` to add packages; record the addition in `SESSION_LOG.md`.

## Procedure

### 1. Establish the Teaching Path

Define the learning sequence, expected prior knowledge, data source, and outputs students must interpret. Preserve existing analytic specifications unless an approved teaching change is documented.

### 2. Create the R Script

Write a project-relative script with sections for setup, loading, inspection, analysis, interpretation, and verification. Explain new functions and major objects at the audience's level.

Place a plain-language explanation after each decision-relevant transformation, table, plot, test, or model. Use transparent intermediate objects when compact syntax would conceal the reasoning.

### 3. Create the Quarto Tutorial

Build a `.qmd` file that:

- States audience, objectives, sources, dependencies, and AI-use disclosure.
- Frames analysis sections as research questions or practical tasks.
- Explains each code block before execution and each major output afterward.
- Includes limitations, practice exercises, and environment capture.
- Uses HTML as the baseline review format and adds other formats only when supported.

### 4. Render and Review

Run the R script, render each requested Quarto format, and inspect the outputs. Check code, tables, figures, callouts, navigation, page breaks, links, and restricted content.

### 5. Record Review State

Keep drafts in the repository's generated or draft layer. Promote them only after the named reviewer approves the content, then update manifests, catalogs, and session records.

## Output

- `<topic>-tutorial.R`
- `<topic>-tutorial.qmd`
- Requested rendered formats supported by the verified environment
- Concise verification report naming commands, versions, review status, and limitations

## Acceptance Checks

- [ ] Sources, predecessor status, and AI assistance are explicit.
- [ ] Dependencies are declared without silent installation.
- [ ] Paths resolve from the documented execution root.
- [ ] Major outputs receive immediate interpretation.
- [ ] The R script runs successfully.
- [ ] Every requested format renders and passes visual review.
- [ ] Drafts remain separate from approved teaching materials.
- [ ] Privacy and publication checks pass.

## Example Invocation

> Use `skills/r-quarto-tutorial-authoring.md` to turn the reviewed lesson notes and dataset in `<session-path>` into a beginner-level R script and Quarto tutorial. Render HTML, report any unsupported formats, and keep the outputs in the repository's draft layer.

## Version Log

| Version | Date | Description |
|---|---|---|
| 1.0 | 2026-07-17 | Initial portable R and Quarto tutorial workflow (derived from CRP241F26). |
| 1.1 | 2026-07-31 | Adapted for berd-template-field-test-01: updated YAML type, moved to `standards/`, replaced `CAPABILITIES.md` reference with `renv::status()` / `renv.lock` pattern. |
