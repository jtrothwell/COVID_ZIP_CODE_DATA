use "[Your file location]Data\ZIP_DATABASE_w_COVID_CTY.dta", clear
drop if stfip==.

sum zip_pop_share

pwcorr pc_deaths  pc_cases_cty pc_deaths_cty  pct_inst_pop2019 share_children pct_65_plus  pct_pop_ba_higher20195yr   inc_under25 inc_150plus lfpr20_64_20195yr  density pct_white_pop2019 pct_asian_pop2019 pct_black_pop2019 pct_hisp_pop2019

keep zip place zcta stfip ctyfip pc_cases pc_deaths ///
max_death_rate expected_deaths_pc  expected_cases_pc   ///
pct_inst_pop2019 share_children pct_65_plus pct_85_plus  pct_pop_ba_higher20195yr   inc_under25 inc_150plus lfpr20_64_20195yr  density2019 pct_white_pop2019 pct_asian_pop2019 pct_black_pop2019 pct_hisp_pop2019

mi set wide
mi register imputed pc_cases
mi register regular expected_deaths_pc  expected_cases_pc  ///
pct_inst_pop2019 share_children pct_65_plus pct_85_plus  pct_pop_ba_higher20195yr   inc_under25 inc_150plus lfpr20_64_20195yr  density2019 pct_white_pop2019 pct_asian_pop2019 pct_black_pop2019 pct_hisp_pop2019 max_death_rate

mi impute regress pc_cases  expected_cases_pc   pct_inst_pop2019 share_children pct_65_plus pct_85_plus  pct_pop_ba_higher20195yr   inc_under25 inc_150plus lfpr20_64_20195yr  density2019 pct_white_pop2019 pct_asian_pop2019 pct_black_pop2019 pct_hisp_pop2019 stfip, add(20) force rseed(1234567)
foreach x in  _1_pc_cases _2_pc_cases _3_pc_cases _4_pc_cases _5_pc_cases _6_pc_cases _7_pc_cases _8_pc_cases _9_pc_cases _10_pc_cases _11_pc_cases _12_pc_cases _13_pc_cases _14_pc_cases _15_pc_cases _16_pc_cases _17_pc_cases _18_pc_cases _19_pc_cases _20_pc_cases {
replace `x'=0 if `x'<0 
}

egen IMP_cases=rowmean(_1_pc_cases _2_pc_cases _3_pc_cases _4_pc_cases _5_pc_cases _6_pc_cases _7_pc_cases _8_pc_cases _9_pc_cases _10_pc_cases _11_pc_cases _12_pc_cases _13_pc_cases _14_pc_cases _15_pc_cases _16_pc_cases _17_pc_cases _18_pc_cases _19_pc_cases _20_pc_cases) 
label var IMP_cases "Imputed cases per 100,000 residents"

sum IMP_cases

keep IMP_cases zip
save "[Your file location]Data\Imputed_Cases.dta", replace
