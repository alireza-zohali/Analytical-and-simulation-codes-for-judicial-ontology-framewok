# Judicial Digital Transformation - Analysis & Simulation

This repository contains the complete analytical scripts and simulation models for the paper:
"Conceptual Framework for Digital Transformation of Judicial Proceedings with Organizational Ontology Approach"

## Contents
- `analysis.R`: Complete R script for statistical tests (t-test, ANCOVA, bootstrapping, Cohen's d)
- `analysis.py`: Python version of the same statistical analysis
- `simulation.py`: Discrete-event simulation using SimPy (open-source alternative to AnyLogic)
- `AnyLogic_Model_Structure.txt`: Guide to implement the simulation in AnyLogic 8.8

## Requirements
- R (>= 4.2) with packages: tidyverse, car, psych, boot, effsize
- Python (>= 3.8) with packages: numpy, pandas, scipy, statsmodels, simpy

## Usage
Run `Rscript analysis.R` or `python analysis.py` to reproduce the statistical results.
Run `python simulation.py` to execute the process simulation.
