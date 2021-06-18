import delimited ../input/1976-2018-house3.csv, clear

* Select only voting results after 2010
keep if year > 2010

* Generate cdid
gen str2 state_id = string(state_fips,"%02.0f")
gen str2 within_state_cdid = string(district,"%02.0f")
egen cdid = concat(state_id within_state_cdid)
keep year cdid party candidatevotes

* Select only two parties and combine votes from the same party but different candidates
keep if inlist(party, "REPUBLICAN", "DEMOCRAT")
collapse (sum) candidatevotes, by(year cdid party)

* Compute the two-party supporting rate
reshape wide candidatevotes, i(year cdid) j(party) string
replace candidatevotesDEM = 0 if candidatevotesDEM == .
replace candidatevotesREP = 0 if candidatevotesREP == .
gen REP_rate = candidatevotesREP / (candidatevotesDEM + candidatevotesREP)
replace REP_rate = 0 if REP_rate == .
drop candidatevotes*

* reshape
reshape wide REP_rate, i(cdid) j(year)

* export
save cd_level_vote, replace
