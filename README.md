Conceptual Framework for Judicial Digital Transformation Based on Organizational Ontology

https://zenodo.org/badge/DOI/10.5281/zenodo.20834959.svg

This repository contains the complete research materials for the Conceptual Framework for Judicial Digital Transformation Based on Organizational Ontology. The project integrates governance, judicial processes, digital technologies, and performance evaluation into a unified semantic model using OWL 2 DL, SROIQ(D) description logic, and SWRL semantic rules.

Abstract

Digital transformation in judicial systems, beyond digitization, requires the integration of governance, judicial processes, and legal information based on a shared semantic framework. Despite the development of judicial systems, semantic heterogeneity and information silos remain major barriers to interoperability and integration. This research presents a conceptual framework for judicial digital transformation using an organizational ontology approach, developed with the METHONTOLOGY methodology and utilizing OWL 2 DL, SROIQ(D) description logic, and SWRL semantic rules to unify governance, process, technology, and performance evaluation layers.

The framework was validated using a case study of 210 real cases, simulation of 1,250 cases in AnyLogic, and expert evaluation. Results confirmed the framework's strong performance with an F1-score of 96.3% and high reliability (ICC = 0.89, κ = 0.85). Additionally, the framework reduced the case processing cycle time from 42 to 18 days, the backlog rate from 24.5% to 5.2%, and the digital evidence verification time from 72 to 4.5 hours (p < 0.001, Cohen's d = 1.84). By creating a unified semantic infrastructure, this framework enhances interoperability, interpretable decision-making, and the efficiency of judicial processes, providing a foundation for digital transformation in judicial systems.

Keywords: Judicial Digital Transformation; Organizational Ontology; Semantic Interoperability; Judicial Information Systems; Digital Governance; Explainable Artificial Intelligence (XAI)

Persistent Identifiers

Component Identifier
Ontology (OWL/XML) https://zenodo.org/badge/DOI/10.5281/zenodo.20834959.svg
GitHub Repository https://img.shields.io/badge/GitHub-Repository-blue

The ontology is permanently archived on Zenodo and can be cited independently of the code repository.

Repository Structure

Analytical-and-simulation-codes-for-judicial-ontology-framewok/
│
├── 1_Ontology/
│ └── Judicial_Ontology_Full_Project-EN.owl # OWL 2 DL ontology (also on Zenodo)
│
├── 2_Data/
│ ├── Raw_Data/
│ │ ├── Judicial_Cases_Control.csv # Full control group data (210 cases)
│ │ ├── Judicial_Cases_Experimental.csv # Full experimental group data (210 cases)
│ │ └── Appendix_A_Full_Mapping_Matrix-EN.xlsx # Mapping matrix for qualitative codes to ontology elements
│ └── Sample_Data/
│ ├── Judicial_1-50-Cases_Control.csv # 50-case sample (control)
│ └── Judicial_1-50-Cases_Experimental.csv # 50-case sample (experimental)
│
├── 3_Scripts/
│ ├── SPSS/
│ │ └── Judicial_Analysis.sps # SPSS syntax for statistical analyses
│ └── R/
│ └── judicial_analysis.r # R script for descriptive & inferential stats
│
├── 4_Simulation/
│ └── Judicial_Process_Simulation_Full_EN.alp # AnyLogic simulation model (1,250 cases)
│
├── 5_Results/ # Generated outputs (figures, tables, logs)
│ └── README.md # Guidelines for output organization
│
├── README.md # This file
└── .gitignore # Ignored files (temporary, OS-specific)

Ontology Overview

The core ontology (1_Ontology/Judicial_Ontology_Full_Project-EN.owl) models the judicial domain using OWL 2 DL and SROIQ(D) description logic. It includes:

28 Classes (e.g., Judicial_Actor, Judicial_Process, Legal_Document, Digital_Enabler, Performance_Metric)

54 Object Properties (e.g., isVerifiedBy, usesTechnology, assignJudgeToCase)

32 Data Properties (e.g., hasProcessingTime, hasBacklogRate)

342 Axioms

210 Individuals (real case instances)

12 SWRL Rules for intelligent decision support (bottleneck detection, evidence verification, case referral)

Key SWRL Rules Examples:

Automatic Delay Detection:
Judicial_Process(?p) ∧ hasProcessingTime(?p, ?t) ∧ swrlb:greaterThan(?t, 30) → hasPerformanceIssue(?p, true)

Digital Evidence Verification:
Digital_Evidence(?e) ∧ hasBlockchainHash(?e, ?h) ∧ isRegisteredIn(?h, ?block) ∧ Decentralized_Tech(?block) → isAdmissible(?e, true)

Intelligent Case Referral:
Legal_Document(?doc) ∧ hasCaseType(?doc, "Cybercrime") ∧ Judge(?j) ∧ hasExpertise(?j, "Digital_Forensics") → assignJudgeToCase(?j, ?doc)

How to Reproduce

Prerequisites

R (≥ 4.0) with packages: tidyverse, ggplot2, caret, irr, psych

IBM SPSS Statistics (≥ 25) or PSPP (open-source alternative)

AnyLogic 8.8.4 (for simulation)

Protégé 5.5.0 (for ontology editing and reasoning)

Step-by-Step

Clone this repository:
git clone https://github.com/alireza-zohali/Analytical-and-simulation-codes-for-judicial-ontology-framewok.git
cd Analytical-and-simulation-codes-for-judicial-ontology-framewok

Run Statistical Analyses:

R: Open 3_Scripts/R/judicial_analysis.r in RStudio. Run the script line-by-line or source it. Outputs (tables/figures) will be saved in 5_Results/1_Statistical_Analysis/R_Outputs/.

SPSS: Open 3_Scripts/SPSS/Judicial_Analysis.sps and execute the syntax. Save the output viewer file (.spv) in 5_Results/1_Statistical_Analysis/SPSS_Outputs/.

Run Judicial Process Simulation:

Open 4_Simulation/Judicial_Process_Simulation_Full_EN.alp in AnyLogic.

Configure simulation parameters (case arrival rate, judge profiles, resource allocation) as described in the article.

Run the simulation and export performance metrics (cycle time, backlog, verification time) to 5_Results/3_Simulation_Outputs/.

Validate Ontology:

Open 1_Ontology/Judicial_Ontology_Full_Project-EN.owl in Protégé.

Run reasoners (HermiT, Pellet) to check consistency and classify the ontology.

Execute SQWRL queries to test competency questions (see Section 4-2 of the article).

Inspect Results:

All generated output files will appear in the 5_Results/ folder, organized by data type (statistical, validation, simulation).

Key Findings (from the Article)

Metric Control Group Experimental Group Improvement p-value Effect Size (Cohen's d)
Case Processing Cycle Time (days) 42.0 18.0 57.1% < 0.001 1.84
Case Backlog Rate (%) 24.5% 5.2% 78.8% < 0.001 1.52
Digital Evidence Verification Time (hours) 72.0 4.5 93.7% < 0.001 2.11

Model Performance:

Accuracy: 97.4%

Recall: 95.2%

F1-score: 96.3%

Inter-rater Reliability (ICC): 0.89

Cohen's Kappa (κ): 0.85

Citation

If you use this repository, the ontology, or the simulation framework in your research, please cite the following:

Zohali, A., Nasiri, R., & Vaziri, B. (2026). Conceptual Framework for Judicial Digital Transformation Based on Organizational Ontology (Version 1.0) [Data set]. Zenodo. https://doi.org/10.5281/zenodo.20834959

BibTeX:
@misc{zohali2026judicial,
author = {Zohali, Alireza and Nasiri, Ramin and Vaziri, Babak},
title = {Conceptual Framework for Judicial Digital Transformation Based on Organizational Ontology},
year = {2026},
publisher = {Zenodo},
doi = {10.5281/zenodo.20834959},
url = {https://doi.org/10.5281/zenodo.20834959}
}

License

This project is licensed under the MIT License – see the LICENSE file for details.

Contributing

Contributions to improve reproducibility, extend the ontology, or enhance the simulation are welcome. Please open an issue or submit a pull request.

Contact

Alireza Zohali – alireza.zohali@gmail.com
GitHub: @alireza-zohali

Co-authors:

Dr. Ramin Nasiri – r_nasiri@iauctb.ac.ir

Dr. Babak Vaziri – vaziribabak@gmail.com

Acknowledgments

The authors thank the judges and domain experts who participated in the validation panel, and the anonymous reviewers for their constructive feedback.

