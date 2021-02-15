**Assign Zip codes to Counties
insheet using "[YOUR FILE LOCATION]Data\geocorr2018_zctz_to_cty.csv", clear name
drop in 1
destring pop10	afact zcta5 county, replace
bysort zcta5: egen max_share_in_cty=max( afact)
keep if max_share_in_cty>=afact
drop if max_share_in_cty==.
drop if afact==.
sort zcta afact
ren county ctyfip
ren cntyname countyname
collapse (first) ctyfip countyname pop10_zip=pop10 afact ,by(zcta5)
ren zcta5 zcta
save "[YOUR FILE LOCATION]Data\geocorr2018_zctz_to_cty.dta", replace

**Start with zip code database
use "[modelling_data]\FL_zip_covid.dta", clear
append using  "[modelling_data]\HarrisTX_zip_covid.dta"
append using  "[modelling_data]\SonomaCounty_zip_covid.dta"
append using  "[modelling_data]\SanDiegoCounty_zip_covid.dta"
append using  "[modelling_data]\StLouis_zip_covid.dta"
append using  "[modelling_data]\SF_zip_covid.dta"
append using  "[modelling_data]\NYC_zip_covid.dta"
append using  "[modelling_data]\MD_zip_covid.dta"
append using  "[modelling_data]\IL_zip_covid.dta"
append using  "[modelling_data]\KingCountyWA_zip_covid.dta"
append using  "[modelling_data]\SantaClaraCounty_zip_covid.dta"
append using  "[modelling_data]\philadelphia_by_zip.dta"
append using "[modelling_data]\OR_zip_covid.dta"
append using "[modelling_data]\HI_zip_covid.dta"
append using "[modelling_data]\Louisville_zip_covid.dta"
append using "[modelling_data]\IN_zip_covid.dta"
append using "[modelling_data]\MN_zip_covid.dta"
append using "[modelling_data]\OH_zip_covid.dta"
append using "[modelling_data]\OK_zip_covid.dta"
drop if zip==.
merge 1:1 zip using  "[modelling_data]\nc_zip202011201315.dta", update replace
drop _merge

save "[YOUR FILE LOCATION]Data\COVID_ZIPCODE_DATABASE_FEB_12_2021.dta", replace

*Merge census
merge 1:1 zip using [Your file location]zip_land_area_mable.dta"
drop _merge
merge 1:1 zip using "[YOUR FILE LOCATION]Data\zcta_age_race2019_5yr.dta"
drop _merge
merge 1:1 zip using "[YOUR FILE LOCATION]Data\ACS_2019_5yr_zcta_disability.dta"
drop _merge
merge 1:1 zip using "[YOUR FILE LOCATION]Data\ACS_2019_5yr_zcta_hh_income.dta"
drop _merge
merge 1:1 zip using "[YOUR FILE LOCATION]Data\ACS_2019_5yr_zcta_employment.dta"
drop _merge
merge 1:1 zip using "[YOUR FILE LOCATION]Data\ACS_2019_5yr_zcta_edu.dta"
drop _merge

foreach x in white_pop2019 asian_pop2019 black_pop2019 hisp_pop2019 {
gen pct_`x'=`x'/pop2019_5yr
}

foreach x in pop25_over20195yr pop_less9th20195yr pop9_1220195yr pophs20195yr pop_some20195yr pop_assoc20195yr pop_ba20195yr pop_grad20195yr pop_ba_higher20195yr {
gen pct_`x'=`x'/pop2019_5yr
}

gen density2019=land_area_sq_mile/pop2019_5yr
egen inc_under25=rowtotal(pct_hhinc_less10 pct_hhinc_10_14 pct_hhinc_15_24)
egen inc_150plus=rowtotal(pct_hhinc_150_199 pct_hhinc_200_plus)

gen pct_65_plus=pop_65_over_20195yr/pop2019_5yr 
gen pct_85_plus=pop85_over2019/pop2019_5yr

gen mortality_rate=deaths/cases

gen inst_pop2019=pop2019_5yr-total_noninst_pop20195yr
gen pct_inst_pop2019=inst_pop2019/pop2019_5yr
label var pct_inst_pop2019 "Share of population living in institutional homes"
gen pop_per_unit=pop2019_5yr/housing_units2019 
egen Crowding= cut(pop_per_unit), at(0,2,3,5000)
tab Crowding, gen(crowding)

**Identify county
gen zcta=zip
merge 1:1 zcta using "[YOUR FILE LOCATION]Data\geocorr2018_zctz_to_cty.dta"
drop if ctyfip==.
drop _merge

**Merge in County-level COVID Data
merge m:1 ctyfip using "[YOUR FILE LOCATION]Data\covid_deaths_usafacts_Feb9_2021.dta"
drop if _merge==2
drop _merge
merge m:1 ctyfip using "[YOUR FILE LOCATION]Data\covid_confirmed_usafacts_Feb9_2021.dta"
drop if _merge==2
drop _merge
merge m:1 ctyfip using "[YOUR FILE LOCATION]Data\cty_pop_usafacts_Feb9_2021.dta"
drop if _merge==2
drop _merge

gen pc_cases=(cases*100000)/pop2019_5yr
gen pc_deaths=(deaths*100000)/pop2019_5yr

gen case_rate= cases/pop2019_5yr
gen death_rate=deaths/pop2019_5yr

**Correct errors in zipcode assignment of cases/deaths
replace pc_cases=. if case_rate>1
replace pc_deaths=. if death_rate>1
replace case_rate=. if case_rate>1
replace death_rate=. if death_rate>1

gen zip_pop_share=pop2019_5yr/cty_pop
gen share_children=pop_under18_20195yr/pop2019_5yr
gen pc_deaths_cty=(1000*cty_deaths_Feb9)/cty_pop
gen pc_cases_cty=(1000*cty_cases_Feb9)/cty_pop
gen expected_deaths=zip_pop_share*cty_deaths_Feb9
gen expected_cases=zip_pop_share*cty_cases_Feb9
gen expected_deaths_pc= expected_deaths/pop2019_5yr
gen expected_cases_pc= expected_cases/pop2019_5yr

gen max_death_rate=(1000*pc_deaths_cty)/pop2019_5yr
label var max_death_rate "Max deaths possible in zipcode given county info"
label var lfpr20_64_20195yr "Labor force rate"
label var unemploy_rate20_64_20195yr "Unemployment rate"
label var pc_deaths "Zipcode level deaths per 100,000 residents"
label var pc_cases "Zipcode level cases per 100,000 residents"
label var pc_deaths_cty "County level deaths per 100,000 residents"
label var pc_cases_cty "County level cases per 100,000 residents"
label var pct_inst_pop2019 "Zipcode share of population living in institutional housing"
label var share_children "Zipcode children share of population"
label var pct_65_plus "Zipcode population share 65 or older"
label var pct_pop_ba_higher20195yr "Zipcode population 25 or older with bachelor's or higher education"
label var inc_under25 "Zipcode share of households with income less than $25K"
label var inc_150plus "Zipcode share of households with income of $150K or higher"
label var density2019 "Zipcode population density"
label var pct_black_pop2019 "Zipcode Black population share"
label var pct_hisp_pop2019  "Zipcode Hispanic population share"
label var pct_white_pop2019  "Zipcode Hispanic population share"
label var pct_asian_pop2019  "Zipcode Hispanic population share"
label var expected_deaths_pc  "County deaths X Zip share of county population per 100K"
label var expected_cases_pc  "County cases X Zip share of county population per 100K"
label var pct_85_plus  "Zipcode population share 85 or older"

save "[YOUR FILE LOCATION]Data\ZIP_DATABASE_w_COVID_CTY.dta", replace

