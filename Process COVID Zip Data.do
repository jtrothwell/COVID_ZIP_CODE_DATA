*Philadelphia
insheet using  "[]\philly_covid_cases_by_zip_2_11_2021.csv", clear
ren zip_code zip
ren count cases
keep if covid_status=="POS"
keep cases  zip
gen city="Philadelphia"
gen stabb="PA"
gen place="Philadelphia, PA"
collapse (sum) cases, by(zip)
save "[]\philadelphia_by_zip1.dta", replace
insheet using  "[]\philly_covid_deaths_by_zip_2_11_2021.csv", clear
ren zip_code zip
ren count deaths
keep deaths  zip
gen city="Philadelphia"
gen stabb="PA"
gen place="Philadelphia, PA"
collapse (sum) deaths, by(zip)
mvencode deaths, mv(0) override
save "[]\philadelphia_by_zip2.dta", replace
merge 1:1 zip using "[]\philadelphia_by_zip1.dta"
drop _merge
save "[]\philadelphia_by_zip.dta", replace

insheet using "[]\NorthCarolina_Cases_Deaths_Zips_COVID19_2_11_21.csv", clear
ren zipcode zip
keep cases deaths zip 
destring cases deaths, ignore(",") replace
gen city=""
gen stabb="NC"
gen place="North Carolina"
mvencode cases deaths, mv(0) override
save "[]\nc_zip202011201315.dta", replace

*Chicago
insheet using  "[]\Cook_CountyIL_Medical_Examiner_Case_Archive_-_COVID-19_Related_Deaths_2_11_2021.csv", clear
ren residence_zip zip
collapse (count) deaths=age ,by(zip)
destring deaths zip, replace ignore("Unknown")
gen city="Chicago"
gen stabb="IL"
gen place="Chicago, IL"
gen zip5=substr(zip,1,5)
drop zip
destring zip5, gen(zip)
save "[]\chicago_zip_covid.dta", replace

*Illinois
insheet using "[]\Illionis_Dept_Health_COVID_Deaths_Cases_by_zip_feb_11_2021.csv", clear
ren tested tests
ren confir cases
destring zip, replace ignore("Unknown")
drop deaths
gen city=""
gen stabb="IL"
gen place="Illinois"
save "[]\IL_zip_covid.dta", replace

*Maryland state
insheet using "[]\MDCOVID19_MASTER_ZIP_CODE_CASES_Feb11_2021.csv", clear
ren zip_code zip
ren total02_11_2021 cases
mvencode cases, mv(0)
keep zip cases
destring zip, replace ignore("Unknown")
gen city=""
gen stabb="MD"
gen place="Maryland"
save "[]\MD_zip_covid.dta", replace

*NYC
insheet using  "[]\nyc_data-by-modzcta_2_11_21.csv", clear
ren mod zip
ren covid_case_count cases
ren covid_death_count deaths
ren total_covid_tests tests
ren pop_d pop
keep cases deaths tests zip
gen city="New York City"
gen stabb="NY"
gen place="New York"
destring zip, replace
save "[]\NYC_zip_covid.dta", replace

*San Fran
insheet using "[]\SanFran_COVID-19_Cases_and_Deaths_Summarized_by_ZIP_Code_Tabulation_Area.csv", clear name
ren id zip
ren count cases
keep zip cases deaths
drop in 7
destring _all, replace
gen city="San Francisco, CA"
gen stabb="CA"
gen place="San Francisco"
save "[]\SF_zip_covid.dta", replace

*St Louis
insheet using "[]\st_louis_cases_by_zcta_2_11_21.csv", clear
keep zip cases 
gen city="St Louis, MO"
gen stabb="MO"
gen place="St Louis, MO"
save "[]\StLouis_zip_covid.dta", replace

*Florida
insheet using  "[]\Florida_Cases_Zips_COVID19_Feb11_2021.csv" , clear
ren case cases
destring cases, replace ignore(<)
collapse (sum) cases , by(zip)
gen city=""
gen stabb="FL"
gen place="Florida"
mvencode cases, mv(0) override
save "[]\FL_zip_covid.dta", replace

*San Diego County
insheet using "[]\San_Diego_COVID19_Case_Rate_Data_by_ZIP_Code.csv", clear
drop zip
ren zip_only1 zip
ren total_cases cases
keep cases zip
mvencode cases, mv(0)
collapse (sum) cases, by(zip)
gen city=""
gen stabb="CA"
gen place="San Diego County"
save "[]\SanDiegoCounty_zip_covid.dta", replace

*Santa clara
insheet using "[]\SantaClara_COVID-19_cases_by_zip_code.csv", clear
keep cases zipcode
ren zipcode zip
destring cases, replace
mvencode cases, mv(0) override
gen city=""
gen stabb="CA"
gen place="Santa Clara County"
save "[]\SantaClaraCounty_zip_covid1.dta", replace
insheet using "[]\SantaClara_COVID-19_deaths_by_zip_code.csv", clear
keep deathcount zcta
ren zcta zip
destring deathcount, replace
mvencode deathcount, mv(0) override
gen city=""
gen stabb="CA"
gen place="Santa Clara County"
save "[]\SantaClaraCounty_zip_covid2.dta", replace
merge 1:1 zip using "[]\SantaClaraCounty_zip_covid1.dta"
drop _merge
save "[]\SantaClaraCounty_zip_covid.dta", replace

*Sonomoa CA
insheet using "[]\SonomaCounty_Cases_Zip_2_11_2021.csv", clear
keep zip cases
mvencode cases, mv(0)
gen city=""
gen stabb="CA"
gen place="Sonoma County"
save "[]\SonomaCounty_zip_covid.dta", replace

*King County WA
insheet using "[]\king_countyWA_cases_by_zip-daily-feb-10.csv", clear
collapse (sum) cases=positives, by(zip)
mvencode cases, mv(0) override
gen city=""
gen stabb="WA"
gen place="King County"
save "[]\KingCountyWA_zip_covid1.dta", replace
insheet using "[]\king_countyWA_deaths_by_zip-daily-feb-10.csv", clear
collapse (sum) deaths, by(zip)
mvencode deaths, mv(0) override
gen city=""
gen stabb="WA"
gen place="King County"
save "[]\KingCountyWA_zip_covid2.dta", replace
merge 1:1 zip using "[]\KingCountyWA_zip_covid1.dta"
drop _merge
save "[]\KingCountyWA_zip_covid.dta", replace

*Houston/Harris
insheet using "[]\HarrisCounty_TX_HCPH_COVID19_Zip_Codes.csv", clear
replace death_str="0" if death_st=="0-5"
ren totalconfirm cases
ren death_st deaths
keep deaths cases zip
destring cases death, replace
gen city=""
gen stabb="TX"
gen place="Harris County"
save "[]\HarrisTX_zip_covid.dta", replace

*OHIO
insheet using "[]\OH_COVIDSummaryDataZIP.csv", clear name
destring zip , ignore("," "N/A" "Unknown") replace
destring casecountcumulative, ignore("," "N/A") gen(cases)
keep zip cases
gen city=""
gen stabb="OH"
gen place="Ohio"
save "[]\OH_zip_covid.dta", replace

*Oklahoma
insheet using "[]\oklahoma_cases_zip.csv", clear
collapse (sum) cases deaths, by(zip)
gen city=""
gen stabb="OK"
gen place="Oklahoma"
tab zip
destring zip, replace ignore("Other***")
save "[]\OK_zip_covid.dta", replace

*Wisconsin
insheet using  "[]\WI_COVID-19_Historical_Data_by_ZIP_Code_Tabulation_Area.csv", clear
ren GEOID zip
replace deaths=0 if deaths==-999
replace positive=0 if positive==-999
collapse (sum) cases=positive deaths, by(zip)
sum
gen city=""
gen stabb="WI"
gen place="Wisconsin"
save "[]\WI_zip_covid.dta", replace

*Minnesota
insheet using  "[]\MN_wmapcz06.csv", clear name
replace cases="0" if cases=="<=5"
destring zip cases, replace ignore("missing")
gen city=""
gen stabb="MI"
gen place="Minnesota"
save "[]\MN_zip_covid.dta", replace

*Indiana
insheet using  "[]\IN_covid_count_per_zip_all.csv", clear
destring patient_count, gen(cases) ignore("Suppressed")
gen city=""
gen stabb="IN"
gen place="Indiana"
save "[]\IN_zip_covid.dta", replace

*Louisville/Jefferson County KY
insheet using  "[]\JEFF_CountyKY_COVID-19_Case_Rate_Per_Zip_Code_with_Long_Term_Care_Facility_Cases.csv", clear
collapse (sum) cases=conf_count, by(zip)
ren zipcode zip
gen city="Louisville"
gen stabb="KY"
gen place="Kentucky"
save "[]\Louisville_zip_covid.dta", replace

*Oregon
insheet using  "[]\OR_Cases_by_ZIP_Code_data.csv", clear
ren casecount cases
ren ZIPCode zip
replace cases="4" if cases=="1-9"
destring zip cases, replace ignore("*N/A" "Missing" "Suppressed")
gen city=""
gen stabb="OR"
gen place="Oregon"
save "[]\OR_zip_covid.dta", replace

*Hawaii
insheet using  "[]\Hawaii_Cases_by_Zipcode_2_12_2021.csv", clear name
ren _totalcases cases
replace cases="" if cases=="Population < 1000" 
replace cases="5" if cases=="1 to 10" 
destring cases, replace ignore("*N/A" "Missing" "Suppressed")
keep zip cases
destring zip, replace ignore(HAW01 HAW02 KAHOO)
collapse (sum) cases, by(zip)
gen city=""
gen stabb="HI"
gen place="Hawaii"
save "[]\HI_zip_covid.dta", replace
