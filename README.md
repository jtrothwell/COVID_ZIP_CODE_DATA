# COVID_ZIP_CODE_DATA
This provides a database through February 11-12, 2021 of COVID-19 cases and deaths by US zipcode for available jurisdictions found through internet search.

1) COVID_ZIPCODE_DATABASE_FEB_12_2021.csv
This file compiles the raw data (key variabels are "deaths" from COVID-19 and confirmed "cases") from various sources and harmonizes reporting to be cumulative through Feb 11 or 12th of 2021: 

See Sources for Zipcode Data.xlsx for URL and links to the raw data.

2) ZIP_DATABASE_COMPLETE.csv 
This file has for more compelte data. It includes ZCTA-level demographic data from the 2019 5-year American Community Survey on race, age, income, education, and other variables. County deaths and cases overall and per capita are also included, using data from USA Facts: https://usafacts.org/issues/coronavirus/

Imputed variables: In an effort to understand how demographic variables relate to per capita deaths and cases at the zipcode level, I modeled imputations for missing zipcodes using the "mi" multiple imputation program in STATA (variables are IMP_deaths and IMP_cases). The data labels in STATA show the definitions of the key variables.

Zipcode/ZCTAs were matched to counties using GeoCorr2018 via Missouri Census Data Center, https://mcdc.missouri.edu/applications/geocorr2018.html


