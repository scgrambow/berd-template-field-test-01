---
title: "Building a Teaching Repository with AI Assistance: A Process Essay"
subtitle: "From Case Selection Through Published Quarto Book"
created: 2026-07-31
author: Steve Grambow, Duke BERD Core
---

# Building a Teaching Repository with AI Assistance: A Process Essay

*A reflective account of developing the IVAM-ED CRP 241 teaching case using
GitHub Copilot, from selecting a published trial to deploying a rendered Quarto
book on GitHub Pages — in a single working session.*

---

## Starting Point: What We Were Trying to Build

The goal was to construct a complete, reproducible, student-ready teaching case
for CRP 241, an introductory clinical research methods course. The pedagogical
ambition was high: rather than isolated coding exercises, we wanted a single
published clinical trial to anchor an entire course arc — from raw data structure
through regression modeling, missing data, and critical appraisal. Students would
follow one investigation from beginning to end, building statistical concepts on
a foundation they already understood.

The practical constraints were equally real. We had no real participant data, no
pre-existing dataset, and no guarantee that any particular paper would lend itself
to the full range of topics we needed to cover. We were starting from a blank
repository.

---

## Selecting the Paper: Why IVAM-ED

The selection of the IVAM-ED trial was not arbitrary. Several papers were
considered. The criteria were explicit:

**Clinical accessibility.** The intervention — a voice-activated Amazon Echo Dot
programmed with reminders and health content — is immediately comprehensible to
any student, regardless of clinical specialty. The problem (older adults with
diabetes and mental health risk) is recognizable; the solution (a smart speaker)
is familiar from everyday life. Students don't need background knowledge to
engage with the question.

**Statistical tractability for beginners.** The trial is a clean two-group
randomized design with a single pre-specified primary outcome and a 12-week
follow-up. The primary analysis is ANCOVA — a model that every student in an
introductory research methods course will encounter. The secondary outcomes provide
material for discussions of multiple comparisons without becoming methodologically
overwhelming.

**Documentation richness.** This was the decisive criterion. The paper came with
a pre-registered protocol and SAP published in *Trials* in 2024, before results
were known. Having both a pre-registration and a results paper made it possible
to build Module 7 — the protocol-to-publication comparison — which is perhaps
the most important critical-appraisal exercise in the course. Few papers offer
this combination at the introductory level.

**Open access.** Both publications are CC-BY 4.0. This means the course repository
can be public, the source documents can be distributed, and students can cite the
real papers. This is not a minor point: it affects the entire pedagogical posture
of the course. Students are working with real published science, not a textbook
example, and the research is accessible to anyone who wants to verify it.

---

## The Repository Architecture Decision

Before writing a single line of code, we established a repository structure using
the BERD AI Repository Starter — a scaffold developed for the Duke BERD Core's
GitHub Copilot pilot program. This was a deliberate choice, not an afterthought.

The starter provides an `AGENTS.md` operating contract: a document that tells any
AI coding tool what it can do autonomously, what requires human confirmation, and
what it must never do. In a teaching context, this matters in at least two ways.

First, it enforces data hygiene at the infrastructure level. The `.gitignore` that
the bootstrap generates categorically excludes all data file extensions and the
`data/` directory. The simulation script produces `data/ivam_synthetic.rds`, which
is immediately gitignored. Students who clone the repository have to run the
simulation script to get data; they cannot accidentally commit data files even if
they try.

Second, it creates institutional memory. The `SESSION_LOG.md` convention — reverse
chronological, prepended at the top — means that any AI agent (or human) reading
the repository at any point in the future can open the session log and immediately
understand what has been done, what decisions were made, and why. This is not a
formality; it is the mechanism by which context persists across sessions.

The Tier 2 declaration (GitHub Copilot Business, synthetic data, GitHub remote)
was also a governance decision with real consequences. It constrained what data
could enter the repository, how the repository could be hosted, and what AI tools
could be used. Teaching with a Tier 2 repository is teaching with demonstrated
reproducibility: the entire workflow is visible, auditable, and repeatable.

---

## Extracting the Source Documents

The six source documents — two papers and four supplemental files — were extracted
to Markdown using local tools (`miyo parse` for PDFs, `pandoc` for the DOCX file).
This step is worth examining.

The extraction serves two purposes. The practical purpose: providing the AI agent
with searchable text from which to extract simulation parameters. Every number in
`R/simulate-ivam-ed.R` was verified against the extracted Markdown before being
hard-coded into the simulation. The mean SRQ-20 at baseline is 7.45 — not because
it seemed plausible, but because Table 1 of the results paper shows control: 7.0
and intervention: 7.9, and the pooled value is 7.45.

The pedagogical purpose: the extractions are reference documents for students.
`source/extracted/da-costa-2024-ivam-ed-protocol-sap.md` is the searchable text of
the protocol paper. Students working on Module 7 — comparing the published analysis
to the SAP — can open that file, search for "subgroup," and find the exact language
about the age cutoff. The extraction makes the source documents *workable* for
students who might otherwise never look at supplemental PDFs.

---

## Building the Simulation: Moment Matching and Its Limits

The simulation strategy was deliberate and its limitations were documented before
a single student sees the dataset.

**Moment matching** — choosing distributions whose means and standard deviations
match the published Table 1 values — is the honest choice given what we have.
We have summary statistics for 25 variables across two groups of 56 participants.
We do not have the individual-level data. We do not know the skewness of the
SRQ-20 distribution, the inter-variable correlations, or the covariance structure
of the outcome block. Claiming otherwise would be false precision.

The simulation uses independent normal distributions for each baseline variable.
A more sophisticated approach — multivariate normal with a realistic correlation
structure, or a Dirichlet-multinomial for the discrete scores — would produce more
internally consistent data but would also require assumptions we cannot verify.
For an introductory course, the independence assumption is pedagogically appropriate:
it is the simplest defensible approach, and its consequences (unrealistic
within-person profiles) are documented in `simulation-assumptions.md` so that
instructors know exactly what they are working with.

The ANCOVA-generating model for follow-up outcomes was more carefully calibrated.
The published Table 2 provides adjusted group means and 95% CIs from which
we can back-calculate residual standard deviations. The treatment effects ($\tau$)
are taken directly from the published baseline-adjusted estimates. The
baseline-to-follow-up correlation ($\beta = 0.70$) is set at a standard
test-retest value and confirmed by checking that the resulting CI widths approximate
the published values.

---

## The Debugging Cycles: What We Learned

Two bugs were encountered during simulation development, both caught by the
verification summary printed at the end of `R/simulate-ivam-ed.R`. These bugs were
not embarrassing accidents; they were expected and instructive.

**Bug 1** revealed a fundamental conceptual error: calibrating the ANCOVA intercept
at the control group's baseline mean rather than the grand mean. The consequence
was that a 1.1-point baseline imbalance (intervention group started higher on the
SRQ-20) almost completely offset the $\tau = -1.28$ treatment effect. The raw
follow-up means were nearly identical between groups despite a substantial specified
treatment effect. The diagnosis required working through the algebra of adjusted
means — which is exactly the content of Module 5. The bug taught us the material
we were trying to teach.

**Bug 2** revealed the fragility of probabilistic models for rare events in small
samples. With 9 missing participants out of 112, a logistic model for missingness
was exquisitely sensitive to the particular random numbers generated with a given
seed. The fix — deterministic rank-based selection — is simpler, more predictable,
and easier to explain to students. It also reflects a general principle: when the
goal is a stable teaching dataset rather than a simulation study, deterministic
approximations are often preferable to stochastic ones.

Both debugging episodes are documented in `simulation-refinements.md`, with the
mathematical diagnosis and before/after code. This documentation exists because
debugging is itself a skill, and the verify-diagnose-fix-re-verify cycle that was
used here is exactly the cycle students will need when they encounter errors in their
own analyses. The simulation refinement document is part of the teaching case.

---

## The Module Architecture: One Study, Seven Angles

The seven-module structure was not arrived at by formula. It reflects the natural
sequence of a complete analysis of a randomized clinical trial, with each module
addressing one methodological question:

| Module | Question |
|---|---|
| 1 — Data Setup | What are the data? |
| 2 — Descriptive Statistics | Who was enrolled? Are the groups similar? |
| 3 — Visualization | What do the distributions look like? |
| 4 — Estimation | How different were the groups at follow-up? |
| 5 — ANCOVA | Does baseline adjustment change the picture? |
| 6 — Missing Data | Does it matter that 9 participants didn't complete the trial? |
| 7 — Interpretation | Is the result clinically meaningful? Did the paper follow its plan? |

The sequencing reflects the cumulative logic of clinical trial analysis. The
unadjusted t-test in Module 4 deliberately precedes the ANCOVA in Module 5 so
that students see the adjustment matter. The forest plot in Module 4 shows unadjusted
estimates, which are then replaced by ANCOVA estimates in Module 5. The missing-data
analysis in Module 6 follows the primary ANCOVA because you need a reference
estimate to assess sensitivity to. Module 7 can only be done last because it requires
the statistical results from all previous modules to evaluate the protocol-to-publication
comparison against real numbers.

Within each module, the structure is consistent: a brief overview of the question
and learning objectives, setup code, numbered analytical sections, callout boxes
highlighting key conceptual points, and practice exercises. This consistency is
intentional. Students working independently know what to expect at the start of
each module; the variation is in the content, not the format.

---

## The Quarto Book: Why Not Just Modules?

The seven modules could have remained seven separate Quarto documents, each
rendered to a self-contained HTML file. That would have been adequate. The decision
to wrap them in a Quarto Book was motivated by several considerations.

**Navigation.** A Quarto Book generates a persistent sidebar navigation bar,
chapter-to-chapter arrows, and a search index. Students can move between modules
without losing their place. They can search "regression to the mean" and find every
occurrence across all seven chapters. These are not trivial amenities in a
25,000-word technical tutorial.

**Introduction.** The book format warranted an introductory chapter that could
not easily exist as a standalone module. The `index.qmd` chapter — covering case
selection, source materials, repository design, simulation strategy, learning
objectives, and the chapter guide — is the kind of document that sets context for
an entire course, not just an individual exercise. It is both an orientation for
students and a methodological statement for instructors.

**References.** The book format allowed for a formal appendix (`references.qmd`)
with complete citations for all source papers, instrument validation studies,
statistical methods references, and R packages. In a standalone module, citations
would be scattered across seven files. In the book, they are consolidated and
citeable.

**GitHub Pages.** A Quarto Book renders to a coherent website that can be served
directly from GitHub. Students can bookmark the URL and access the complete tutorial
from any device without downloading or rendering anything. The GitHub Actions
workflow means that the published site always reflects the current state of the
`main` branch. This automation, once configured, requires no ongoing maintenance.

---

## What AI-Assisted Development Looked Like in Practice

This entire repository was built in a single working session using GitHub Copilot
in VS Code agent mode. That statement deserves some reflection.

The AI agent did not work autonomously. At every substantive decision point —
the tier declaration, the simulation strategy, whether to initialize renv, which
paper to use, what to include in the book introduction — the agent either waited
for human direction or, when the user was unavailable, documented its assumptions
explicitly and invited review. The `AGENTS.md` operating contract was not
ornamental; it governed the session.

What the AI contributed was speed and consistency. The simulation script that would
have taken a half-day to write manually was drafted in minutes, documented with
source citations at the same time, and then debugged through two cycles before
producing output that met the verification criteria. The seven module documents
were written sequentially, each building on the previous, with consistent structure
and callout conventions. The book introduction was drafted in a single pass from
the accumulated context of the entire session.

What remained essential for the human to provide: judgment about what to teach and
why, the pedagogical sequencing decisions, the understanding of what CRP 241 students
need, and the choice of the IVAM-ED paper in the first place. The AI accelerated
production; the instructor directed it.

The `docs/extracted/` conflict — where Quarto's book render overwrote the extracted
reference documents that had been placed in the same `docs/` directory — was a
genuine error made by the AI agent. The fix was straightforward (move the files to
`source/extracted/`), but the error illustrates a real limitation: AI agents can
work very fast and make mistakes that require human review to catch. The session
log preserved the full audit trail.

---

## What Future Iterations Should Consider

No first version of a teaching case is final. Several extensions are worth
considering:

**Answer keys.** The practice exercises in Modules 1–7 have no published solutions.
An instructor answer key — rendered as a separate Quarto document, not publicly
visible in the main book — would substantially increase the course utility of this
material.

**A capstone exercise.** The seven modules teach skills in isolation. A Module 8
"capstone" could ask students to write a complete methods and results section for
the primary outcome, integrating data management, descriptive statistics, ANCOVA,
and interpretation in a single deliverable. This would be the most direct test of
whether the course objectives have been met.

**Power analysis.** The protocol specified n = 112 with power 90%, effect size 0.68,
and α = 0.05. Walking students through this calculation — and asking them what
happens if the true effect size is 0.40 rather than 0.68 — would complete the
connection between design, analysis, and interpretation that the case is designed
to build.

**Probabilistic simulation.** The current simulation uses a fixed seed and produces
the same dataset every time. A companion document showing what happens when you
change the seed — how the p-values vary, how often the primary result crosses the
significance threshold, how the CI widths change — would provide a simulation-based
introduction to statistical inference that complements the analytical approach.

**Multiple seeds as a course tool.** Instructors could assign different seeds
to different students (or different course years), producing datasets with the same
underlying parameters but different realized samples. This would allow class
discussion of why different groups got different answers from the same "trial."

---

## A Note on Transparency as Pedagogy

The most unusual feature of this teaching repository — and perhaps the most
important — is that it documents everything. The simulation assumptions are
documented. The debugging cycles are documented. The protocol-to-publication
deviations are documented. The repository construction process (this essay) is
documented. The security audit is documented.

This is not administrative overhead. It is the pedagogy. Clinical research
methodology is fundamentally about distinguishing what was decided in advance from
what was decided after seeing the data, what was planned from what was found, what
is confirmatory from what is exploratory. A teaching case that demonstrates these
distinctions in its own construction — that shows the assumptions, the errors, the
fixes, and the deviations — is a case that teaches by example as well as by
instruction.

Students who read `simulation-refinements.md` before Module 5 will understand the
adjusted means exercise differently than students who treat the simulation as a
black box. Students who compare the IVAM-ED protocol to the published paper in
Module 7 are doing exactly what they should do with every paper they read for the
rest of their careers. The repository is not just a set of exercises; it is a model
of how rigorous quantitative work is documented.

---

*This essay was written on 2026-07-31 at the conclusion of the initial repository
development session. It describes the decisions made, the tools used, and the
lessons learned. It is intended to be useful to future instructors adapting this
material, future AI agents continuing development of this repository, and students
curious about how the dataset they are analyzing was made.*
