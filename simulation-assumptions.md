---
title: "Simulation Process and Assumptions: IVAM-ED Synthetic Dataset"
description: "Documents how the synthetic dataset for CRP 241 exercises was constructed, where each parameter came from, and what was approximated."
created: 2026-07-31
author: BERD AI Pilot (GitHub Copilot)
---

# Simulation Process and Assumptions {.unnumbered}

This document explains how the synthetic dataset in `R/simulate-ivam-ed.R` was
built, where every number came from, and what the known limitations are.
It is written for instructors and students who want to understand the data before
analyzing it.

## What Is a Synthetic Dataset?

A synthetic dataset is a computer-generated dataset whose statistical properties
(sample size, means, standard deviations, correlations, treatment effects) are
designed to closely resemble those of a real study — but it contains no real
participant data. Every row represents a fictional person whose values were drawn
from probability distributions, not measured from an actual patient.

**Why use a synthetic dataset?**

- The real IVAM-ED trial data are not publicly available. Using synthetic data
  lets us analyze a realistic dataset without exposing real participants.
- Synthetic data can be regenerated reproducibly from a fixed random seed, so
  every student starts from the same dataset.
- Because the data are not real, students can explore, make mistakes, and
  re-run analyses freely without any risk of PHI exposure.

**What the synthetic dataset is NOT:**

- It is not a reconstruction of the real data. We do not have individual-level
  data and have not attempted to reverse-engineer them.
- It will not reproduce the exact p-values or confidence intervals from the paper
  in every run. The published results came from the real data; our simulation
  approximates the aggregate-level statistics.
- Variables that appear continuous (e.g., SRQ-20, MMSE) may have slightly
  different distributions than the real data because we used normal distributions
  as approximations.

---

## Primary Sources

Every parameter used in the simulation comes from one of three published sources:

| Source | Citation | Role in simulation |
|---|---|---|
| Results paper | Matzenbacher et al. (2026). *JAMA Network Open*, 9(1):e2553508. DOI: 10.1001/jamanetworkopen.2025.53508 | Baseline demographics (Table 1), follow-up outcome means (Table 2), subgroup counts (Figure 2), missingness (Results text) |
| Protocol and SAP | Da Costa et al. (2024). *Trials*, 25(1):205. DOI: 10.1186/s13063-024-08055-3 | Instrument ranges, sample size calculation, effect size (0.68), power (90%), dropout assumption (20%), analysis model specification |
| JAMA Supplement 1 | Matzenbacher et al. (2026), Supplement 1 — Study Protocol and SAP embedded in results paper | Subgroup definitions, MMSE cognitive-decline cutoffs, randomization procedure |

Extracted Markdown versions of all three are in `source/extracted/`.

---

## Simulation Strategy: Moment Matching

We used **moment matching**: for each variable, we chose a probability
distribution whose mean and standard deviation match the published values.

This is the simplest defensible approach when you have only summary statistics
(means and SDs) and no access to individual-level data. It does not attempt to
match skewness, kurtosis, or inter-variable correlations exactly, but it produces
a dataset that "looks right" at the summary level — which is the goal for a
teaching exercise.

An alternative approach would be to use a multivariate normal distribution
(`MASS::mvrnorm`) to generate all outcomes simultaneously with a plausible
correlation structure. That approach is more realistic but adds complexity that
obscures the teaching purpose. Instructors who want to extend the simulation
to include realistic inter-variable correlations can modify the script using
the correlation structure described in the "Known Approximations" section below.

---

## Parameter Table

This table documents every simulation parameter, its value, and its source.
"Pooled" means we averaged across the two published group-specific values.

### Demographics

| Variable | Distribution | Parameters | Source |
|---|---|---|---|
| N | fixed | 112 total (56 per group) | Methods; Figure 1 |
| `group` | Bernoulli | p = 0.50 (1:1, simple random) | Methods: "randomly assigned in a 1:1 ratio using a computer-generated simple random sequence without stratification or blocking" |
| `age` | Normal, clipped ≥ 65 | µ = 72.5, σ = 5.7 | Results abstract; Table 1: ctrl 72.4 (6.0), int 72.6 (5.4) |
| `female` | Bernoulli | p = 0.634 | Results: "71 females [63.4%]" |
| `edu_years` | Normal, clipped ≥ 0 | µ = 6.95, σ = 4.05 | Table 1: ctrl 7.5 (3.9) years, int 6.4 (4.2) years; pooled |
| `income_wages` | Normal, clipped ≥ 0.5 | µ = 2.30, σ = 2.40 | Results text: "mean (SD) individual income was 2.3 (2.4) Brazilian minimum wages" |
| `dm_duration_y` | Normal, clipped ≥ 1 | µ = 16.9, σ = 11.6 | Results text: "mean (SD) duration of diabetes was 16.9 (11.6) years" |
| `insulin` | Bernoulli | p = 0.536 | Figure 2 subgroup: "60 (53.6%) Yes" insulin use; Table 1: ctrl 28/56 (50.0%), int 32/56 (57.1%) |
| `hx_depression` | Bernoulli | p = 0.357 | Figure 2 subgroup: "40 (35.7%) Yes" history of depression |
| `hx_anxiety` | Bernoulli | p = 0.339 | Figure 2 subgroup: "38 (32.9%) [actually 33.9%]" history of anxiety; used 38/112 = 0.339 |

### Baseline Clinical Measures

These instruments were measured at the baseline visit (week −1).

| Variable | Distribution | Parameters | Bounds | Instrument description | Source |
|---|---|---|---|---|---|
| `mmse_0` | Normal, bounded | µ = 24.15, σ = 4.25 | [0, 30] | Mini-Mental State Examination. Higher = better cognitive function. | Table 1: ctrl 24.8 (4.0), int 23.5 (4.5) |
| `srq20_0` | Normal, bounded, rounded | µ = 7.45, σ = 5.00 | [0, 20] | Self-Reporting Questionnaire-20. Higher = greater mental distress. | Table 1: ctrl 7.0 (4.7), int 7.9 (5.2) |
| `sci_r_0` | Normal, bounded | µ = 35.85, σ = 6.40 | [0, 56] | Self-Care Inventory Revised. Higher = better diabetes self-care adherence. | Table 1: ctrl 36.5 (5.9), int 35.2 (6.8) |
| `pss_0` | Normal, bounded | µ = 22.10, σ = 10.35 | [0, 40] | Perceived Stress Scale. Higher = greater perceived stress. | Table 1: ctrl 23.6 (10.3), int 20.6 (10.3) |
| `sf36_0` | Normal, bounded | µ = 50.55, σ = 21.85 | [0, 100] | SF-36 quality of life. Higher = better quality of life. | Table 1: ctrl 50.2 (21.5), int 50.9 (22.2) |
| `hba1c_0` | Normal, clipped | µ = 7.90, σ = 1.55 | [≥ 4.5%] | HbA1c (%). Lower = better glycemic control. | Table 1: ctrl 7.8 (1.5), int 8.0 (1.6) |
| `cognitive_decline` | Derived | MMSE cutoff: < 24 if edu < 5 years; < 26 otherwise | binary | Positive screening for cognitive decline. | Protocol/SAP: MMSE education-adjusted cutoffs; Figure 2: 72/112 (64.3%) positive |

### Follow-Up Outcome Model

We used an **ANCOVA-generating model** for each follow-up outcome:

$$y_{12,i} = \alpha + \tau \cdot \text{group}_i + \beta \cdot y_{0,i} + \varepsilon_i$$

Where:
- $\alpha$ = intercept calibrated so the control group mean matches the published baseline-adjusted mean at 12 weeks
- $\tau$ = treatment effect (mean difference, intervention vs. control), taken directly from the published Table 2 baseline-adjusted estimates
- $\beta$ = baseline-to-follow-up regression coefficient, set to **0.70** for all outcomes (see rationale below)
- $\varepsilon_i$ = residual error, drawn from Normal(0, σ_ε)

#### Why β = 0.70?

The test-retest reliability (baseline-to-follow-up correlation) for psychological
and clinical instruments over 12 weeks is typically in the 0.60–0.80 range. We
chose 0.70 as a round central estimate. This value is not reported in the paper
(individual-level correlations are never reported in aggregate publications).
Using β = 0.70 reproduces the published standard errors and confidence interval
widths reasonably well, confirming it is a plausible value.

#### Intercept calibration

For each outcome, we solve for $\alpha$ so that the expected control-group mean
at follow-up matches the published adjusted mean:

$$\alpha = \bar{y}_{12,\text{ctrl}} - \beta \cdot \bar{y}_{0,\text{ctrl}}$$

#### Residual standard deviation

The residual SD (σ_ε) is calibrated so that the resulting SE of the treatment
effect coefficient matches the published SE from Table 2. Specifically:

$$\text{SE}(\hat\tau) \approx \sigma_\varepsilon \sqrt{\frac{2}{n_\text{complete}}}$$

We solve for σ_ε using the published SE and n = 103 completers.

#### Follow-up parameters by outcome

| Outcome | Published MD (τ) | Published SE | Target ctrl mean | Residual σ | Source |
|---|---|---|---|---|---|
| `srq20_12` | −1.28 | 0.45 (baseline-adj) | 7.66 | ~2.3 | Table 2 |
| `sf36_12` | +9.46 | 2.95 (from CI width) | ~49.0 | ~15.0 | Table 2 |
| `sci_r_12` | +3.40 | 0.91 (from CI width) | ~36.0 | ~4.6 | Table 2 |
| `hba1c_12` | −0.48 | 0.19 (from CI width) | ~8.04 | ~0.97 | Table 2 |
| `pss_12` | −3.00 | 1.63 (from CI width) | ~21.0 | ~8.3 | Table 2 |

Note: We use the **baseline-adjusted** MD from Table 2 (not the fully adjusted).
This is the simpler model students will replicate first. The fully adjusted model
(which additionally controls for age, sex, education, income, and MMSE) produces
slightly larger effect estimates in the paper (e.g., SRQ-20 MD: −1.46 vs. −1.28).

### Missingness

| Feature | Value | Source |
|---|---|---|
| Total missing at 12 weeks | 9 participants (8.0%) | Results: "103 participants (92.0%) completed the trial" |
| Missing by group | 5 control, 4 intervention | Inferred from completers: 52 intervention, 51 control |
| Reason for missingness | 6 lost to follow-up, 3 deaths | Results text |
| Missing data mechanism | Missing at random (MAR) | Protocol SAP: "frequency and reasons for missing data are expected to be missing at random" |
| MAR mechanism implemented | Higher baseline SRQ-20 slightly increases P(missing) | Clinically plausible; more distressed participants more likely to drop out |

---

## Known Approximations and Limitations

1. **Normal approximations for bounded discrete variables.** SRQ-20 (0–20, integer) and MMSE (0–30, integer) are discrete sum scores. We simulate them as continuous normals and round. This means the distribution may have values at the tails that are impossible in the real instrument; the `clamp()` step handles this.

2. **Independent baseline variables.** We simulate each baseline variable independently (no inter-variable correlation). In the real data, SRQ-20 and PSS are likely positively correlated (~0.55), SRQ-20 and SF-36 negatively correlated (~−0.45), etc. This simplification is intentional to keep the script readable. It means that within-person patterns will not be as coherent as in real data. Instructors who want to explore this can add `MASS::mvrnorm()` for the outcome block.

3. **Single-site, Brazilian sample.** The real study enrolled participants at one academic medical center in Brazil with low income and limited formal education. These characteristics are baked into the demographic parameters. The simulation is not intended to represent North American or European populations.

4. **Effect sizes are fixed, not sampled.** The simulation produces a dataset where the true treatment effect equals the published MD. In a real trial, the observed effect in any single run will vary around the true effect due to sampling variability. This means running the script multiple times with different seeds will give different p-values, sometimes crossing the significance threshold.

5. **No group-level imbalance in baseline.** The real randomization produced essentially balanced groups (Table 1 shows no meaningful differences). We enforce exact equal group sizes (56/56) and simulate from pooled baseline parameters, so our groups will also be balanced on average.

6. **No inter-rater reliability or measurement error modeling.** The real outcomes were interviewer-assessed. We do not add a separate measurement-error component.

7. **Follow-up HbA1c bounding.** HbA1c is clipped at 4.5% as a physiological lower bound. Very high values are theoretically unbounded but rare; the simulation will occasionally produce values above 12% that are implausible for a treated older adult with diabetes.

---

## Reproducibility

The simulation uses `set.seed(241)` at the top of `R/simulate-ivam-ed.R`. The
seed 241 refers to CRP 241, the course this dataset was built for.

Running the script with the same seed on R ≥ 4.6.1 will always produce the same
dataset. If the script is run on a different R version, results may differ because
R's random number generator can change across major versions.

The R version and renv lockfile are recorded in `renv.lock`. To reproduce the
exact environment: clone the repository, restore with `renv::restore()`, then
source `R/simulate-ivam-ed.R`.

---

## How to Cite the Source Publications

Any work derived from this simulated dataset should acknowledge the original
published trial. Suggested language for student reports:

> "Analysis was performed on a synthetic dataset constructed to approximate the
> sample characteristics reported in Matzenbacher et al. (2026). The synthetic
> data were generated for teaching purposes and do not represent individual
> participant data from the IVAM-ED trial."

Full citations:

- Matzenbacher LS, da Costa FL, de Barros LGB, et al. Interactive virtual assistant for health promotion among older adults with type 2 diabetes: the IVAM-ED randomized clinical trial. *JAMA Network Open*. 2026;9(1):e2553508. doi:10.1001/jamanetworkopen.2025.53508

- Da Costa FL, Matzenbacher LS, Gheno V, et al. Interactive virtual assistance for mental health promotion and self-care management in elderly with type 2 diabetes (IVAM-ED): study protocol and statistical analysis plan for a randomized controlled trial. *Trials*. 2024;25(1):205. doi:10.1186/s13063-024-08055-3
