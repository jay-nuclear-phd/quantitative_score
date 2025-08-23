# Validation Performance Assessment through Quantitative Score Focused on Benchmark Selection for Nuclear Criticality Safety

This repository contains the necessary files to reproduce the results presented in the paper "Validation Performance Assessment through Quantitative Score Focused on Benchmark Selection for Nuclear Criticality Safety".

## File Descriptions

*   **`.m` files**: These are MATLAB scripts used to generate the figures in the paper. Each script is named after the figure it generates (e.g., `Figure2.m` generates Figure 2).
*   **`Drawn_Figures.pptx`**: This PowerPoint file contains the original versions of Figures 1, 4, and 5, which were drawn manually.
*   **`sdf_file_processor.py`**: This Python script was used to process the sensitivity profiles from the `.sdf` files. It extracts the sensitivity profiles for `HMF-015-001`, `HMF-016-001`, and `HST-001-001`, and saves the SCALE group structure in `scale_252group_boundaries`.
*   **`names.txt`**: This file lists the names of the benchmarks used in this study.

## Data Files

The following data files are used in the MATLAB scripts:

*   `Ck`: Calculated covariance matrix.
*   `Cm`: Measured covariance matrix.
*   `k`: Calculated k-effective values.
*   `m`: Measured k-effective values.

## How to Reproduce the Results

1.  Run the `.m` scripts in MATLAB to generate the corresponding figures.
2.  The data files (`Ck`, `Cm`, `k`, `m`, etc.) are loaded by the MATLAB scripts to perform the calculations and generate the plots.
