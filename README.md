# COVID_ZIP_CODE_DATA
These files provide a database of zipcode level COVID-19 cases and deaths through February 11-12, 2021 by US zipcode for available jurisdictions found through internet searches. The raw data for deaths and cases includes zipcodes representing 9% (1,748 zipcodes) and 23% (5,432) of the U.S. population, respectively. Records are imputed for 74% of the U.S. population, covering 26,800 zipcodes. Each zipcode is assigned to exactly one county, using the county with the largest share of the zipcode's population. 

1) COVID_ZIPCODE_DATABASE_FEB_12_2021.csv
This file compiles the raw data (key variabels are "deaths" from COVID-19 and confirmed "cases") from various sources and harmonizes reporting to be cumulative through Feb 11 or 12th of 2021: 

See Sources for Zipcode Data.xlsx for URL and links to the raw data.

2) ZIP_DATABASE_COMPLETE.csv 
This file has for more compelte data. It includes ZCTA-level demographic data from the 2019 5-year American Community Survey on race, age, income, education, and other variables. County deaths and cases overall and per capita are also included, using data from USA Facts: https://usafacts.org/issues/coronavirus/

See list of variables here: Data Dictionary.csv

Imputed variables: In an effort to understand how demographic variables relate to per capita deaths and cases at the zipcode level, I modeled imputations for missing zipcodes using the "mi" multiple imputation program in STATA (variables are IMP_deaths and IMP_cases). The data labels in STATA show the definitions of the key variables.

Zipcode/ZCTAs were matched to counties using GeoCorr2018 via Missouri Census Data Center, https://mcdc.missouri.edu/applications/geocorr2018.html

STATA Do files: 
1) Process COVID Zip Data.do: Cleans raw data on disease burden by zipcod
2) Compile zipcode and county database.do: creates larger databsae with census data
3) Multiple Imputation of Deaths for Zipcodes.do: imputes deaths to zipcodes with missing data
4) Multiple Imputation of Deaths for Zipcodes.do: imputes cases to zipcodes with missing data

For questions, corrections, or comments, email: jonathan_rothwell@gallup.com
