********************************************************************************
*Raw data for main indicators through November 2021
********************************************************************************

import excel using "$user/$data/Raw/2021/Concentrado de indicadoresIMSS_Nov 2021.xlsx", clear
drop in 1/2
destring C - Y, replace
drop Z - AD

rename * (Delegation year month fp_utilA fp_utilB anc_util totaldel	cs_util	diarr_util	pneum_util	malnu_util	diab_util	hyper_util	diab_qual_num	hyper_qual_num	cerv_util	cerv_denom2021	breast_util	breast_denom2021	bcg_qual	pent_qual	measles_qual	pneum_qual	rota_qual)
egen fp_util = rowtotal(fp_utilA fp_utilB), mi
order fp_util, after(month)
drop fp_utilA fp_utilB
replace Delegation = "National" if Delegation == "NACIONAL"
replace Delegation = "D.F. Norte" if Delegation == "CDMX Norte"
replace Delegation = "D.F. Sur" if Delegation == "CDMX Sur"

drop if month == 12 // December data not included

save "$user/$data/Data for analysis/IMSS_service_delivery_2021.dta", replace

********************************************************************************
*Raw data for bed occupancy
********************************************************************************
import excel using "$user/$data/Raw/2021/RECONVERSION OCUPACION COVID HISTORICO .xlsm", sheet("C_OCU") firstrow clear
gen month = month(fch)
gen year = year(fch)
collapse (mean) AGUAS - VERACRUZ, by(month year) // Note that the missing values are treated as 0, so for instance April 2020 does not have data for first few days and the average value for April will reflect this. 
sort year month
drop if year == 2022
order NACIONAL, last
local i = 1
foreach var of varlist AGUAS - NACIONAL {
	rename `var' beds`i'
	local i = `i' + 1
}
reshape long beds, i(month year) j(deleg)
*Important note: these labels are added manually based on the order of columns in the spreadsheet (and making national last, above). If that order changed, this would need to be updated, otherwise delegations will be mis-labeled.
lab def deleg 1 "Aguascalientes" 2 "Baja California" 3 "Baja California Sur" 4 "Campeche" 5 "D.F. Norte" 6 "D.F. Sur" 7 "Chiapas" 8 "Chihuahua" 9 "Coahuila" 10 "Colima" 11 "Durango" 12 "México Oriente" 13 "México Poniente" 14 "Guanajuato" 15 "Guerrero" 16 "Hidalgo" 17 "Jalisco" 18 "Michoacán" 19 "Morelos" 20 "Nayarit" 21 "Nuevo León" 22 "Oaxaca" 23 "Puebla" 24 "Querétaro" 25 "Quintana Roo" 26 "San Luis Potosí" 27 "Sinaloa" 28 "Sonora" 29 "Tabasco" 30 "Tamaulipas" 31 "Tlaxcala" 32 "Veracruz Norte" 33 "Veracruz Sur" 34 "Yucatán" 35 "Zacatecas" 39 "National"
lab val deleg deleg
decode deleg, gen(Delegation)
drop if Delegation == ""
save "$user/$data/Data for analysis/IMSS_beds.dta", replace

********************************************************************************
*Raw data for 2021 population
********************************************************************************
import excel using "$user/$data/Raw/2021/Población Adscrita_Dic2021.xlsx", sheet("Grupo de Edad MF") clear
drop in 1/12
keep if C == "Total Delegacional" | B == "Nacional"
drop A C D
destring E F K Q-AH CI - CW, replace
rename (B E) (Delegation total_pop2021)
gen u1 = F
gen u5 = K
egen u10 = rowtotal(K Q)
egen all20plus = rowtotal(T - AG)
egen women1549 = rowtotal(CI - CO)
egen women2564 = rowtotal(CK - CR)
egen women5069 = rowtotal(CP - CS)
keep Deleg total_pop u1 - women5069
replace Delegation = "National" if Delegation == "Nacional"
replace Delegation = "D.F. Norte" if Delegation == "D. F. Norte"
replace Delegation = "D.F. Sur" if Delegation == "D. F. Sur"
save "$user/$data/Data for analysis/IMSSpop2021.dta", replace

********************************************************************************
*Assembling data
********************************************************************************
u  "$user/$data/Data for analysis/IMSS_Jan19-Dec20_foranalysis.dta", clear
keep Deleg year month population2019 population2020 fp_util  anc_util totaldel cs_util malnu_util ///
	 diarr_util pneum_util pent_qual bcgu_qual measles_qual opv3_qual rota_qual ///
	 pneum_qual cerv_util cerv_denom2020 cerv_denom2019 breast_util breast_denom2019 ///
	breast_denom2020 diab_util hyper_util diab_qual_num hyper_qual_num population*

rename bcgu_qual bcg_qual 

order Deleg year month  population2019 population2020 fp_util  anc_util totaldel cs_util malnu_util ///
	 diarr_util pneum_util pent_qual bcg_qual measles_qual opv3_qual rota_qual ///
	 pneum_qual cerv_util cerv_denom2020 cerv_denom2019 breast_util breast_denom2019 ///
	breast_denom2020 diab_util hyper_util diab_qual_num hyper_qual_num 

save "$user/$data/Data for analysis/IMSS_service_delivery_raw.dta", replace	
// This is the dataset available on Harvard Dataverse

* Adding data from 2021 
use "$user/$data/Data for analysis/IMSS_service_delivery_raw.dta", clear
append using "$user/$data/Data for analysis/IMSS_service_delivery_2021.dta"

merge 1:1 Deleg year month using "$user/$data/Data for analysis/IMSS_beds.dta"

replace beds = 0 if _merge == 1 // No data prior to April 2020
drop if _merge == 2 // Beds data extends later in 2021 than other data
drop _merge

merge m:1 Deleg using "$user/$data/Data for analysis/IMSSpop2021.dta" 
assert _merge == 3
drop _merge

save "$user/$data/Data for analysis/IMSS_service_delivery_updated.dta", replace	

********************************************************************************
* CREATE VARIABLES FOR ANALYSIS
********************************************************************************
use "$user/$data/Data for analysis/IMSS_service_delivery_updated.dta", clear
egen deleg_tag = tag(Delegation)
gsort -deleg_tag -population2020
gen pop_rank = _n if deleg_tag == 1
gsort Delegation -pop_rank
by Delegation: carryforward pop_rank, replace

lab def del 1 "Jal" 2 "Mex Or" 3 "NL" 4 "DF Sur" 5 "Gto" 6 "Coah" 7 "Chih" 8 "Mex Pon" 9 "DF Nor" 10 "BC" 11 "Tamp" 12 "Sin" 13 "Pue" 14 "Son" 15 "Ver Nor" 16 "Mich" 17 "Qro" 18 "SLP" 19 "Yuc" 20 "Ver Sur" 21 "QR" 22 "Ags" 23 "Hgo" 24 "Dgo" 25 "Chis" 26 "Mor" 27 "Tab" 28 "Gro" 29 "Oax" 30 "Zac" 31 "Nay" 32 "BCS" 33 "Col" 34 "Tlax" 35 "Camp"
lab val pop_rank del

gen rmonth= month if year==2019
replace rmonth = month+12 if year ==2020
replace rmonth = month+ 24 if year==2021
sort Deleg rmonth

gen postCovid = rmonth>15 // State of Emergency was March 30th, month 15. 

*HL addition
gen postPolicy = rmonth > 27 // Service resumption policies begin April 2021, month 28

* Calculating rates and merging child indicators
replace totaldel = 0 if totaldel==.
gen cs_rate = (cs_util/totaldel)*100
lab var cs_rate "c-section rate %"

gen diab_qual = (diab_qual_num/ diab_util)*100
lab var diab_qual "Proportion with controlled blood sugar"

gen hyper_qual = (hyper_qual_num / hyper_util)*100
lab var hyper_qual "Proportion with controlled BP"

egen vax_util = rowtotal(pent_qual bcg_qual measles_qual rota_qual pneum_qual), m
lab var vax_util "Total children vaccinated"

egen sc_util = rowtotal (diarr_util pneum_util malnu_util), m 
lab var sc_util "Total sick child visits"

* Number of months since Covid
gen timeafter_cov = rmonth - 15
replace timeafter_cov = 0 if rmonth < 15 

*Number of months since policy change
gen timeafter_pol = rmonth - 27
replace timeafter_pol = 0 if rmonth < 27

* Seasons
gen spring = month>=3 & month<=5
gen summer = month>=6 & month<=8
gen fall = month>=9 & month<=11
gen winter= month==12 | month==1 | month==2

* Quarters of 2020 & 2021
gen quarter_20 = 2 if rmonth>=16 & rmonth<=18 
replace quarter_20 = 3 if rmonth>=19 & rmonth<=21
replace quarter_20 = 4 if rmonth>=22 & rmonth<=24
gen quarter_21 = 1 if rmonth>=25 & rmonth<=27 // Jan-Mar 2021
replace quarter_21 = 2 if rmonth>=28 & rmonth<=30 // April - June 2021
replace quarter_21 = 3 if rmonth >= 31 & rmonth <= 33 // July - Sept 2021
replace quarter_21 = 4 if rmonth >= 34 & rmonth <= 36 // Oct - Nov (no Dec data) 2021 - careful if summarizing by quarter
egen q = concat(year quarter_20 quarter_21), punct("-")
replace q = regexr(q, "-\.", "")
encode q, gen(quarter)

* Population for 2019 and 2020
gen population= population2019 if year==2019
replace population= population2020 if year==2020 
sort Delegation year month
by Delegation: carryforward population, replace
drop population2019 population2020
gen logpop=log(population) 


gen ln_beds = ln(beds)
*By definition, missing for pre-Covid period
*replace ln_beds = 0 if rmonth < 16

sort Delegation year month
foreach var of varlist postCovid postPolicy timeafter_cov timeafter_pol beds ln_beds {
	by Delegation: gen `var'_lag = `var'[_n-1]
	replace `var'_lag = 0 if year == 2019 & month == 1
	by Delegation: gen `var'_lag2 = `var'[_n-2]
	replace `var'_lag2 = 0 if year == 2019 & month < 3	
}

lab var fp_util "Contraceptive use visits"
lab var anc_util "Antenatal care visits"
lab var totaldel "Deliveries"
lab var sc_util "Sick child visits"
lab var vax_util "Vaccinations"
lab var cerv_util "Cervical cancer screening"
lab var breast_util "Breast cancer screening"
lab var diab_util "Diabetes visits"
lab var hyper_util "Hypertension visits"
lab var cs_rate "C section %" 
lab var diab_qual "Controlled diabetes %"
lab var hyper_qual "Controlled hypertension %"
lab var hyper_qual_num "Hypertension pts w/ controlled BP"
lab var diab_qual_num "Diabetes pts w/ controlled blood sugar"
lab var cs_util "Caesarean sections"
lab var rmonth "Months since January 2019"
lab var timeafter_pol "Months since NHSR strategy"
recode rmonth (1/15 = 1 "Pre-Covid") (16 / 27 = 2 "Covid Yr 1") (28/36 = 3 "Covid Yr 2"), gen(period)
save "$user/$data/Data for analysis/IMSS_service_delivery_updated2021_nat.dta", replace

drop if Deleg=="National"
drop deleg 
encode Deleg , gen(deleg)

save "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", replace
