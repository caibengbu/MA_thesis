* prepare the zip-cd crosswalk data 
* (retrieved from https://www.huduser.gov/portal/datasets/usps_crosswalk.html#data)
import excel "../input/ZIP_CD_032016.xlsx", firstrow clear
rename ZIP zipcode
tempfile zip_cd_crosswalk
save `zip_cd_crosswalk'

* import ZBP data 
import delimited "../input/zbp16detail.txt", clear
keep if substr(naics,5,6)=="//"

* adjust agriculture
replace naics="1110//" if naics=="1151//"
replace naics="1120//" if naics=="1152//"
replace naics="1130//" if naics=="1153//"

* generate string zip
gen str5 zipcode = string(zip,"%05.0f")

* merge with the crosswalk file
merge m:m zipcode using `zip_cd_crosswalk', keep(matched) nogen


*    Result                           # of obs.
*    -----------------------------------------
*    not matched                        28,783
*        from master                    27,216  (_merge==1)
*        from using                      1,567  (_merge==2)
*
*    matched                         8,391,067  (_merge==3)
*    -----------------------------------------

* merged establishments: 46263316
* unmerged establishments: 212526
* fraction of unmerged establishments: 0.457%

* generates new variables by cd
local zbp_vars est n1_4 n5_9 n10_19 n20_49 n50_99 n100_249 n250_499 n500_999 n1000
foreach var of varlist `zbp_vars'{
	replace `var' = `var' * BUS_RATIO
}
keep naics CD `zbp_vars'
collapse (sum) `zbp_vars',by(naics CD)

* use midpoint of the inteval to impute the employment
gen emp = n1_4*2.5 + n5_9*7 + n10_19*14.5 + n20_49*34.5 + ///
n50_99*74.5 + n100_249*174.5 + n250_499*374.5 + n500_999*749.5 + n1000*2000

* keep 3 dig naics
gen NAICS_3 = substr(naics,1,3)
keep NAICS_3 CD emp
collapse (sum) emp, by(NAICS_3 CD)

* gen emp share
bys NAICS_3: egen emp_ttl = sum(emp)
gen emp_share = emp/emp_ttl

save ../output/emp_by_NAICS_CD, replace
