* Analysis do file

* Service delivery at IMSS during Covid 19 
* Created by: Catherine Arsenault, Dec 2020
* Modified by: Hannah Leslie, Nov 2021 for updated analysis
* Last edited 15 Mar 2022

use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021_nat_v2.dta", clear 
global maternal fp_util anc_util totaldel cs_rate
global child sc_util vax_util 
global chronic cerv_util breast_util diab_util  hyper_util  
global serv $maternal $child $chronic
global qual diab_qual hyper_qual
global all $child $maternal $chronic $qual

*Define covariates
global covars postPolicy timeafter_pol timeafter_cov ln_beds spring summer fall 
global covars_lag postPolicy_lag timeafter_pol_lag timeafter_cov_lag ln_beds_lag spring summer fall 
global covars_lag1 postPolicy_lag timeafter_pol_lag timeafter_cov ln_beds spring summer fall 
global covars_lag2 postPolicy_lag2 timeafter_pol_lag2 timeafter_cov_lag ln_beds_lag spring summer fall 
global seasons rmonth spring summer fall 

********************************************************************************
*Table 1: Service volume by time period
********************************************************************************
use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021_v2.dta", clear
* Loop over all variables
foreach v of var Deleg period fp_util anc_util totaldel cs_util sc_util cerv_util breast_util diab_util hyper_util vax_util cs_rate diab_qual hyper_qual {
  * Store variable label in a local
        local lab`v' : variable label `v'
            if `"`lab`v''"' == "" {
            local lab`v' "`v'"
        }
}

* Tiny .do file to run after copylabels.do > collapse
collapse (mean) fp_util anc_util totaldel cs_util sc_util cerv_util breast_util diab_util hyper_util vax_util cs_rate diab_qual hyper_qual, by(Deleg period)

foreach v of var * {
        label var `v' "`lab`v''"
}

summtab, contvars($all) by(period) median medfmt(0) word wordname(Table1median) replace directory("$user/$analysis/Results")


********************************************************************************
* FIGURE 1 GRAPHS WITH TRENDS
******************************************************************************** 
use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021_nat_v2.dta", clear
cd "$user/$analysis/Results/graphs"	
keep if Deleg == "National"
lab var fp_util "Contraceptive use"
lab var vax_util "Child vaccination"
lab var anc_util "ANC"
lab var sc_util "Sick child"
lab var hyper_util "Hypertension care"
lab var diab_util "Diabetes care"
lab var cerv_util "Cerv. cancer screening"
lab var bcg_qual "BCG"
lab var pneum_qual "Pneumococcal"
lab var measles_qual "MMR"
lab var rota_qual "Rotavirus"
lab var pent_qual "Pentavalent"
lab var cs_rate "Cesarean section"
lab var hyper_qual "Controlled hypertension"
lab var diab_qual "Controlled diabetes"
egen rmonth2 = group(year month), label
lab def rmonth2 1 "1/2019" 7 "7/2019" 13 "1/2020" 19 "7/2020" 25 "1/2021" 31 "7/2021", modify
*drop if rmonth < 13

foreach var of varlist fp_util anc_util totaldel sc_util vax_util $chronic bcg_qual pneum_qual rota_qual measles_qual pent_qual  {
	replace `var' = `var' / 1000
}

global gph_set "xline(14.8, lpattern(dash) lcolor(gray)) xline(27.8, lpattern(longdash) lcolor(gray)) xtitle("") graphregion(color(white)) xtick(1(3)36)  graphregion(color(white)) ysize(5) xsize(7) legend(size(vsmall)) xlabel(1 7 13 19 25 31, value labsize(vsmall)) xtitle("") yscale(range(0(5000)20000) axis(2)) ylabel(#3, labsize(small) axis(2)) ylabel(#3,  labsize(small) axis(1)) legend(symxs(*.5) rows(2) region(lstyle(none))) ytitle("Covid-19 beds occupied", axis(2) size(small)) "	

twoway  (line fp_util anc_util totaldel cerv_util breast_util rmonth2, lpattern(solid dash) lwidth(medthick medthick medthick medthick medthick) lcolor("199 233 180" "127 205 187" "65 182 196" "44 127 184" "37 52 148")) (spike beds rmonth2, yaxis(2) color(gs10)) , $gph_set ytitle("") legend(order (1 2 3 4 - 5)) subtitle("Women's health", size(medsmall))
graph save "Fig1Aalt.gph", replace

twoway  (line bcg_qual pneum_qual rota_qual measles_qual pent_qual rmonth2,  lcolor("199 233 192" "161 217 155" "116 196 118" "49 163 84" "0 109 44") lwidth(medthick medthick medthick medthick medthick) lpattern(solid dash solid dash solid)) (spike beds rmonth2, yaxis(2) color(gs10)) (line sc_util rmonth2, lwidth(thick) lcolor(gold)), $gph_set ytitle("Visits (thousands)", axis(1) size(small)) legend(order (6 1 2 3 4 5)) subtitle("Child health" , size(medsmall))
graph save "Fig1Balt.gph", replace

twoway  (line diab_util hyper_util rmonth2 , lwidth(medthick medthick) lcolor("122 1 119" "247 104 161")) (spike beds rmonth2, yaxis(2) color(gs10)), $gph_set ytitle("Visits (thousands)", size(small) axis(1)) legend( order (1 2)) subtitle("NCD", size(medsmall)) yscale(range(0(500)1500) axis(1))
graph save "Fig1Calt.gph", replace

twoway  (line cs_rate $qual rmonth2 , lwidth(medthick medthick medthick) lcolor("65 182 196" "197 27 138" "250 159 181")) (spike beds rmonth2, yaxis(2) color(gs10)), $gph_set ylabel(#6) yscale(range(0(20)100)) ytitle("Percent", size(small) axis(1)) legend(order (1 - 2 3) ) subtitle("Care outcomes", size(medsmall))
graph save "Fig1Dalt.gph", replace

graph combine "Fig1Balt.gph" "Fig1Aalt.gph"  "Fig1Calt.gph" "Fig1Dalt.gph", cols(2) graphregion(color(white)) ysize(7) xsize(10)
graph export "Fig1.jpg", quality(100) replace

********************************************************************************
* Table 2
* REGRESSION ANALYSES 
* Poisson GEE models, exposure, exchangeable correlation
********************************************************************************
use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021_v2.dta", clear
* Declare data to be time series panel data
xtset deleg rmonth

*AR for sc_util vax_util cerv_util breast_util diab_util  hyper_util 
*Exc for fp_util anc_util totaldel cs_util diab_qual hyper_qual

foreach var of varlist fp_util anc_util totaldel {
	xtgee `var' $covars, family(poisson) link(log) exposure(women1549) corr(exc) vce(robust)
	eststo pm_`var'
	xtgee `var' $seasons if period == 1, family(poisson) link(log) exposure(women1549) corr(exc) vce(robust)
	eststo pcpm_`var'

}

xtgee sc_util $covars, family(poisson) link(log) exposure(u5) corr(ar1) vce(robust)
	eststo pm_sc_util
xtgee sc_util $seasons if period == 1, family(poisson) link(log) exposure(u5) corr(ar1) vce(robust)
	eststo pcpm_sc_util

xtgee vax_util $covars, family(poisson) link(log) exposure(u10) corr(ar1) vce(robust)
	eststo pm_vax_util
xtgee vax_util $seasons if period == 1, family(poisson) link(log) exposure(u10) corr(ar1) vce(robust)
	eststo pcpm_vax_util

xtgee cerv_util $covars, family(poisson) link(log) exposure(women2564) corr(ar1) vce(robust)
	eststo pm_cerv_util
xtgee cerv_util $seasons if period == 1, family(poisson) link(log) exposure(women2564) corr(ar1) vce(robust)
	eststo pcpm_cerv_util

xtgee breast_util $covars, family(poisson) link(log) exposure(women5069) corr(ar1) vce(robust)
	eststo pm_breast_util
xtgee breast_util $seasons if period == 1, family(poisson) link(log) exposure(women5069) corr(ar1) vce(robust)
	eststo pcpm_breast_util

foreach var of varlist diab_util hyper_util {
	xtgee `var' $covars, family(poisson) link(log) exposure(all20plus) corr(ar1) vce(robust)
	eststo pm_`var'
	xtgee `var' $seasons if period == 1, family(poisson) link(log) exposure(all20plus) corr(ar1) vce(robust)
	eststo pcpm_`var'
}

xtgee cs_util $covars, family(poisson) link(log) exposure(totaldel) corr(exc) vce(robust)
eststo pm_cs
xtgee cs_util $seasons if period == 1, family(poisson) link(log) exposure(totaldel) corr(exc) vce(robust)
eststo pcpm_cs

xtgee diab_qual_num $covars_lag, family(poisson) link(log) exposure(diab_util) corr(exc) vce(robust)
eststo pm_diab_qual_num

xtgee diab_qual_num $seasons if period == 1, family(nbinomial) vce(robust) exposure(diab_util) corr(exc)
eststo pcpm_diab_qual_num

xtgee hyper_qual_num $covars_lag, family(poisson) link(log) exposure(hyper_util) corr(exc) vce(robust)
eststo pm_hyper_qual_num
xtgee hyper_qual_num $seasons if period == 1, family(nbinomial) link(log) exposure(hyper_util) corr(exc) vce(robust)
eststo pcpm_hyper_qual_num

esttab pm_sc_util pm_vax_util  using "$user/$analysis/Results/Table2.rtf", eform replace wide b(2) ci(2) nostar compress /// 
 title( "A: Child health services") mtitles ("Sick child visits" "Vaccination") rename(timeafter_cov "Months into pandemic" postPolicy "NHSR Strategy" timeafter_pol "Months into NHSR" ln_beds "Covid inpatients, log" spring "Spring" summer "Summer" fall "Fall")

esttab pm_fp_util pm_anc_util pm_totaldel pm_cs using "$user/$analysis/Results/Table2.rtf", eform append wide b(2) ci(2) nostar compress /// 
 title( "B: Reproductive and maternal health services") mtitles ("Contraceptive use" "ANC" "Delivery" "C-sections") rename(timeafter_cov "Months into pandemic" postPolicy "NHSR Strategy" timeafter_pol "Months into NHSR" ln_beds "Covid inpatients, log" spring "Spring" summer "Summer" fall "Fall")

esttab pm_cerv_util pm_breast_util using "$user/$analysis/Results/Table2.rtf", eform append wide b(2) ci(2) nostar compress /// 
 title( "C: Cancer screening services") mtitles ("Cervical cancer" "Breast cancer") rename(timeafter_cov "Months into pandemic" postPolicy "NHSR Strategy" timeafter_pol "Months into NHSR" ln_beds "Covid inpatients, log" spring "Spring" summer "Summer" fall "Fall")

esttab pm_diab_util pm_hyper_util using "$user/$analysis/Results/Table2.rtf", eform append wide b(2) ci(2) nostar compress /// 
 title( "D: NCD service use") mtitles ("Diabetes visits" "Hypertension visits") rename(timeafter_cov "Months into pandemic" postPolicy "NHSR Strategy" timeafter_pol "Months into NHSR" ln_beds "Covid inpatients, log" spring "Spring" summer "Summer" fall "Fall")

esttab  pm_diab_qual_num  pm_hyper_qual_num using "$user/$analysis/Results/Table2.rtf", eform append wide b(2) ci(2) nostar compress /// 
 title( "E: NCD service outcomes") mtitles ("Diabetes control" "Hypertension control") rename(timeafter_cov_lag "Months into pandemic (1 mo. lag)" postPolicy_lag "NHSR Strategy (1 mo. lag)" timeafter_pol_lag "Months into NHSR (1 mo. lag)" ln_beds_lag "Covid inpatients, log (1 mo. lag)" spring "Spring" summer "Summer" fall "Fall")


********************************************************************************
* NUMBER OF VISITS During policy period
*Figure 2
********************************************************************************
cd "$user/$analysis/Results/graphs"	

expand 2 if period == 3, gen(counterfact)
replace postPolicy = 0 if counterfact == 1
replace timeafter_pol = 0 if counterfact == 1
replace postPolicy_lag = 0 if counterfact == 1
replace timeafter_pol_lag = 0 if counterfact == 1

cap drop cs_rate

foreach var in fp_util anc_util totaldel  sc_util  vax_util cerv_util breast_util diab_util hyper_util cs diab_qual_num hyper_qual_num {
	estimates restore pm_`var'
	predict prd_`var'xb, xb
	predict stdp_`var', stdp
	gen lcl`var'= prd_`var'xb-(invnormal(1-.05/2)*stdp_`var') // conf. interval
	gen ucl`var'= prd_`var'xb+(invnormal(1-.05/2)*stdp_`var')	
	gen prd_`var' = exp(prd_`var'xb)
	replace lcl`var' = exp(lcl`var')
	replace ucl`var' = exp(ucl`var')
	gen prd_obs`var' = `var' > ucl`var' if period == 3
	replace prd_obs`var' = prd_obs`var' + 1 if `var' > lcl`var' & period == 3
	lab var prd_obs`var' obsprd
}

foreach var in fp_util anc_util totaldel  sc_util  vax_util cerv_util breast_util diab_util hyper_util cs diab_qual_num hyper_qual_num {
	estimates restore pcpm_`var'
	predict PCprd_`var'xb, xb
	predict PCstdp_`var', stdp
	gen PClcl`var'= PCprd_`var'xb-(invnormal(1-.05/2)*PCstdp_`var') // conf. interval
	gen PCucl`var'= PCprd_`var'xb+(invnormal(1-.05/2)*PCstdp_`var')	
	gen PCprd_`var' = exp(PCprd_`var'xb)
	replace PClcl`var' = exp(PClcl`var')
	replace PCucl`var' = exp(PCucl`var')
}

foreach x in fp_util sc_util diab_util anc_util totaldel vax_util cerv_util breast_util  hyper_util cs  diab_qual_num hyper_qual_num {
	local label: variable label `x'
*	keep if timeafter_pol == 3
	twoway  (rcap lcl`x' ucl`x' pop_rank if rmonth == 35 & counterfact == 1, horiz msize(tiny) color(navy%75)) (scatter pop_rank `x' if timeafter_pol == 8 & counterfact == 0, symbol(x) color(maroon))  , graphregion(color(white)) legend(order(2 "Observed Nov. 2021" 1 "Range predicted pre-policy") rows(1) symxs(*.4) size(vsmall))  subtitle("`label'", size(small)) ytitle("") ylabel(1(1)35, alt angle(0) val labsize(tiny) nogrid) xlabel(#3)
	graph save "pred_`x'.gph", replace
		twoway  (rcap PClcl`x' PCucl`x' pop_rank if rmonth == 35 & counterfact == 0, horiz msize(tiny) color(navy%55)) (scatter pop_rank `x' if timeafter_pol == 8 & counterfact == 0, symbol(x) color(maroon)), graphregion(color(white)) legend(order(2 "Observed Nov. 2021" 1 "Range predicted pre-Covid") rows(1) symxs(*.4) size(vsmall))  subtitle("`label'", size(small)) ytitle("") ylabel(1(1)35, alt angle(0) val labsize(tiny) nogrid) xlabel(#3)
	graph save "PCpred_`x'.gph", replace
}

grc1leg2 "pred_sc_util.gph" "pred_vax_util.gph" "pred_fp_util.gph" "pred_anc_util.gph" "pred_totaldel.gph" "pred_cs.gph"  , rows(3) graphregion(color(white)) ysize(10) xsize(7.5) lrows(1) symxs(*.4) labsize(vsmall)

graph export "Figure2A.jpg", quality(100) replace

grc1leg2  "pred_cerv_util.gph" "pred_breast_util.gph" "pred_diab_util.gph"  "pred_hyper_util.gph"  "pred_diab_qual_num.gph" "pred_hyper_qual_num.gph", rows(3) graphregion(color(white)) ysize(10) xsize(7.5) lrows(1) symxs(*.4) labsize(vsmall)

graph export "Figure2B.jpg", quality(100) replace

grc1leg2 "PCpred_sc_util.gph" "PCpred_vax_util.gph" "PCpred_fp_util.gph" "PCpred_anc_util.gph" "PCpred_totaldel.gph" "PCpred_cs.gph"  , rows(3) graphregion(color(white)) ysize(10) xsize(7.5) lrows(1) symxs(*.4) labsize(vsmall)

graph export "Figure2Asup.jpg", quality(100) replace

grc1leg2  "PCpred_cerv_util.gph" "PCpred_breast_util.gph" "PCpred_diab_util.gph"  "PCpred_hyper_util.gph"  "PCpred_diab_qual_num.gph" "PCpred_hyper_qual_num.gph", rows(3) graphregion(color(white)) ysize(10) xsize(7.5) lrows(1) symxs(*.4) labsize(vsmall)

graph export "Figure2Bsup.jpg", quality(100) replace

*Table 3 - November 2021
preserve
keep if counterfact == 1 & rmonth == 35
collapse (sum) fp_util *prd_fp_util anc_util *prd_anc_util totaldel *prd_totaldel cs_util *prd_cs sc_util *prd_sc_util vax_util *prd_vax_util cerv_util *prd_cerv_util breast_util *prd_breast_util diab_util *prd_diab_util hyper_util *prd_hyper_util diab_qual_num hyper_qual_num *prd_diab_qual_num *prd_hyper_qual_num

foreach x in diab hyper {
	gen `x'_qual = `x'_qual_num / `x'_util * 100
	gen prd_`x'_qual = prd_`x'_qual_num / `x'_util * 100
	gen PCprd_`x'_qual = PCprd_`x'_qual_num / `x'_util * 100
}

tabstat sc_util *prd_sc_util vax_util *prd_vax_util fp_util *prd_fp_util anc_util *prd_anc_util totaldel *prd_totaldel cs_util *prd_cs  cerv_util *prd_cerv_util breast_util *prd_breast_util diab_util *prd_diab_util hyper_util *prd_hyper_util diab_qual *prd_diab_qual hyper_qual *prd_hyper_qual, stat(sum) c(s) format(%12.0gc)
restore

********************************************************************************
* SUPPLEMENTARY MATERIALS
********************************************************************************
*  EFFECT ON ALL 5 VACCINES SEPARATELY
********************************************************************************	
*Supplemental Table 1: indicator definitions, no data

*Supplemental Table 2:  Vaccines administered
use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021_v2.dta", clear
preserve
* Loop over all variables
foreach v of var Deleg period pent_qual measles_qual rota_qual pneum_qual bcg_qual {
  * Store variable label in a local
        local lab`v' : variable label `v'
            if `"`lab`v''"' == "" {
            local lab`v' "`v'"
        }
}

* Tiny .do file to run after copylabels.do > collapse
collapse (mean) pent_qual measles_qual rota_qual pneum_qual bcg_qual, by(Deleg period)

foreach v of var * {
        label var `v' "`lab`v''"
}

summtab, contvars(bcg_qual pent_qual measles_qual rota_qual pneum_qual) by(period) median medfmt(0) word wordname(STable2) replace directory("$user/$analysis/Results")

restore 

*Supplemental Table 3: Poisson regression models of each vaccine
* Regressions
xtset deleg rmonth

foreach var of varlist pent_qual measles_qual rota_qual pneum_qual {
	xtgee `var' $covars, family(poisson) link(log) exposure(u10) corr(ar1) vce(robust)
	eststo pm_`var'
}

xtgee bcg_qual $covars, family(poisson) link(log) exposure(u1) corr(ar1) vce(robust)
	eststo pm_bcg_qual
	
esttab pm_bcg_qual pm_pent_qual pm_measles_qual pm_rota_qual pm_pneum_qual using "$user/$analysis/Results/STable3.rtf", eform replace wide b(2) ci(2) nostar compress /// 
 title( "Supplemental Table: Individual vaccine use") mtitles("BCG" "Pentavalent" "Measles" "Rotavirus" "Pneumococcal") rename(timeafter_cov "Months into pandemic" postPolicy "NHSR Strategy" timeafter_pol "Months into NHSR" ln_beds "Covid inpatients, log" spring "Spring" summer "Summer" fall "Fall")
 
*Supplemental Table 4: Alternative model specifications 
**** A: All outcomes, linear regression with appropriate correlation structure
*Updated with data from Covid to Nov 2021, ln_beds:
*AR for fp_util anc_util cs_rate vax_util cerv_util breast_util 
*Exc for totaldel  sc_util  diab_util hyper_util diab_qual hyper_qual
use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021_v2.dta", clear 

global ar_vars fp_util anc_util cs_rate vax_util cerv_util breast_util 
global exc_vars totaldel  sc_util  diab_util hyper_util
global exc_vars_lag diab_qual hyper_qual
* Declare data to be time series panel data
xtset deleg rmonth

*Limit to Covid data onwards
drop if rmonth < 16 
* Call GEE, export RR to excel

foreach var of global exc_vars {

	xtgee `var' $covars, family(gaussian) link(identity) corr(exchangeable) vce(robust)	
	eststo m_`var'	
	}

foreach var of global ar_vars {
	
	xtgee `var' $covars, family(gaussian) link(identity) corr(ar1) vce(robust)	
	eststo m_`var'

	}

drop if rmonth < 17
foreach var of global exc_vars_lag {
	
	xtgee `var' $covars_lag, family(gaussian) link(identity) corr(exchangeable) vce(robust)	
	eststo mlag_`var'
}

esttab m_sc_util m_vax_util  using "$user/$analysis/Results/STable4A.rtf",  replace wide b(2) ci(2) nostar compress /// 
 title( "A: Child health services") mtitles ("Sick child visits" "Vaccination") rename(timeafter_cov "Months into pandemic" postPolicy "NHSR Strategy" timeafter_pol "Months into NHSR" ln_beds "Covid inpatients, log" spring "Spring" summer "Summer" fall "Fall")

esttab m_fp_util m_anc_util m_totaldel m_cs_rate using "$user/$analysis/Results/STable4A.rtf",  append wide b(2) ci(2) nostar compress /// 
 title( "B: Reproductive and maternal health services") mtitles ("Contraceptive use" "ANC" "Delivery" "C-sections") rename(timeafter_cov "Months into pandemic" postPolicy "NHSR Strategy" timeafter_pol "Months into NHSR" ln_beds "Covid inpatients, log" spring "Spring" summer "Summer" fall "Fall")

esttab m_cerv_util m_breast_util using "$user/$analysis/Results/STable4A.rtf",  append wide b(2) ci(2) nostar compress /// 
 title( "C: Cancer screening services") mtitles ("Cervical cancer" "Breast cancer") rename(timeafter_cov "Months into pandemic" postPolicy "NHSR Strategy" timeafter_pol "Months into NHSR" ln_beds "Covid inpatients, log" spring "Spring" summer "Summer" fall "Fall")

esttab m_diab_util m_hyper_util using "$user/$analysis/Results/STable4A.rtf",  append wide b(2) ci(2) nostar compress /// 
 title( "D: NCD service use") mtitles ("Diabetes visits" "Hypertension visits") rename(timeafter_cov "Months into pandemic" postPolicy "NHSR Strategy" timeafter_pol "Months into NHSR" ln_beds "Covid inpatients, log" spring "Spring" summer "Summer" fall "Fall")

esttab  mlag_diab_qual mlag_hyper_qual using "$user/$analysis/Results/STable4A.rtf",  append wide b(2) ci(2) nostar compress /// 
 title( "E: NCD service outcomes") mtitles ("Diabetes control" "Hypertension control") rename(timeafter_cov_lag "Months into pandemic (1 mo. lag)" postPolicy_lag "NHSR Strategy (1 mo. lag)" timeafter_pol_lag "Months into NHSR (1 mo. lag)" ln_beds_lag "Covid inpatients, log (1 mo. lag)" spring "Spring" summer "Summer" fall "Fall")

 
**B: adding 1 mo. lag to the policy variables
use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021_v2.dta", clear
* Declare data to be time series panel data
xtset deleg rmonth

*AR for sc_util vax_util cerv_util breast_util diab_util  hyper_util 
*Exc for fp_util anc_util totaldel cs_util diab_qual hyper_qual


foreach var of varlist fp_util anc_util totaldel {
	xtgee `var' $covars_lag1, family(poisson) link(log) exposure(women1549) corr(exc) vce(robust)
	eststo pmlag_`var'
}

xtgee sc_util $covars_lag1, family(poisson) link(log) exposure(u5) corr(ar1) vce(robust)
	eststo pmlag_sc_util


xtgee vax_util $covars_lag1, family(poisson) link(log) exposure(u10) corr(ar1) vce(robust)
	eststo pmlag_vax_util


xtgee cerv_util $covars_lag1, family(poisson) link(log) exposure(women2564) corr(ar1) vce(robust)
	eststo pmlag_cerv_util


xtgee breast_util $covars_lag1, family(poisson) link(log) exposure(women5069) corr(ar1) vce(robust)
	eststo pmlag_breast_util


foreach var of varlist diab_util hyper_util {
	xtgee `var' $covars_lag1, family(poisson) link(log) exposure(all20plus) corr(ar1) vce(robust)
	eststo pmlag_`var'

}

xtgee cs_util $covars_lag1, family(poisson) link(log) exposure(totaldel) corr(exc) vce(robust)
eststo pmlag_cs

xtgee diab_qual_num $covars_lag2, family(poisson) link(log) exposure(diab_util) corr(exc) vce(robust)
eststo pmlag_diab_qual_num

xtgee hyper_qual_num $covars_lag2, family(poisson) link(log) exposure(hyper_util) corr(exc) vce(robust)
eststo pmlag_hyper_qual_num

esttab pmlag_sc_util pmlag_vax_util  using "$user/$analysis/Results/STable4B.rtf", eform replace wide b(2) ci(2) nostar compress /// 
 title( "A: Child health services") mtitles ("Sick child visits" "Vaccination") rename(timeafter_cov "Months into pandemic" postPolicy_lag "NHSR Strategy (1 mo. lag)" timeafter_pol_lag "Months into NHSR (1 mo. lag)" ln_beds "Covid inpatients, log" spring "Spring" summer "Summer" fall "Fall")

esttab pmlag_fp_util pmlag_anc_util pmlag_totaldel pmlag_cs using "$user/$analysis/Results/STable4B.rtf", eform append wide b(2) ci(2) nostar compress /// 
 title( "B: Reproductive and maternal health services") mtitles ("Contraceptive use" "ANC" "Delivery" "C-sections") rename(timeafter_cov "Months into pandemic" postPolicy_lag "NHSR Strategy (1 mo. lag)" timeafter_pol_lag "Months into NHSR (1 mo. lag)" ln_beds "Covid inpatients, log" spring "Spring" summer "Summer" fall "Fall")



esttab pmlag_cerv_util pmlag_breast_util using "$user/$analysis/Results/STable4B.rtf", eform append wide b(2) ci(2) nostar compress /// 
 title( "C: Cancer screening services") mtitles ("Cervical cancer" "Breast cancer") rename(timeafter_cov "Months into pandemic" postPolicy_lag "NHSR Strategy (1 mo. lag)" timeafter_pol_lag "Months into NHSR (1 mo. lag)" ln_beds "Covid inpatients, log" spring "Spring" summer "Summer" fall "Fall")

esttab pmlag_diab_util pmlag_hyper_util using "$user/$analysis/Results/STable4B.rtf", eform append wide b(2) ci(2) nostar compress /// 
 title( "D: NCD service use") mtitles ("Diabetes visits" "Hypertension visits") rename(timeafter_cov "Months into pandemic" postPolicy_lag "NHSR Strategy (1 mo. lag)" timeafter_pol_lag "Months into NHSR (1 mo. lag)" ln_beds "Covid inpatients, log" spring "Spring" summer "Summer" fall "Fall")

 esttab  pmlag_diab_qual_num pmlag_hyper_qual_num using "$user/$analysis/Results/STable4B.rtf", eform append wide b(2) ci(2) nostar compress /// 
 title( "E: NCD service outcomes") mtitles ("Diabetes control" "Hypertension control") rename(timeafter_cov_lag "Months into pandemic (1 mo. lag)" postPolicy_lag2 "NHSR Strategy (2 mo. lag)" timeafter_pol_lag2 "Months into NHSR (2 mo. lag)" ln_beds_lag "Covid inpatients, log (1 mo. lag)" spring "Spring" summer "Summer" fall "Fall")
 