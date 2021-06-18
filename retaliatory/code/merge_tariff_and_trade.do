* Prepare HS10 2017 US-China trade data

* Use data from RIGVC
import sas ../input/imp2017.sas7bdat, clear
keep if ctyo == 502
keep HS8 value
collapse (sum) value, by(HS8)
tempfile trade
save `trade'

** Use data from US trade
// import delimited using 2017-us-export-to-china.csv, rowrange(5) delimiter(",") varnames(4) clear
// replace valueus = subinstr(valueus,",","",.)
// destring valueus, gen(val)
// gen hs10 = regexs(0) if(regexm(commodity, "^[0-9]*"))
// gen hs8 = substr(hs10,1,8)
// keep val hs8
// collapse (sum) val, by(hs8)
// rename hs8 HS8

* Prepare tariff data
import delimited using ../output/retaliatory_rate_hs8.csv,colrange(2) stringcols(1) clear
rename final_hs8 HS8

merge 1:1 HS8 using `trade', keep(matched) nogen
gen TS = tariff*value
gen HS6 = substr(HS8,1,6)
collapse (sum) TS, by(HS6)

tempfile trade_shock_by_HS6
save `trade_shock_by_HS6'

infix str HS10 1-10 str naics 266-271 using ../input/exp-code.txt, clear
* keep if year == 2017
* gen str10 hs10 = string(commodity,"%010.0f")
* gen HS8 = substr(hs10,1,8)
* bys HS8 naics: gen tag = cond(_N == 1, 0, _n)
* keep if tag <= 1
* keep HS8 naics

gen HS6 = substr(HS10,1,6)
gen NAICS_3 = substr(naics,1,3)
bys HS6 NAICS_3: gen tag = cond(_N == 1, 0, _n)
keep if tag <= 1
keep HS6 NAICS_3

merge m:1 HS6 using `trade_shock_by_HS6', keep(matched) nogen
collapse (sum) TS, by(NAICS_3)
save ../output/TS_by_NAICS, replace

