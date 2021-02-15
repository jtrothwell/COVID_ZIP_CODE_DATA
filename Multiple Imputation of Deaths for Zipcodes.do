use "[Your file location]Data\ZIP_DATABASE_w_COVID_CTY.dta", clear
drop if stfip==.

sum zip_pop_share

pwcorr pc_deaths  pc_cases_cty pc_deaths_cty  pct_inst_pop2019 share_children pct_65_plus  pct_pop_ba_higher20195yr   inc_under25 inc_150plus lfpr20_64_20195yr  density pct_white_pop2019 pct_asian_pop2019 pct_black_pop2019 pct_hisp_pop2019

keep zip place zcta stfip ctyfip pc_cases pc_deaths ///
max_death_rate expected_deaths_pc  expected_cases_pc   ///
pct_inst_pop2019 share_children pct_65_plus pct_85_plus  pct_pop_ba_higher20195yr   inc_under25 inc_150plus lfpr20_64_20195yr  density2019 pct_white_pop2019 pct_asian_pop2019 pct_black_pop2019 pct_hisp_pop2019

mi set wide
mi register imputed pc_deaths 
mi register regular expected_deaths_pc  expected_cases_pc  ///
pct_inst_pop2019 share_children pct_65_plus pct_85_plus  pct_pop_ba_higher20195yr   inc_under25 inc_150plus lfpr20_64_20195yr  density2019 pct_white_pop2019 pct_asian_pop2019 pct_black_pop2019 pct_hisp_pop2019 max_death_rate

mi impute regress pc_deaths expected_deaths_pc   pct_inst_pop2019 share_children pct_65_plus pct_85_plus  pct_pop_ba_higher20195yr   inc_under25 inc_150plus lfpr20_64_20195yr  density2019 pct_white_pop2019 pct_asian_pop2019 pct_black_pop2019 pct_hisp_pop2019 stfip, add(20) force rseed(1234567)
foreach x in _1_pc_deaths _2_pc_deaths _3_pc_deaths _4_pc_deaths _5_pc_deaths _6_pc_deaths _7_pc_deaths _8_pc_deaths _9_pc_deaths _10_pc_deaths _11_pc_deaths _12_pc_deaths _13_pc_deaths _14_pc_deaths _15_pc_deaths _16_pc_deaths _17_pc_deaths _18_pc_deaths _19_pc_deaths _20_pc_deaths {
replace `x'=0 if `x'<0 
}

egen IMP_deaths=rowmean(_1_pc_deaths _2_pc_deaths _3_pc_deaths _4_pc_deaths _5_pc_deaths _6_pc_deaths _7_pc_deaths _8_pc_deaths _9_pc_deaths _10_pc_deaths _11_pc_deaths _12_pc_deaths _13_pc_deaths _14_pc_deaths _15_pc_deaths _16_pc_deaths _17_pc_deaths _18_pc_deaths _19_pc_deaths _20_pc_deaths )
label var IMP_deaths "Imputed deaths per 100,000 residents"

sum IMP_deaths pc_deaths, detail
sum pc_deaths IMP_deaths _1_pc_deaths _2_pc_deaths _3_pc_deaths _4_pc_deaths _5_pc_deaths _6_pc_deaths _7_pc_deaths _8_pc_deaths _9_pc_deaths _10_pc_deaths _11_pc_deaths _12_pc_deaths _13_pc_deaths _14_pc_deaths _15_pc_deaths _16_pc_deaths _17_pc_deaths _18_pc_deaths _19_pc_deaths _20_pc_deaths
areg IMP_deaths expected_deaths_pc , ab(stfip)
areg pc_deaths expected_deaths_pc , ab(stfip)

keep IMP_deaths zip
save "[Your file location]Data\Imputed_Deaths.dta", replace

