*** Purpose: to analyze linear combinations for blood pressure measurement
*** Author: S Bauldry
*** Date: July 19, 2013


*** loading prepared data
use "bpm-data-2", replace

*** finding weighted variances
forval i = 1/3 {
	gen sbp`i'Sum1 = 1/3*sbp1`i' + 1/3*sbp2`i' + 1/3*sbp3`i'
	gen dbp`i'Sum1 = 1/3*dbp1`i' + 1/3*dbp2`i' + 1/3*dbp3`i'
}

forval i = 0/1 {
	foreach x of varlist *Sum1 {
		qui sum `x' if male == `i', detail 
		dis "male = `i', `x', var = " as res %5.3f r(Var)
	}
}


gen sbp1Sum2 = 0.140*sbp11 + 0.034*sbp21 + 0.826*sbp31 + 0.000*dbp11 + 0.000*dbp21 + 0.000*dbp31 if male == 0
gen dbp1Sum2 = 0.000*sbp11 - 0.001*sbp21 + 0.003*sbp31 + 0.353*dbp11 + 0.457*dbp21 + 0.187*dbp31 if male == 0
gen sbp2Sum2 = 0.217*sbp12 + 0.380*sbp22 + 0.382*sbp32 + 0.009*dbp12 - 0.014*dbp22 + 0.018*dbp32 if male == 0
gen dbp2Sum2 = 0.006*sbp12 - 0.022*sbp22 + 0.027*sbp32 + 0.229*dbp12 + 0.439*dbp22 + 0.308*dbp32 if male == 0
gen sbp3Sum2 = 0.351*sbp13 + 0.231*sbp23 + 0.408*sbp33 - 0.044*dbp13 + 0.073*dbp23 - 0.023*dbp33 if male == 0
gen dbp3Sum2 = -0.010*sbp13	- 0.006*sbp23 + 0.022*sbp33	+ 0.223*dbp13 + 0.553*dbp23	+ 0.211*dbp33 if male == 0

replace sbp1Sum2 = 0.218*sbp11 + 0.361*sbp21 + 0.420*sbp31 - 0.008*dbp11 + 0.223*dbp21 - 0.215*dbp31 if male == 1
replace dbp1Sum2 = 0.021*sbp11 + 0.034*sbp21 - 0.055*sbp31 + 0.053*dbp11 + 0.756*dbp21 + 0.190*dbp31 if male == 1
replace sbp2Sum2 = 0.214*sbp12 + 0.506*sbp22 + 0.265*sbp32 - 0.011*dbp12 + 0.073*dbp22 - 0.053*dbp32 if male == 1
replace dbp2Sum2 = -0.008*sbp12 + 0.069*sbp22 - 0.054*sbp32 + 0.191*dbp12 + 0.398*dbp22 + 0.394*dbp32 if male == 1
replace sbp3Sum2 = 0.281*sbp13 + 0.296*sbp23 + 0.413*sbp33 + 0.017*dbp13 + 0.018*dbp23 - 0.030*dbp33 if male == 1
replace dbp3Sum2 = 0.019*sbp13 + 0.014*sbp23 - 0.029*sbp33 + 0.225*dbp13 + 0.279*dbp23	+ 0.489*dbp33 if male == 1
					
forval i = 0/1 {
	foreach x of varlist *Sum2 {
		qui sum `x' if male == `i', detail 
		dis "male = `i', `x', var = " as res %5.3f r(Var)
	}
}


		
		

*** preparing dataset of error variances, method variances, and weighted variances
clear
input male wave theta11 theta12 theta13 theta21 theta22 theta23 phim1 phim2 phim3 sbpv1 dbpv1 sbpv2 dbpv2 
0	1	0.024	0.100	0.004	0.274	0.211	0.517	0.000	0.000	0.000	78.729	54.034	78.74	53.965
0	2	4.722	2.556	2.731	3.957	1.887	3.087	0.632	0.543	0.320	84.848	69.11	82.373	67.102
0	3	1.284	2.551	1.173	1.929	0.758	2.223	0.739	0.287	0.513	102.282	72.517	100.67	71.42
1	1	0.266	0.192	0.113	0.464	0.034	0.068	0.067	0.005	0.121	117.344	80.459	117.271	80.517
1	2	5.216	2.772	4.006	4.879	2.904	1.913	0.676	0.000	0.895	116.792	87.006	114.515	85.276
1	3	2.459	2.329	1.540	1.847	1.448	0.663	0.277	0.262	0.339	113.961	86.841	112.254	85.939
end
 



****** program for calculating validity of linear combinations
capture program drop LinCom
program LinCom
	args bp1 bp2 sex wv v11 v12 v13 v21 v22 v23
	
	replace `bp1' = 1 - (( `v11'^2*theta11 + `v12'^2*theta12 + `v13'^2*theta13 + `v21'^2*theta21 + `v22'^2*theta22 + `v23'^2*theta23 + ///
                  `v11'^2*phim1 + `v12'^2*phim2 + `v13'^2*phim3 + `v21'^2*phim1 + `v22'^2*phim2 + `v23'^2*phim3 + ///
				  2*`v11'*`v21'*phim1 + 2*`v12'*`v22'*phim2 + 2*`v13'*`v23'*phim3 )/`bp2' ) if male == `sex' & wave == `wv'
end


*** simple averages
gen sbp1 = .
gen dbp1 = .

forval i = 0/1 {
	forval j = 1/3 {
		LinCom sbp1 sbpv1 `i' `j' 1/3 1/3 1/3 0 0 0
		LinCom dbp1 dbpv1 `i' `j' 0 0 0 1/3 1/3 1/3
	}
}



*** linear combinations with factor score weights
gen sbp2 = .
gen dbp2 = .

LinCom sbp2 sbpv2 0 1 0.140	0.034 0.826	0.000 0.000 0.000
LinCom dbp2 dbpv2 0 1 0.000	-0.001 0.003 0.353 0.457 0.187
LinCom sbp2 sbpv2 0 2 0.217	0.380 0.382	0.009 -0.014 0.018
LinCom dbp2 dbpv2 0 2 0.006	-0.022 0.027 0.229 0.439 0.308
LinCom sbp2 sbpv2 0 3 0.351	0.231 0.408	-0.044 0.073 -0.023
LinCom dbp2 dbpv2 0 3 -0.010 -0.006	0.022 0.223	0.553 0.211
					
LinCom sbp2 sbpv2 1 1 0.218	0.361 0.420	-0.008 0.223 -0.215
LinCom dbp2 dbpv2 1 1 0.021	0.034 -0.055 0.053 0.756 0.190
LinCom sbp2 sbpv2 1 2 0.214	0.506 0.265	-0.011 0.073 -0.053
LinCom dbp2 dbpv2 1 2 -0.008 0.069 -0.054 0.191	0.398 0.394
LinCom sbp2 sbpv2 1 3 0.281	0.296 0.413	0.017 0.018	-0.030
LinCom dbp2 dbpv2 1 3 0.019	0.014 -0.029 0.225 0.279 0.489


*** listing results
format sbp1 dbp1 sbp2 dbp2 %5.3f
list male wave sbp1 dbp1 sbp2 dbp2, clean
				  


