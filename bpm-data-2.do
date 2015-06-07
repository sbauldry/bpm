*** Purpose: To prepare data for measurement analysis of blood pressure
*** Author: S Bauldry
*** Date: June 14, 2013

*** loading raw blood pressure data provided by Linda
use bpic980205.dta, replace

*** renaming blood pressure readings
foreach x in sbp dbp {
	renames `x'1998a `x'2002a `x'2005a \ `x'11 `x'12 `x'13
	renames `x'1998b `x'2002b `x'2005b \ `x'21 `x'22 `x'23
	renames `x'1998c `x'2002c `x'2005c \ `x'31 `x'32 `x'33
}

*** setting blood pressure readings to missing for pregnant women
renames pregnant2002 pregnant2005 \ preg2 preg3
foreach x in sbp dbp {
	forval read = 1/3 {
		forval wave = 2/3 {
			replace `x'`read'`wave' = . if preg`wave' == 1
		}
	}
}

*** renaming sex
rename sex male

*** renaming age variables
rename age1998 age1
rename age2002 age2
rename age2005 age3

*** just keeping analysis variables
keep uncchdid basebrgy male dbp11-dbp33 sbp11-sbp33 age1-age3

*** dropping cases missing across all waves
drop if mi(sbp11) & mi(sbp12) & mi(sbp13)

*** compressing data and setting formats
compress
format dbp11-sbp33 %5.0g

*** saving data for descriptives in Stata
save "bpm-data-2", replace

*** saving data for analysis in Mplus
preserve
recode _all (. = -9)
desc
outsheet using "bpm-data-2.txt", replace comma nolabel noname 
restore


