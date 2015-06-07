# bpm
This repository contains Stata and Mplus code for an analysis of measurement error in readings of blood pressure. The analysis uses data from the Cebu Longitudinal Health and Nutrition Survey (CLHNS). Information about obtaining CLHNS data can be found at http://www.cpc.unc.edu/projects/cebu. The results are reported in Bauldry, Bollen, and Adair (2015).

## Files
1. bpm-data-2.do: Stata program that prepares CLHNS data for analysis.
2. bpm-desc-2.do: Stata program that produces descriptive statistics.
3. bpm-meas-2.do: Stata program that calculates validity (see Table II in paper).
4. bpm-mtmm-xx-x.inp: Series of Mplus programs for separate multi-trait multi-method models for females/males (f/m) at waves 1/2/3 with model specifications 1/2/3.
5. bpm-mtmm-cfa-x-x.inp: Series of Mplus programs for CFA multi-trait multi-method models for females/males with model specifications 1/2/3.
6. bpm-mtmm-mg-cfa-x.inp: Series of Mplus programs for multiple-group CFA multi-trait multi-method models with model model specifications 1/2/3.

## References
Bauldry, Shawn, Kenneth A. Bollen, Linda S. Adair. 2015. "Evaluating Measurement Error in Readings of Blood Pressure for Adolescents and Young Adults." *Blood Pressure* 24:96-102.
