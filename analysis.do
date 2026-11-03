version 15.1
clear all
set more off

capture log close _all
log using "analysis.log", text replace

local data_file "data/annual_crime_data.dta"
confirm file "`data_file'"
use "`data_file'", clear

foreach variable in agency_id agency_name state year treated ///
    state_legalREC city_decrim met2013 mean_pop vio_rate prop_rate {
    confirm variable `variable'
}

keep if treated == 1 | ///
    (state_legalREC == 0 & city_decrim == 0 & ///
    !missing(met2013) & mean_pop > 100000)
keep if inlist(treated, 0, 1)

assert !missing(agency_id, year, treated)
isid agency_id year

local policy_year 2017
generate byte post = year >= `policy_year'
label variable post "Post-policy period (2017 onward)"

quietly count if treated == 1
local treated_observations = r(N)
assert `treated_observations' > 0
display as text "Treated agency-year observations in analysis sample: " ///
    as result `treated_observations'

quietly count if treated == 1 & year < `policy_year'
local treated_pre = r(N)
quietly count if treated == 1 & year >= `policy_year'
local treated_post = r(N)
assert `treated_pre' > 0
assert `treated_post' > 0

list agency_name state if treated == 1 & year == `policy_year', noobs

preserve
collapse (mean) vio_rate prop_rate, by(treated year)

twoway ///
    (connected vio_rate year if treated == 1, lcolor(navy) mcolor(navy)) ///
    (connected vio_rate year if treated == 0, lcolor(maroon) mcolor(maroon)) ///
    (lfit vio_rate year if treated == 1 & year < `policy_year', ///
        lcolor(navy) lpattern(dash)) ///
    (lfit vio_rate year if treated == 0 & year < `policy_year', ///
        lcolor(maroon) lpattern(dash)), ///
    title("Violent crime rates by treatment group") ///
    xtitle("Year") ytitle("Mean violent crime rate") ///
    legend(order(1 "Treated" 2 "Comparison" ///
        3 "Treated pre-policy fit" 4 "Comparison pre-policy fit"))
graph export "violent-crime-trends.png", replace

twoway ///
    (connected prop_rate year if treated == 1, lcolor(navy) mcolor(navy)) ///
    (connected prop_rate year if treated == 0, lcolor(maroon) mcolor(maroon)) ///
    (lfit prop_rate year if treated == 1 & year < `policy_year', ///
        lcolor(navy) lpattern(dash)) ///
    (lfit prop_rate year if treated == 0 & year < `policy_year', ///
        lcolor(maroon) lpattern(dash)), ///
    title("Property crime rates by treatment group") ///
    xtitle("Year") ytitle("Mean property crime rate") ///
    legend(order(1 "Treated" 2 "Comparison" ///
        3 "Treated pre-policy fit" 4 "Comparison pre-policy fit"))
graph export "property-crime-trends.png", replace
restore

foreach outcome in vio_rate prop_rate {
    display as text _newline "Difference-in-differences model: `outcome'"
    areg `outcome' i.treated##i.post i.year, ///
        absorb(agency_id) vce(cluster agency_id)
    test 1.treated#1.post
}

log close
