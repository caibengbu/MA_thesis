use ../output/TS_by_NAICS.dta, clear
merge 1:m NAICS_3 using ../input/emp_by_NAICS_CD.dta, keep(matched) nogen
gen TS_shift_share = TS*emp_share
collapse (sum) TS_shift_share, by(CD)
rename CD cdid
save ../output/shift_share_CD_TS, replace
