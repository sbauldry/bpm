*** Purpose: to prepare descriptive statistics for BP measurement analysis
*** Author: S Bauldry
*** Date: June 21, 2013


*** loading prepared data
use "bpm-data-2", replace

*** sex distribution
tab male

*** age distribution
sum age1 age2 age3

*** number of observations by wave
preserve 
collapse (count) sbp11 sbp12 sbp13, by(male)
format _all %5.0f
list, clean sum 
restore

*** box plots for blood pressure readings
preserve
reshape long dbp1 dbp2 dbp3 sbp1 sbp2 sbp3, i(uncchdid) j(wave)

lab def sex 1 "male" 0 "female"
lab val male sex

lab def wv 1 "Wave 1" 2 "Wave 2" 3 "Wave 3"
lab val wave wv

graph box sbp1 sbp2 sbp3, over(wave) by(male) scheme(s2mono) title("SBP") ///
  legend(row(1) order(1 "read 1" 2 "read 2" 3 "read 3"))

graph box dbp1 dbp2 dbp3, over(wave) by(male) scheme(s2mono) title("DBP") ///
  legend(row(1) order(1 "read 1" 2 "read 2" 3 "read 3"))
restore



