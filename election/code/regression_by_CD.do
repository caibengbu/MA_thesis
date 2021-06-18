* merge election data with trade shock data

use cd_level_vote, replace
merge 1:1 cdid using ../input/shift_share_CD_TS, keep(matched) nogen

* generate voterchange
gen voterchange_2012_2014 = REP_rate2014 - REP_rate2012
gen voterchange_2014_2016 = REP_rate2016 - REP_rate2014
gen voterchange_2016_2018 = REP_rate2018 - REP_rate2016

* generate lgTS
gen lgTS = log(TS_shift)

scatter voterchange_2016_2018 TS
