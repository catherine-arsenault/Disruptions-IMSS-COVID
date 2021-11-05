* Creation do file

* Update: Disruption in essential health services at the Mexican Institute for Social Security
* Created by: Catherine Arsenault
* Last edited November, 2021
global user "/Users/acatherine/Dropbox (Harvard University)"
global data "/HMIS Data for Health System Performance Covid (Mexico)"
global analysis "SPH-Kruk Team/Quest Network/Core Research/HS performance Covid (internal)/Country-specific papers/Mexico IMSS_updated"

u  "$user/$data/Data for analysis/IMSS_Jan19-Dec20_foranalysis.dta", clear
keep Deleg year month population2019 population2020 fp_util  anc_util totaldel cs_util malnu_util ///
	 diarr_util pneum_util pent_qual bcg_qual measles_qual opv3_qual rota_qual ///
	 pneum_qual cerv_util cerv_denom2020 cerv_denom2019 breast_util breast_denom2019 ///
	breast_denom2020 diab_util hyper_util diab_qual_num hyper_qual_num population*
	
order Deleg year month  population2019 population2020 fp_util  anc_util totaldel cs_util malnu_util ///
	 diarr_util pneum_util pent_qual bcg_qual measles_qual opv3_qual rota_qual ///
	 pneum_qual cerv_util cerv_denom2020 cerv_denom2019 breast_util breast_denom2019 ///
	breast_denom2020 diab_util hyper_util diab_qual_num hyper_qual_num 

save "$user/$data/Data for analysis/IMSS_service_delivery_raw.dta", replace	
// This is the dataset available on Harvard Dataverse

* Adding data from 2021 
import excel using "$user/$data/Raw/2021/edited for analyses_Concentrado de indicadoresIMSS_04112021.xlsx", firstrow clear

append using "$user/$data/Data for analysis/IMSS_service_delivery_raw.dta"
********************************************************************************
* CREATE VARIABLES FOR ANALYSIS
********************************************************************************
gen rmonth= month if year==2019
replace rmonth = month+12 if year ==2020
replace rmonth = month+ 24 if year==2021
sort Deleg rmonth

gen postCovid = rmonth>15 // State of Emergency was March 30th, month 15. 

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
gen timeafter=0 
replace time=1 if rmonth==16
replace time=2 if rmonth==17
replace time=3 if rmonth==18
replace time=4 if rmonth==19
replace time=5 if rmonth==20
replace time=6 if rmonth==21
replace time=7 if rmonth==22
replace time=8 if rmonth==23
replace time=9 if rmonth==24
replace time=10 if rmonth==25
replace time=11 if rmonth==26
replace time=12 if rmonth==27
replace time=13 if rmonth==28
replace time=14 if rmonth==29
replace time=15 if rmonth==30
replace time=16 if rmonth==32

* Seasons
gen spring = month>=3 & month<=5
gen summer = month>=6 & month<=8
gen fall = month>=9 & month<=11
gen winter= month==12 | month==1 | month==2

* Quarters of 2020 & 2021
gen quarter_20 = 2 if rmonth>=16 & rmonth<=18
replace quarter_20 = 3 if rmonth>=19 & rmonth<=21
replace quarter_20 = 4 if rmonth>=22 & rmonth<=24
 quarter_21 = 1 if rmonth>=25 & rmonth<=27 // Jan-Mar 2021
replace quarter_21 = 2 if rmonth>=28 & rmonth<=32 // April - August 2021


/* Population
gen population= population2019 if year==2019
replace population= population2020 if year==2020
drop population2019 population2020
gen logpop=log(population) */

********************************************************************************
* GLOBALS
********************************************************************************
global maternal fp_util  anc_util totaldel cs_rate
global child sc_util vax_util 
global chronic cerv_util breast_util diab_util diab_qual hyper_util hyper_qual 
global vax bcg_qual pent_qual measles_qual rota_qual pneum_qual
global all $maternal $child $chronic
********************************************************************************
* TABLE 1 DESCRIPTIVES AVERAGE SERVICES PER MONTH PRE/POST COVID
********************************************************************************
* Averages per month
by postCovid, sort: tabstat $maternal if Deleg=="National", stat(mean sd) col(s)
by postCovid, sort: tabstat $child if Deleg=="National", stat(mean sd) col(s)
by postCovid, sort: tabstat $chronic if Deleg=="National", stat(mean sd) col(s)

* Sum client visits // 1st paragraph results section
tabstat fp_util  anc_util totaldel sc_util vax_util cerv_util breast_util ///
diab_util hyper_util if Deleg=="National", stat(N sum) col(s) format(%20.10f)

drop if Deleg=="National" 
encode Deleg , gen(deleg)

save "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", replace
