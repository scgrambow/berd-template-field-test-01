# =============================================================================
# simulate-ivam-ed.R
#
# Purpose:
#   Generate a synthetic (computer-simulated) participant-level dataset that
#   approximates the statistical properties of the IVAM-ED randomized clinical
#   trial (Matzenbacher et al., JAMA Network Open, 2026).
#
#   This dataset is for teaching purposes in CRP 241. It is NOT real data.
#   Every row represents a fictional participant whose values were drawn from
#   probability distributions, not measured from an actual patient.
#
# What this script produces:
#   data/ivam_synthetic.rds  — a single R data frame (112 rows x 25 columns)
#   with one row per simulated participant, containing baseline covariates,
#   baseline outcome measurements, follow-up outcome measurements, and
#   missingness indicators.
#
# How to run:
#   source("R/simulate-ivam-ed.R")
#   dat <- readRDS("data/ivam_synthetic.rds")
#
# For documentation on every simulation decision and assumption, see:
#   docs/simulation-assumptions.md
#
# Source publications:
#   Results paper: doi:10.1001/jamanetworkopen.2025.53508
#   Protocol/SAP:  doi:10.1186/s13063-024-08055-3
#
# Reproducibility:
#   set.seed(241) below. Running this script on R >= 4.6.1 with the same
#   seed will always produce the same dataset.
#
# CRP 241 | Duke University | 2026
# =============================================================================


# =============================================================================
# 0. SETUP
# =============================================================================

# -- Packages --
# If any package is missing, run: renv::install(c("dplyr", "labelled"))
# After installing, run renv::snapshot() to record them in renv.lock.
library(dplyr)    # data wrangling
library(labelled) # adds human-readable variable labels to the data frame

# -- Reproducibility --
# This seed ensures every student generates the same dataset.
# 241 = CRP 241, the course this dataset was built for.
set.seed(241)

# -- Sample size --
# The trial enrolled 112 participants, 56 per group, in a 1:1 ratio.
# Source: Methods section; Figure 1 CONSORT diagram.
N       <- 112
N_per   <- N / 2  # 56 per group


# =============================================================================
# 1. RANDOMIZATION
# =============================================================================
# In the real trial, group assignment used "a computer-generated simple random
# sequence without stratification or blocking" (Methods).
# We replicate that: each participant is assigned to intervention or control
# with equal probability, independently of their characteristics.
#
# group = 1 --> Smart speaker (intervention)
# group = 0 --> Usual care (control)
#
# We generate exactly 56 in each group (as the trial achieved) by assigning
# labels directly rather than sampling, then shuffling the order.

group <- sample(c(rep(1L, N_per), rep(0L, N_per)))  # 56 ones and 56 zeros, randomly ordered


# =============================================================================
# 2. DEMOGRAPHIC AND CLINICAL COVARIATES
# =============================================================================
# Each variable below is drawn from a probability distribution whose mean and
# SD match the published baseline values in Table 1 of the results paper.
# "Pooled" = we averaged the two published group means for the overall draw
# (the groups are balanced, so this approximates the overall distribution).
#
# Helper function: clamp() forces values to stay within a realistic range.
# For example, age cannot be below 65 (trial inclusion criterion).
clamp <- function(x, lo, hi) pmin(pmax(x, lo), hi)

# -- Age (years) --
# Source: Table 1. Control: 72.4 (6.0), Intervention: 72.6 (5.4). Pooled: 72.5 (5.7).
# Minimum 65: trial inclusion criterion was age >= 65.
age <- clamp(rnorm(N, mean = 72.5, sd = 5.7), lo = 65, hi = 100)

# -- Sex --
# Source: Results abstract. 71 females (63.4%), 41 males (36.6%).
# female = 1 (female), female = 0 (male).
female <- rbinom(N, size = 1, prob = 0.634)

# -- Education (years of schooling) --
# Source: Table 1. Control: 7.5 (3.9) years, Intervention: 6.4 (4.2) years.
# Pooled mean: 6.95; pooled SD: 4.05. Minimum 0 years.
edu_years <- clamp(rnorm(N, mean = 6.95, sd = 4.05), lo = 0, hi = 30)

# -- Individual monthly income (Brazilian minimum wages) --
# Source: Results text. "Mean (SD) individual income was 2.3 (2.4) Brazilian
# minimum wages per month." This is a low-income population.
# Minimum 0.5 (avoids implausible zero or negative income).
income_wages <- clamp(rnorm(N, mean = 2.30, sd = 2.40), lo = 0.5, hi = 30)

# -- Duration of diabetes (years) --
# Source: Results text. "Mean (SD) duration of diabetes was 16.9 (11.6) years."
# 68.8% had diabetes for 10 years or more.
# Minimum 1 year (required for enrollment in this older adult sample).
dm_duration_y <- clamp(rnorm(N, mean = 16.9, sd = 11.6), lo = 1, hi = 60)

# -- Insulin use --
# Source: Figure 2 subgroup counts. 60/112 (53.6%) used insulin.
# Table 1: Control 50.0%, Intervention 57.1%.
# insulin = 1 (uses insulin), insulin = 0 (does not use insulin).
insulin <- rbinom(N, size = 1, prob = 0.536)

# -- History of depression --
# Source: Figure 2. 40/112 (35.7%) had a history of depression.
# hx_depression = 1 (yes), hx_depression = 0 (no).
hx_depression <- rbinom(N, size = 1, prob = 0.357)

# -- History of anxiety --
# Source: Figure 2. 38/112 (33.9%) had a history of anxiety.
# hx_anxiety = 1 (yes), hx_anxiety = 0 (no).
hx_anxiety <- rbinom(N, size = 1, prob = 0.339)


# =============================================================================
# 3. BASELINE CLINICAL OUTCOME MEASURES
# =============================================================================
# These are the instruments measured at the baseline visit (week -1),
# before randomization was revealed and before the intervention began.
# They serve as both descriptive variables AND covariates in the analysis.
#
# Each instrument has:
#   - A name ending in "_0" (baseline / week 0)
#   - A realistic score range enforced by clamp()
#
# Note on rounding: SRQ-20 and MMSE are integer sum scores in the real
# instrument (you either endorse an item or you don't). We round them to
# the nearest integer to preserve that property.

# -- MMSE: Mini-Mental State Examination (cognitive function) --
# Scores range from 0 to 30. HIGHER scores = BETTER cognitive function.
# Source: Table 1. Control: 24.8 (4.0), Intervention: 23.5 (4.5). Pooled: 24.15 (4.25).
mmse_0 <- round(clamp(rnorm(N, mean = 24.15, sd = 4.25), lo = 0, hi = 30))

# -- Cognitive decline screening (derived from MMSE) --
# The trial used education-adjusted MMSE cutoffs to define "positive screening
# for cognitive decline" -- the same approach used in Brazilian clinical practice.
# Cutoff: MMSE < 24 for participants with < 5 years of education;
#          MMSE < 26 for participants with >= 5 years of education.
# Source: Protocol/SAP (JAMA Supplement 1); Figure 2: 72/112 (64.3%) positive.
cognitive_decline <- as.integer(
  (edu_years < 5  & mmse_0 < 24) |
  (edu_years >= 5 & mmse_0 < 26)
)

# -- SRQ-20: Self-Reporting Questionnaire (mental distress) -- PRIMARY OUTCOME --
# 20 yes/no items about mental health symptoms in the past month.
# Scores range from 0 to 20. HIGHER scores = GREATER mental distress.
# Source: Table 1. Control: 7.0 (4.7), Intervention: 7.9 (5.2). Pooled: 7.45 (5.00).
srq20_0 <- round(clamp(rnorm(N, mean = 7.45, sd = 5.00), lo = 0, hi = 20))

# -- SCI-R: Self-Care Inventory Revised (diabetes self-care adherence) --
# Scores range from 0 to 56. HIGHER scores = BETTER adherence to self-care.
# Source: Table 1. Control: 36.5 (5.9), Intervention: 35.2 (6.8). Pooled: 35.85 (6.40).
#   Protocol: "Total score on the Brazilian version of the Self-Care Inventory
#   Revised (SCI-R) questionnaire ... presented as a total score ranging from
#   0 to 56 points."
sci_r_0 <- clamp(rnorm(N, mean = 35.85, sd = 6.40), lo = 0, hi = 56)

# -- PSS: Perceived Stress Scale --
# Scores range from 0 to 40. HIGHER scores = GREATER perceived stress.
# Source: Table 1. Control: 23.6 (10.3), Intervention: 20.6 (10.3). Pooled: 22.10 (10.35).
pss_0 <- clamp(rnorm(N, mean = 22.10, sd = 10.35), lo = 0, hi = 40)

# -- SF-36: 36-Item Short Form Health Survey (quality of life) --
# Scores range from 0 to 100. HIGHER scores = BETTER quality of life.
# Source: Table 1. Control: 50.2 (21.5), Intervention: 50.9 (22.2). Pooled: 50.55 (21.85).
sf36_0 <- clamp(rnorm(N, mean = 50.55, sd = 21.85), lo = 0, hi = 100)

# -- HbA1c: Hemoglobin A1c (glycemic control) --
# Reported as percentage of total hemoglobin. LOWER values = BETTER glycemic control.
# A value below 4.5% is physiologically implausible; we use that as the floor.
# Source: Table 1. Control: 7.8% (1.5%), Intervention: 8.0% (1.6%). Pooled: 7.90 (1.55).
hba1c_0 <- clamp(rnorm(N, mean = 7.90, sd = 1.55), lo = 4.5, hi = 18)


# =============================================================================
# 4. FOLLOW-UP OUTCOME MODEL (week 12)
# =============================================================================
# We use an ANCOVA (Analysis of Covariance) generating model for each outcome.
# The follow-up value for participant i is:
#
#   y_12i = alpha + tau * group_i + beta * y_0i + error_i
#
# Where:
#   alpha  = intercept, calibrated so the control group mean matches the
#            published baseline-adjusted follow-up mean from Table 2
#   tau    = treatment effect (mean difference, intervention minus control),
#            taken directly from the baseline-adjusted column of Table 2
#   beta   = how much of the baseline value carries forward (set to 0.70 for
#            all outcomes; see docs/simulation-assumptions.md for rationale)
#   error  = random noise, drawn from a normal distribution with SD chosen to
#            reproduce the published standard errors from Table 2
#
# NOTE: We use the BASELINE-ADJUSTED model from Table 2 (not the fully
# adjusted model). The baseline-adjusted model controls only for the baseline
# value of the outcome. The fully adjusted model additionally controls for
# age, sex, education, income, and MMSE. Students will fit both models in
# later exercises and compare the estimates.

beta <- 0.70  # baseline-to-follow-up regression coefficient (same for all outcomes)

# ---- Helper: simulate one follow-up outcome ----
# Arguments:
#   y0        : vector of baseline values for all N participants
#   group     : vector of group assignments (1=intervention, 0=control)
#   ctrl_mean : published adjusted control-group mean at 12 weeks (from Table 2)
#   tau       : published treatment effect (intervention - control) from Table 2
#   resid_sd  : residual standard deviation, calibrated to match published SE
#   lo, hi    : floor and ceiling for the instrument score range
#   round_int : if TRUE, round to nearest integer (for integer-scored instruments)
#
# Why center y0 at its grand mean?
# In ANCOVA, the 'adjusted means' reported in Table 2 are estimated at the
# grand mean of the baseline covariate (not the group-specific mean). Centering
# y0 ensures that our alpha equals the control group's adjusted mean directly,
# and that the treatment effect tau is recovered regardless of any baseline
# imbalance between the two groups.
sim_followup <- function(y0, group, ctrl_mean, tau,
                         resid_sd, lo = -Inf, hi = Inf,
                         round_int = FALSE) {
  y0_centered <- y0 - mean(y0)  # center at grand mean so alpha = control adjusted mean
  alpha       <- ctrl_mean      # intercept = published control group adjusted mean

  y12 <- alpha + tau * group + beta * y0_centered + rnorm(length(y0), mean = 0, sd = resid_sd)
  y12 <- clamp(y12, lo = lo, hi = hi)
  if (round_int) y12 <- round(y12)
  y12
}

# -- SRQ-20 at 12 weeks (PRIMARY OUTCOME) --
# Published baseline-adjusted MD: -1.28 (95% CI: -2.51 to -0.04; p = .04)
# Source: Table 2. Control adjusted mean: 7.66; Intervention adjusted mean: 6.39.
# Residual SD calibrated from SE: SE ≈ 0.45, n_complete ≈ 103 per group ≈ 51.5
#   SE ≈ resid_sd * sqrt(2/n) --> resid_sd ≈ 0.45 / sqrt(2/103) * sqrt(2) ≈ 2.3
srq20_12 <- sim_followup(
  y0       = srq20_0,
  group    = group,
  ctrl_mean = 7.66,    # Table 2, baseline-adjusted control mean at 12 weeks
  tau      = -1.28,    # Table 2, baseline-adjusted MD (intervention - control)
  resid_sd = 2.30,
  lo = 0, hi = 20,
  round_int = TRUE
)

# -- SF-36 at 12 weeks (quality of life) --
# Published baseline-adjusted MD: +9.46 (95% CI: 3.65 to 15.26; p = .001)
# Source: Table 2. Higher = better quality of life.
# CI width = 15.26 - 3.65 = 11.61; SE ≈ 11.61 / (2 * 1.96) ≈ 2.96
# resid_sd ≈ 2.96 * sqrt(103/2) ≈ 15.0
sf36_12 <- sim_followup(
  y0       = sf36_0,
  group    = group,
  ctrl_mean = 49.0,    # approximated from published group means
  tau      = 9.46,
  resid_sd = 15.0,
  lo = 0, hi = 100
)

# -- SCI-R at 12 weeks (diabetes self-care adherence) --
# Published baseline-adjusted MD: +3.40 (95% CI: 1.61 to 5.19; p < .001)
# Source: Table 2. Higher = better self-care.
# CI width = 5.19 - 1.61 = 3.58; SE ≈ 3.58 / (2 * 1.96) ≈ 0.91
# resid_sd ≈ 0.91 * sqrt(103/2) ≈ 4.6
sci_r_12 <- sim_followup(
  y0       = sci_r_0,
  group    = group,
  ctrl_mean = 36.0,
  tau      = 3.40,
  resid_sd = 4.60,
  lo = 0, hi = 56
)

# -- HbA1c at 12 weeks (glycemic control) --
# Published baseline-adjusted MD: -0.48% (95% CI: -0.85 to -0.11; p = .01)
# Source: Table 2. Lower = better glycemic control.
# CI width = 0.85 - 0.11 = 0.74; SE ≈ 0.74 / (2 * 1.96) ≈ 0.19
# resid_sd ≈ 0.19 * sqrt(103/2) ≈ 0.97
hba1c_12 <- sim_followup(
  y0       = hba1c_0,
  group    = group,
  ctrl_mean = 8.04,
  tau      = -0.48,
  resid_sd = 0.97,
  lo = 4.5, hi = 18
)

# -- PSS at 12 weeks (perceived stress) --
# Published baseline-adjusted MD: -3.00 (95% CI: -6.20 to 0.20; p = .07)
# Source: Table 2. This effect was NOT statistically significant.
# The CI crosses zero, meaning we cannot rule out no effect.
# CI width = 6.20 + 0.20 = 6.40; SE ≈ 6.40 / (2 * 1.96) ≈ 1.63
# resid_sd ≈ 1.63 * sqrt(103/2) ≈ 8.3
pss_12 <- sim_followup(
  y0       = pss_0,
  group    = group,
  ctrl_mean = 21.0,
  tau      = -3.00,    # negative = lower stress; but CI crosses zero
  resid_sd = 8.30,
  lo = 0, hi = 40
)


# =============================================================================
# 5. MISSING DATA
# =============================================================================
# In the real trial, 9 of 112 participants (8.0%) did not complete the 12-week
# follow-up. Reasons: 6 lost to follow-up, 3 died.
# Source: Results text; Figure 1.
#
# Completers by group: 52 intervention, 51 control (implies 4 missing from
# intervention and 5 from control).
#
# Mechanism: We implement Missing at Random (MAR). Within each group, we select
# participants to be missing based on their baseline SRQ-20 score: those with
# higher baseline mental distress are more likely to drop out. This is a
# clinically plausible mechanism.
#
# missing_12wk = 1 means the participant has no follow-up data.
# reason_missing: "lost_to_followup", "death", or NA (completed).

# Select the 5 control participants with highest baseline SRQ-20 as missing.
# Select the 4 intervention participants with highest baseline SRQ-20 as missing.
# This reproduces the published group-specific counts exactly.
control_ids      <- which(group == 0)
intervention_ids <- which(group == 1)

# Rank by baseline SRQ-20 (descending) within each group
ctrl_missing_idx <- control_ids[order(srq20_0[control_ids], decreasing = TRUE)[1:5]]
int_missing_idx  <- intervention_ids[order(srq20_0[intervention_ids], decreasing = TRUE)[1:4]]

missing_12wk <- integer(N)
missing_12wk[c(ctrl_missing_idx, int_missing_idx)] <- 1L

# Assign reasons: 3 of the 9 missing participants 'died'; the rest were lost to follow-up.
# The paper does not report which group the deaths occurred in; we split them 2 control / 1 intervention.
reason_missing <- rep(NA_character_, N)
reason_missing[ctrl_missing_idx[1:2]]  <- "death"
reason_missing[int_missing_idx[1]]     <- "death"
reason_missing[ctrl_missing_idx[3:5]]  <- "lost_to_followup"
reason_missing[int_missing_idx[2:4]]   <- "lost_to_followup"

# Apply missingness: set all follow-up outcomes to NA for missing participants
srq20_12[missing_12wk == 1] <- NA
sf36_12 [missing_12wk == 1] <- NA
sci_r_12[missing_12wk == 1] <- NA
hba1c_12[missing_12wk == 1] <- NA
pss_12  [missing_12wk == 1] <- NA


# =============================================================================
# 6. ASSEMBLE THE DATA FRAME
# =============================================================================

dat <- tibble::tibble(
  # Identifiers
  participant_id  = seq_len(N),

  # Randomization
  group           = group,              # 1 = intervention, 0 = control

  # Demographics
  age             = round(age, 1),
  female          = female,             # 1 = female, 0 = male
  edu_years       = round(edu_years, 1),
  income_wages    = round(income_wages, 2),  # Brazilian minimum wages/month
  dm_duration_y   = round(dm_duration_y, 1),
  insulin         = insulin,            # 1 = uses insulin

  # Comorbidities
  hx_depression   = hx_depression,     # 1 = history of depression
  hx_anxiety      = hx_anxiety,        # 1 = history of anxiety

  # Baseline clinical measures (week -1)
  mmse_0          = mmse_0,            # 0-30, higher = better cognition
  cognitive_decline = cognitive_decline, # 1 = positive screening
  srq20_0         = srq20_0,           # 0-20, higher = worse distress
  sci_r_0         = round(sci_r_0, 1), # 0-56, higher = better self-care
  pss_0           = round(pss_0, 1),   # 0-40, higher = more stress
  sf36_0          = round(sf36_0, 1),  # 0-100, higher = better QoL
  hba1c_0         = round(hba1c_0, 2), # %, lower = better glycemic control

  # Follow-up measures (week 12) -- NA if missing
  srq20_12        = srq20_12,
  sci_r_12        = round(sci_r_12, 1),
  pss_12          = round(pss_12, 1),
  sf36_12         = round(sf36_12, 1),
  hba1c_12        = round(hba1c_12, 2),

  # Missingness
  missing_12wk    = missing_12wk,      # 1 = no follow-up data
  reason_missing  = reason_missing
)


# =============================================================================
# 7. VARIABLE LABELS
# =============================================================================
# Labels make the dataset self-documenting when students use str(), glimpse(),
# or view it in the RStudio data viewer.

dat <- dat |>
  set_variable_labels(
    participant_id   = "Participant ID (1 to 112)",
    group            = "Randomized group: 1 = smart speaker (intervention), 0 = usual care",
    age              = "Age at enrollment (years)",
    female           = "Sex: 1 = female, 0 = male",
    edu_years        = "Years of formal education",
    income_wages     = "Individual monthly income (Brazilian minimum wages)",
    dm_duration_y    = "Duration of type 2 diabetes diagnosis (years)",
    insulin          = "Insulin use at baseline: 1 = yes, 0 = no",
    hx_depression    = "History of depression: 1 = yes, 0 = no",
    hx_anxiety       = "History of anxiety: 1 = yes, 0 = no",
    mmse_0           = "MMSE score at baseline (0-30; higher = better cognition)",
    cognitive_decline = "Positive cognitive decline screening at baseline (MMSE-based): 1 = yes",
    srq20_0          = "SRQ-20 mental distress score at baseline (0-20; higher = worse)",
    sci_r_0          = "SCI-R diabetes self-care score at baseline (0-56; higher = better)",
    pss_0            = "PSS perceived stress score at baseline (0-40; higher = more stress)",
    sf36_0           = "SF-36 quality of life score at baseline (0-100; higher = better)",
    hba1c_0          = "HbA1c (%) at baseline (lower = better glycemic control)",
    srq20_12         = "SRQ-20 mental distress score at 12 weeks (primary outcome)",
    sci_r_12         = "SCI-R diabetes self-care score at 12 weeks",
    pss_12           = "PSS perceived stress score at 12 weeks",
    sf36_12          = "SF-36 quality of life score at 12 weeks",
    hba1c_12         = "HbA1c (%) at 12 weeks",
    missing_12wk     = "Missing at 12-week follow-up: 1 = missing",
    reason_missing   = "Reason for missing follow-up: 'death', 'lost_to_followup', or NA"
  )


# =============================================================================
# 8. SAVE OUTPUT
# =============================================================================
# The data/ directory is gitignored and will not be committed.
# Per standards/data-handling.md, data lives locally and is never pushed.

if (!dir.exists("data")) dir.create("data")
saveRDS(dat, file = "data/ivam_synthetic.rds")


# =============================================================================
# 9. VERIFICATION SUMMARY
# =============================================================================
# Print a brief summary so you can confirm the simulation ran correctly.
# These numbers should approximate (not exactly match) the published values.

cat("\n======================================================\n")
cat(" IVAM-ED Synthetic Dataset — Verification Summary\n")
cat("======================================================\n\n")

cat("Sample size and completion:\n")
cat("  Total enrolled:    ", nrow(dat), "\n")
cat("  Intervention (n):  ", sum(dat$group == 1), "\n")
cat("  Control (n):       ", sum(dat$group == 0), "\n")
cat("  Missing at 12 wks: ", sum(dat$missing_12wk), "(published: 9)\n")
cat("    - Intervention:  ", sum(dat$group == 1 & dat$missing_12wk == 1),
    "(published: 4)\n")
cat("    - Control:       ", sum(dat$group == 0 & dat$missing_12wk == 1),
    "(published: 5)\n\n")

cat("Key baseline characteristics (published in parentheses):\n")
cat(sprintf("  Age, mean (SD):       %.1f (%.1f)  [published: 72.5 (5.7)]\n",
    mean(dat$age), sd(dat$age)))
cat(sprintf("  Female, %%:            %.1f%%        [published: 63.4%%]\n",
    mean(dat$female) * 100))
cat(sprintf("  HbA1c %%, mean (SD):  %.1f (%.1f)  [published: 7.9 (1.5)]\n",
    mean(dat$hba1c_0), sd(dat$hba1c_0)))
cat(sprintf("  SRQ-20 baseline:      %.1f (%.1f)  [published: ctrl 7.0, int 7.9]\n",
    mean(dat$srq20_0), sd(dat$srq20_0)))

cat("\nFollow-up means and ANCOVA check (completers only):\n")
comp <- filter(dat, missing_12wk == 0)
raw_ctrl <- mean(comp$srq20_12[comp$group == 0], na.rm = TRUE)
raw_int  <- mean(comp$srq20_12[comp$group == 1], na.rm = TRUE)
cat(sprintf("  SRQ-20 ctrl raw 12wk:  %.2f\n", raw_ctrl))
cat(sprintf("  SRQ-20 int  raw 12wk:  %.2f\n", raw_int))
cat(sprintf("  Raw (unadjusted) MD:   %.2f\n", raw_int - raw_ctrl))
cat("  NOTE: Raw MD < published adj MD because intervention group started with\n")
cat("        higher baseline SRQ-20; ANCOVA adjusts for this (see below).\n\n")

# Fit the baseline-adjusted ANCOVA model (the model students will run in exercises)
ancova_fit <- lm(srq20_12 ~ group + srq20_0, data = comp)
tau_est    <- coef(ancova_fit)["group"]
tau_ci     <- confint(ancova_fit)["group", ]
cat(sprintf("  ANCOVA-adjusted MD:    %.2f  [published: -1.28]\n", tau_est))
cat(sprintf("  95%% CI:               %.2f to %.2f  [published: -2.51 to -0.04]\n",
    tau_ci[1], tau_ci[2]))

cat("\nDataset saved to: data/ivam_synthetic.rds\n")
cat("For documentation, see: docs/simulation-assumptions.md\n")
cat("======================================================\n\n")
