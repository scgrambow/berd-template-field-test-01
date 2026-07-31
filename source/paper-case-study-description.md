# IVAM-ED as a CRP 241 Teaching Case

The IVAM-ED study evaluated whether a voice-activated virtual assistant could support mental health and diabetes self-management among older adults with type 2 diabetes. Investigators conducted a single-center, two-group randomized clinical trial in Brazil involving 112 adults aged 65 years or older. Participants were assigned in equal proportions to receive either usual care or a smart speaker programmed to provide medication and glucose-testing reminders, health messages, educational podcasts, and other supportive content over 12 weeks. The primary outcome was mental distress measured with the 20-item Self-Reporting Questionnaire. Secondary outcomes included HbA1c, blood pressure, lipid measurements, perceived stress, diabetes self-care, and quality of life.

At 12 weeks, outcome data were available for 103 participants. In the prespecified adjusted analysis, the mean mental-distress score was 1.46 points lower in the intervention group than in the usual-care group (95% CI, −2.73 to −0.19; P = .02). The intervention group also had better results for HbA1c, diabetes self-care, and quality of life, although these secondary findings were considered exploratory because the investigators evaluated multiple outcomes without adjustment for multiple comparisons. The [results paper](https://jamanetwork.com/journals/jamanetworkopen/fullarticle/2844212) was published in *JAMA Network Open* in 2026. A separate [protocol and statistical analysis plan](https://link.springer.com/article/10.1186/s13063-024-08055-3) had been published in *Trials* in 2024.

This study is a strong fit for CRP 241 because it combines an accessible clinical question with a manageable study design and several statistical concepts covered in an introductory clinical research course. It is a conventional two-group randomized trial with baseline and follow-up measurements, clinically recognizable variables, a clearly defined primary outcome, and an analysis based on confidence intervals and linear regression. Both publications are open access under Creative Commons Attribution licenses, allowing the course repository to remain public with appropriate attribution. The protocol publication also includes a SPIRIT checklist, intervention details, visit schedules, and an SAP checklist. These materials allow students to work from the research question and protocol through the analysis and interpretation of the published findings.

A simulated participant-level dataset could be constructed to approximate the sample sizes, distributions, correlations, missingness, and treatment effects reported in the publications. It would be identified clearly as synthetic and would not be presented as reconstructed study data. The simulation code could generate a new dataset reproducibly, while a fixed version could be supplied for student exercises.

The case could support a sequence of CRP 241 activities:

1. **Data structure and reproducibility:** Import the simulated data, inspect variable types, apply labels, identify missing values, and document the analysis using an R project and Quarto.

2. **Descriptive statistics:** Summarize demographic and clinical characteristics using means, standard deviations, medians, frequencies, and percentages. Construct a baseline characteristics table and discuss why significance tests of baseline differences are generally not appropriate in a randomized trial.

3. **Data visualization:** Examine the distributions of mental-distress scores and HbA1c, display individual changes from baseline, and compare follow-up outcomes by randomized group.

4. **Estimation and hypothesis testing:** Calculate group-specific means, mean changes, between-group differences, 95% confidence intervals, and P values. Distinguish a within-group change from the randomized between-group comparison.

5. **Linear regression and ANCOVA:** Begin with an unadjusted treatment-group comparison and then fit a baseline-adjusted ANCOVA model. Students could interpret the treatment coefficient and examine how adjustment for the baseline outcome changes precision.

6. **Missing data:** Compare a complete-case analysis with a simple sensitivity analysis. Multiple imputation could be provided as an instructor demonstration or advanced extension rather than required introductory material.

7. **Interpretation and critical appraisal:** Separate statistical significance from clinical importance, distinguish primary from exploratory findings, and consider the consequences of evaluating several secondary outcomes.

8. **Protocol-to-publication comparison:** Compare the published analysis with the protocol and SAP. Students could identify changes in subgroup definitions, the addition of a post hoc subgroup, and the reporting of secondary-outcome P values despite language in the SAP indicating that such P values would not be reported.

The IVAM-ED case would therefore function as more than an isolated coding exercise. It would connect study design, data management, descriptive statistics, statistical modeling, reproducibility, and interpretation within a single clinical investigation. It is sufficiently straightforward for introductory work while providing optional extensions for more advanced students.
