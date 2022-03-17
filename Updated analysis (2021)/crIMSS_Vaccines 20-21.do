* Update: Vaccines 2020-2021
* Created by: Saúl Eduardo Contreras Sánchez / Svetlana V. Doubova
* March, 2022

********************************************************************************
*BCG 2020
********************************************************************************

import excel using "$user/$data/Raw/2021/Vacunas_Aplicadas_Dosis_Deleg_Harvard_202001_202012_Preliminar.xlsx", sheet("BCG") clear
keep in 18/458
keep B H I X
gen month = substr(I,5,2)
drop I
rename * (Delegation year bcg_qual month)
destring year bcg_qual month, replace
order month, b(bcg_qual)
collapse (sum) bcg_qual, by(month year Deleg)  // Two delegations include subdelegation data: D.F. Norte (Deleg 35,36) and D.F. Sur (Deleg 37,38)

save "$user/$data/Data for analysis/Vaccines_20-21.dta", replace

********************************************************************************
*Pentavalent 2020
********************************************************************************

import excel using "$user/$data/Raw/2021/Vacunas_Aplicadas_Dosis_Deleg_Harvard_202001_202012_Preliminar.xlsx", sheet("Pentavalente") clear
keep in 18/461
keep B H I X
gen month = substr(I,5,2)
drop I
rename * (Delegation year pent1_qual month)
destring year pent1_qual month, replace
order month, b(pent1_qual)
replace Deleg = "Chiapas" if Deleg == "CHIAPAS"
collapse (sum) pent1_qual, by(month year Deleg)  // Two delegations include subdelegation data: D.F. Norte (Deleg 35,36) and D.F. Sur (Deleg 37,38)

merge 1:1 Deleg year month using "$user/$data/Data for analysis/Vaccines_20-21.dta"
drop _merge
save "$user/$data/Data for analysis/Vaccines_20-21.dta", replace

********************************************************************************
*Pentavalent acellular 2020
********************************************************************************

import excel using "$user/$data/Raw/2021/Vacunas_Aplicadas_Dosis_Deleg_Harvard_202001_202012_Preliminar.xlsx", sheet("Pentavalente_acelular") clear
keep in 18/461
keep B H I X
gen month = substr(I,5,2)
drop I
rename * (Delegation year pent2_qual month)
destring year pent2_qual month, replace
order month, b(pent2_qual)
collapse (sum) pent2_qual, by(month year Deleg)  // Two delegations include subdelegation data: D.F. Norte (Deleg 35,36) and D.F. Sur (Deleg 37,38)

merge 1:1 Deleg year month using "$user/$data/Data for analysis/Vaccines_20-21.dta"
drop _merge
save "$user/$data/Data for analysis/Vaccines_20-21.dta", replace

********************************************************************************
*MMR 2020
********************************************************************************

import excel using "$user/$data/Raw/2021/Vacunas_Aplicadas_Dosis_Deleg_Harvard_202001_202012_Preliminar.xlsx", sheet("SRP") clear
keep in 18/454
keep B H I X
gen month = substr(I,5,2)
drop I
rename * (Delegation year measles_qual month)
destring year measles_qual month, replace
order month, b(measles_qual)
replace Deleg = "Chiapas" if Deleg == "CHIAPAS"
collapse (sum) measles_qual, by(month year Deleg)  // Two delegations include subdelegation data: D.F. Norte (Deleg 35,36) and D.F. Sur (Deleg 37,38)

merge 1:1 Deleg year month using "$user/$data/Data for analysis/Vaccines_20-21.dta"
drop _merge
save "$user/$data/Data for analysis/Vaccines_20-21.dta", replace

********************************************************************************
*OPV3 2020
********************************************************************************

import excel using "$user/$data/Raw/2021/Vacunas_Aplicadas_Dosis_Deleg_Harvard_202001_202012_Preliminar.xlsx", sheet("SABIN") clear
keep in 914/1300
keep B H I X
gen month = substr(I,5,2)
drop I
rename * (Delegation year opv3_qual month)
destring year opv3_qual month, replace
order month, b(opv3_qual)
replace Deleg = "Chiapas" if Deleg == "CHIAPAS"
collapse (sum) opv3_qual, by(month year Deleg)  // Two delegations include subdelegation data: D.F. Norte (Deleg 35,36) and D.F. Sur (Deleg 37,38)

merge 1:1 Deleg year month using "$user/$data/Data for analysis/Vaccines_20-21.dta"
drop _merge
save "$user/$data/Data for analysis/Vaccines_20-21.dta", replace

********************************************************************************
*Rotavirus 2020
********************************************************************************

import excel using "$user/$data/Raw/2021/Vacunas_Aplicadas_Dosis_Deleg_Harvard_202001_202012_Preliminar.xlsx", sheet("ROTAVIRUS") clear
keep in 18/461
keep B H I X
gen month = substr(I,5,2)
drop I
rename * (Delegation year rota_qual month)
destring year rota_qual month, replace
order month, b(rota_qual)
replace Deleg = "Chiapas" if Deleg == "CHIAPAS"
collapse (sum) rota_qual, by(month year Deleg)  // Two delegations include subdelegation data: D.F. Norte (Deleg 35,36) and D.F. Sur (Deleg 37,38)

merge 1:1 Deleg year month using "$user/$data/Data for analysis/Vaccines_20-21.dta"
drop _merge
save "$user/$data/Data for analysis/Vaccines_20-21.dta", replace

********************************************************************************
*Pneumococcal 2020
********************************************************************************

import excel using "$user/$data/Raw/2021/Vacunas_Aplicadas_Dosis_Deleg_Harvard_202001_202012_Preliminar.xlsx", sheet("ANTINEUMOCOCCICA") clear
keep in 18/461
keep B H I Y  // Only children were included because there are also adults in the database
gen month = substr(I,5,2)
drop I
rename * (Delegation year pneum_qual month)
destring year pneum_qual month, replace
order month, b(pneum_qual)
replace Deleg = "Chiapas" if Deleg == "CHIAPAS"
collapse (sum) pneum_qual, by(month year Deleg)  // Two delegations include subdelegation data: D.F. Norte (Deleg 35,36) and D.F. Sur (Deleg 37,38)

merge 1:1 Deleg year month using "$user/$data/Data for analysis/Vaccines_20-21.dta"
drop _merge
save "$user/$data/Data for analysis/Vaccines_20-21.dta", replace

********************************************************************************
*BCG 2021
********************************************************************************

import excel using "$user/$data/Raw/2021/Vacunas_Aplicadas_Dosis_Delegacion_202101_202112_Preliminar", sheet("BCG") clear
keep in 16/451
keep B D-F
gen month = substr(E,5,2)
drop E
rename * (Delegation year bcg_qual month)
destring year bcg_qual month, replace
order month, b(bcg_qual)
replace Deleg = "D.F. Norte" if Deleg == "Ciudad de México Norte"
replace Deleg = "D.F. Sur" if Deleg == "Ciudad de México Sur"
collapse (sum) bcg_qual, by(month year Deleg)  // Two delegations include subdelegation data: D.F. Norte (Deleg 35,36) and D.F. Sur (Deleg 37,38)

append using "$user/$data/Data for analysis/Vaccines_20-21.dta"
save "$user/$data/Data for analysis/Vaccines_20-21.dta", replace

********************************************************************************
*Pentavalent 2021
********************************************************************************

import excel using "$user/$data/Raw/2021/Vacunas_Aplicadas_Dosis_Delegacion_202101_202112_Preliminar", sheet("Pentavalente") clear
keep in 17/460
keep B C J
gen year = substr(C,1,4)
gen month = substr(C,5,2)
drop C
rename * (Delegation pent1_qual year month)
destring year pent1_qual month, replace
order year month, b(pent1_qual)
replace Deleg = "D.F. Norte" if Deleg == "Ciudad de México Norte"
replace Deleg = "D.F. Sur" if Deleg == "Ciudad de México Sur"
collapse (sum) pent1_qual, by(month year Deleg)  // Two delegations include subdelegation data: D.F. Norte (Deleg 35,36) and D.F. Sur (Deleg 37,38)

merge 1:1 Deleg year month using "$user/$data/Data for analysis/Vaccines_20-21.dta"
drop _merge
save "$user/$data/Data for analysis/Vaccines_20-21.dta", replace

********************************************************************************
*Pentavalent acellular 2021
********************************************************************************

import excel using "$user/$data/Raw/2021/Vacunas_Aplicadas_Dosis_Delegacion_202101_202112_Preliminar", sheet("Pentavalente_acelular") clear
keep in 19/462
keep B-D
gen year = substr(C,1,4)
gen month = substr(C,5,2)
drop C
rename * (Delegation pent2_qual year month)
destring year pent2_qual month, replace
order year month, b(pent2_qual)
replace Deleg = "D.F. Norte" if Deleg == "Ciudad de México Norte"
replace Deleg = "D.F. Sur" if Deleg == "Ciudad de México Sur"
collapse (sum) pent2_qual, by(month year Deleg)  // Two delegations include subdelegation data: D.F. Norte (Deleg 35,36) and D.F. Sur (Deleg 37,38)

merge 1:1 Deleg year month using "$user/$data/Data for analysis/Vaccines_20-21.dta"
drop _merge
save "$user/$data/Data for analysis/Vaccines_20-21.dta", replace

********************************************************************************
*MMR 2021
********************************************************************************

import excel using "$user/$data/Raw/2021/Vacunas_Aplicadas_Dosis_Delegacion_202101_202112_Preliminar", sheet("SRP") clear
keep in 18/461
keep B-D
gen year = substr(C,1,4)
gen month = substr(C,5,2)
drop C
rename * (Delegation measles_qual year month)
destring year measles_qual month, replace
order year month, b(measles_qual)
replace Deleg = "D.F. Norte" if Deleg == "Ciudad de México Norte"
replace Deleg = "D.F. Sur" if Deleg == "Ciudad de México Sur"
collapse (sum) measles_qual, by(month year Deleg)  // Two delegations include subdelegation data: D.F. Norte (Deleg 35,36) and D.F. Sur (Deleg 37,38)

merge 1:1 Deleg year month using "$user/$data/Data for analysis/Vaccines_20-21.dta"
drop _merge
save "$user/$data/Data for analysis/Vaccines_20-21.dta", replace

********************************************************************************
*OPV3 2021
********************************************************************************

import excel using "$user/$data/Raw/2021/Vacunas_Aplicadas_Dosis_Delegacion_202101_202112_Preliminar", sheet("SABIN") clear
keep in 884/1271
keep B H I X
gen month = substr(I,5,2)
drop I
rename * (Delegation year opv3_qual month)
destring year opv3_qual month, replace
order year month, b(opv3_qual)
replace Deleg = "D.F. Norte" if Deleg == "Ciudad de México Norte"
replace Deleg = "D.F. Sur" if Deleg == "Ciudad de México Sur"
collapse (sum) opv3_qual, by(month year Deleg)  // Two delegations include subdelegation data: D.F. Norte (Deleg 35,36) and D.F. Sur (Deleg 37,38)

merge 1:1 Deleg year month using "$user/$data/Data for analysis/Vaccines_20-21.dta"
drop _merge
save "$user/$data/Data for analysis/Vaccines_20-21.dta", replace

********************************************************************************
*Rotavirus 2021
********************************************************************************

import excel using "$user/$data/Raw/2021/Vacunas_Aplicadas_Dosis_Delegacion_202101_202112_Preliminar", sheet("ROTAVIRUS") clear
keep in 18/461
keep B-D
gen year = substr(C,1,4)
gen month = substr(C,5,2)
drop C
rename * (Delegation rota_qual year month)
destring year rota_qual month, replace
order year month, b(rota_qual)
replace Deleg = "D.F. Norte" if Deleg == "Ciudad de México Norte"
replace Deleg = "D.F. Sur" if Deleg == "Ciudad de México Sur"
collapse (sum) rota_qual, by(month year Deleg)  // Two delegations include subdelegation data: D.F. Norte (Deleg 35,36) and D.F. Sur (Deleg 37,38)

merge 1:1 Deleg year month using "$user/$data/Data for analysis/Vaccines_20-21.dta"
drop _merge
save "$user/$data/Data for analysis/Vaccines_20-21.dta", replace

********************************************************************************
*Pneumococcal 2021
********************************************************************************

import excel using "$user/$data/Raw/2021/Vacunas_Aplicadas_Dosis_Delegacion_202101_202112_Preliminar", sheet("ANTINEUMOCOCCICA") clear
keep in 18/461
keep B C E  // Only children were included because there are also adults in the database
gen year = substr(C,1,4)
gen month = substr(C,5,2)
drop C
rename * (Delegation pneum_qual year month)
destring year pneum_qual month, replace
order year month, b(pneum_qual)
replace Deleg = "D.F. Norte" if Deleg == "Ciudad de México Norte"
replace Deleg = "D.F. Sur" if Deleg == "Ciudad de México Sur"
collapse (sum) pneum_qual, by(month year Deleg)  // Two delegations include subdelegation data: D.F. Norte (Deleg 35,36) and D.F. Sur (Deleg 37,38)

merge 1:1 Deleg year month using "$user/$data/Data for analysis/Vaccines_20-21.dta"
drop _merge
save "$user/$data/Data for analysis/Vaccines_20-21.dta", replace

********************************************************************************
*Create variable Pentavalent
********************************************************************************

use "$user/$data/Data for analysis/Vaccines_20-21.dta", clear
gen pent_qual= pent1_qual + pent2_qual
drop pent1_qual pent2_qual
order (Deleg year month bcg_qual pent_qual measles_qual opv3_qual rota_qual pneum_qual)

save "$user/$data/Data for analysis/Vaccines_20-21.dta", replace

********************************************************************************
*Add National information
********************************************************************************

use "$user/$data/Data for analysis/Vaccines_20-21.dta", clear
collapse (sum) bcg_qual pent_qual measles_qual opv3_qual rota_qual pneum_qual, by(month year)

save "$user/$data/Data for analysis/Vaccines_Nat.dta", replace  // National information


use "$user/$data/Data for analysis/Vaccines_Nat.dta", clear
append using "$user/$data/Data for analysis/Vaccines_20-21.dta"
replace Deleg = "National" if Deleg ==""
drop if month == 12 & year == 2021 // December data not included

save "$user/$data/Data for analysis/Vaccines_20-21.dta", replace 

********************************************************************************
*Update information vaccines 2020-2021
********************************************************************************

use "$user/$data/Data for analysis/Vaccines_20-21.dta", clear
merge 1:1 Deleg year month using "$user/$data/Data for analysis/IMSS_service_delivery_updated2021_nat.dta" // Previous database
drop _merge
order Deleg, first
format Deleg %25s
order bcg_qual pent_qual measles_qual opv3_qual rota_qual pneum_qual, b(cerv_util)
sort Deleg year month

*9 values of BCG qual that should be 0, 6 for measles
replace bcg_qual = 0 if bcg_qual == .
replace measles_qual = 0 if measles_qual == .

drop vax_util
egen vax_util = rowtotal(pent_qual bcg_qual measles_qual rota_qual pneum_qual), m
lab var vax_util "Child vaccinations"
order vax_util, b(sc_util)

save "$user/$data/Data for analysis/IMSS_service_delivery_updated2021_nat_v2.dta", replace


use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021_nat_v2.dta", clear
drop if Deleg=="National"
drop deleg 
encode Deleg, gen(deleg)

save "$user/$data/Data for analysis/IMSS_service_delivery_updated2021_v2.dta", replace



