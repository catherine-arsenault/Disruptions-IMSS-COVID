* Analysis do file

* Service delivery at IMSS during Covid 19 
* Created by: Catherine Arsenault, Dec 2020
* Last edited July, 2021

use "$user/$data/Data for analysis/IMSS_service_delivery.dta", clear 
********************************************************************************
* REGRESSION ANALYSES (RISK RATIOS)
* Linear GEE models, exchangeable correlation
********************************************************************************
* Declare data to be time series panel data
xtset deleg rmonth

* Call GEE, export RR to excel
putexcel set "$user/$analysis/Results/Results Service delivery paper IMSS Jul14 revisions.xlsx", sheet(FIG1, replace)  modify
putexcel A2 = "Indicator" B2="RR" C2="LCL" D2="UCL" 
local i = 2

foreach var of global all {
	local i = `i'+1
	
	xtgee `var' i.postCovid rmonth timeafter spring-winter , family(gaussian) ///
	link(identity) corr(exchangeable) vce(robust)	
	
	margins postCovid, post
	nlcom (rr: (_b[1.postCovid]/_b[0.postCovid])) , post
	putexcel A`i' = "`var'"
	putexcel B`i'= (_b[rr])
	putexcel C`i'= (_b[rr]-invnormal(1-.05/2)*_se[rr])  
	putexcel D`i'= (_b[rr]+invnormal(1-.05/2)*_se[rr])
}
********************************************************************************
* FOREST PLOT WITH RISK RATIOS
********************************************************************************
import excel using "$user/$analysis/Results/Results Service delivery paper IMSS Jul14 revisions.xlsx", sheet(FIG1) firstrow clear
gen rr = ln(RR)
gen lcl= ln(LCL)
gen ucl = ln(UCL)
gen cat=""
foreach var of global maternal {
	replace cat="Reproductive and maternal health care" if Indicator=="`var'"
}
foreach var of global child {
	replace cat="Child health care" if Indicator=="`var'"
}
foreach var of global chronic {
	replace cat="Chronic disease care" if Indicator=="`var'"
}
replace Indic = "Contraceptives" if Indic=="fp_util"
replace Indic = "Antenatal care" if Indic=="anc_util"
replace Indic = "Delivery" if Indic=="totaldel"
replace Indic = "Caesarean section rate" if Indic=="cs_rate"
replace Indic = "Sick child" if Indic=="sc_util"
replace Indic = "Vaccinations" if Indic=="vax_util" 
replace Indic = "Cervical cancer" if Indic=="cerv_util"
replace Indic = "Breast cancer" if Indic=="breast_util"
replace Indic = "Diabetes" if Indic=="diab_util"
replace Indic = "Controlled diabetes" if Indic=="diab_qual"
replace Indic = "Hypertension" if Indic=="hyper_util"
replace Indic = "Controlled hypertension" if Indic=="hyper_qual"

metan rr lcl ucl , by(cat) nosubgroup eform nooverall nobox ///
label(namevar=Indicator) force graphregion(color(white)) ///
xlabel(0.1, 0.5, 0.9, 1.1) xtick (0.1, 0.5, 0.9, 1.1) effect(RR)

********************************************************************************
* FIGURE 2 GRAPHS
******************************************************************************** 
* Volumes
* fp_util
			 use "$user/$data/Data for analysis/IMSS_service_delivery.dta", clear
			 drop if rmonth>15
			 xtset deleg rmonth
			 xtgee fp_util rmonth , family(gaussian) ///
				link(identity) corr(exchangeable) vce(robust)	

			u "$user/$data/Data for analysis/IMSS_service_delivery.dta", clear
			rename fp_util fp_util_real
			predict fp_util

			collapse (sum) fp_util_real fp_util , by(rmonth)

			twoway (line fp_util_real rmonth, sort) (line fp_util rmonth) ///
			(lfit fp_util_real rmonth if rmonth>=16 & rmonth<. , lcolor(green)),  ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Contraceptive users", size(small)) ///
			xlabel(1(1)24) xlabel(, labsize(small)) ylabel(0(10000)70000, labsize(small))

			graph export "$user/$analysis/Results/graphs/fp_util.pdf", replace
* anc_util
			 use "$user/$data/Data for analysis/IMSS_service_delivery.dta", clear
			 drop if rmonth>15
			 xtset deleg rmonth
			 xtgee anc_util rmonth, family(gaussian) ///
				link(identity) corr(exchangeable) vce(robust)	

			u "$user/$data/Data for analysis/IMSS_service_delivery.dta", clear
			rename anc_util anc_util_real
			predict anc_util

			collapse (sum) anc_util_real anc_util , by(rmonth)

			twoway (line anc_util_real rmonth, sort) (line anc_util rmonth) ///
			(lfit anc_util_real rmonth if rmonth>=16 & rmonth<. , lcolor(green)),  ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Antenatal care visits", size(small)) ///
			xlabel(1(1)24, labsize(small))  ylabel(50000(50000)400000, labsize(small))

			graph export "$user/$analysis/Results/graphs/anc_util.pdf", replace
* totaldel
			 use "$user/$data/Data for analysis/IMSS_service_delivery.dta", clear
			 drop if rmonth>15
			 xtset deleg rmonth
			 xtgee totaldel rmonth, family(gaussian) ///
				link(identity) corr(exchangeable) vce(robust)	

			u "$user/$data/Data for analysis/IMSS_service_delivery.dta", clear
			rename totaldel totaldel_real
			predict totaldel

			collapse (sum) totaldel_real totaldel , by(rmonth)

			twoway (line totaldel_real rmonth, sort) (line totaldel rmonth) ///
			(lfit totaldel_real rmonth if rmonth>=16 & rmonth<. , lcolor(green)),  ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Deliveries", size(small)) ///
			xlabel(1(1)24) xlabel(, labsize(vsmall)) ylabel(0(5000)45000, labsize(vsmall))

			graph export "$user/$analysis/Results/graphs/totaldel.pdf", replace
* sc_util
			 use "$user/$data/Data for analysis/IMSS_service_delivery.dta", clear
			 drop if rmonth>15
			 xtset deleg rmonth
			 xtgee sc_util rmonth , family(gaussian) ///
				link(identity) corr(exchangeable) vce(robust)	

			u "$user/$data/Data for analysis/IMSS_service_delivery.dta", clear
			rename sc_util sc_util_real
			predict sc_util

			collapse (sum) sc_util_real sc_util , by(rmonth)

			twoway (line sc_util_real rmonth, sort) (line sc_util rmonth) ///
			(lfit sc_util_real rmonth if rmonth>=16 & rmonth<. , lcolor(green)),  ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Sick child visits", size(small)) ///
			xlabel(1(1)24, labsize(vsmall)) ylabel(0(5000)20000, labsize(vsmall))

			graph export "$user/$analysis/Results/graphs/sc_util.pdf", replace	

* vax_util
			 use "$user/$data/Data for analysis/IMSS_service_delivery.dta", clear
			 drop if rmonth>15
			 xtset deleg rmonth
			 xtgee vax_util rmonth, family(gaussian) ///
				link(identity) corr(exchangeable) vce(robust)	

			u "$user/$data/Data for analysis/IMSS_service_delivery.dta", clear
			rename vax_util vax_util_real
			predict vax_util

			collapse (sum) vax_util_real vax_util , by(rmonth)

			twoway (line vax_util_real rmonth, sort) (line vax_util rmonth) ///
			(lfit vax_util_real rmonth if rmonth>=16 & rmonth<. , lcolor(green)),  ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Vaccinations", size(small)) ///
			xlabel(1(1)24, labsize(vsmall)) ylabel(10000(20000)130000, labsize(vsmall))

			graph export "$user/$analysis/Results/graphs/vax_util.pdf", replace	
			
* cerv_util 

			use "$user/$data/Data for analysis/IMSS_service_delivery.dta", clear
			 drop if rmonth>15
			 xtset deleg rmonth
			 xtgee cerv_util rmonth, family(gaussian) ///
				link(identity) corr(exchangeable) vce(robust)	

			u "$user/$data/Data for analysis/IMSS_service_delivery.dta", clear
			rename cerv_util cerv_util_real
			predict cerv_util

			collapse (sum) cerv_util_real cerv_util , by(rmonth)

			twoway (line cerv_util_real rmonth, sort) (line cerv_util rmonth) ///
			(lfit cerv_util_real rmonth if rmonth>=16 & rmonth<. , lcolor(green)),  ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Cervical cancer screening", size(small)) ///
			xlabel(1(1)24, labsize(vsmall)) ylabel(0(50000)300000, labsize(vsmall))

			graph export "$user/$analysis/Results/graphs/cerv_util.pdf", replace	
			
* breast_util 
			use "$user/$data/Data for analysis/IMSS_service_delivery.dta", clear
			 drop if rmonth>15
			 xtset deleg rmonth
			 xtgee breast_util rmonth, family(gaussian) ///
				link(identity) corr(exchangeable) vce(robust)	

			u "$user/$data/Data for analysis/IMSS_service_delivery.dta", clear
			rename breast_util breast_util_real
			predict breast_util

			collapse (sum) breast_util_real breast_util , by(rmonth)

			twoway (line breast_util_real rmonth, sort) (line breast_util rmonth) ///
			(lfit breast_util_real rmonth if rmonth>=16 & rmonth<. , lcolor(green)),  ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Breast cancer screening", size(small)) ///
			xlabel(1(1)24, labsize(vsmall)) ylabel(0(20000)120000, labsize(vsmall))

			graph export "$user/$analysis/Results/graphs/breast_util.pdf", replace	

*  diab_util  
			use "$user/$data/Data for analysis/IMSS_service_delivery.dta", clear
			 drop if rmonth>15
			 xtset deleg rmonth
			 xtgee diab_util rmonth, family(gaussian) ///
				link(identity) corr(exchangeable) vce(robust)	

			u "$user/$data/Data for analysis/IMSS_service_delivery.dta", clear
			rename diab_util diab_util_real
			predict diab_util

			collapse (sum) diab_util_real diab_util , by(rmonth)

			twoway (line diab_util_real rmonth, sort) (line diab_util rmonth) ///
			(lfit diab_util_real rmonth if rmonth>=16 & rmonth<. , lcolor(green)), ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Diabetes visits", size(small)) ///
			xlabel(1(1)24, labsize(vsmall)) ylabel(200000(200000)1400000, labsize(vsmall))

			graph export "$user/$analysis/Results/graphs/diab_util.pdf", replace	
			
* hyper_util
			use "$user/$data/Data for analysis/IMSS_service_delivery.dta", clear
			 drop if rmonth>15
			 xtset deleg rmonth
			 xtgee hyper_util rmonth, family(gaussian) ///
				link(identity) corr(exchangeable) vce(robust)	

			u "$user/$data/Data for analysis/IMSS_service_delivery.dta", clear
			rename hyper_util hyper_util_real
			predict hyper_util

			collapse (sum) hyper_util_real hyper_util , by(rmonth)

			twoway (line hyper_util_real rmonth, sort) (line hyper_util rmonth) ///
			(lfit hyper_util_real rmonth if rmonth>=16 & rmonth<. , lcolor(green)), ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Hypertension visits", size(small)) ///
			xlabel(1(1)24, labsize(vsmall)) ylabel(200000(200000)1600000, labsize(vsmall))

			graph export "$user/$analysis/Results/graphs/hyper_util.pdf", replace	
			
* Rates
foreach x in  cs_rate  diab_qual hyper_qual {

			 use "$user/$data/Data for analysis/IMSS_service_delivery.dta", clear
			drop if rmonth>15
			xtset deleg rmonth
			xtgee `x' rmonth, family(gaussian) ///
				link(identity) corr(exchangeable) vce(robust)	

			u "$user/$data/Data for analysis/IMSS_service_delivery.dta", clear
			rename `x' `x'_real
			predict `x'

			collapse (mean) `x'_real `x' , by(rmonth)

			twoway (line `x'_real rmonth, sort) (line `x' rmonth) ///
			(lfit `x'_real rmonth if rmonth>=16 & rmonth<. , lcolor(green)) , ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("`x'", size(small)) ///
			xlabel(1(1)22) xlabel(, labsize(small)) ylabel(20(20)80)

			graph export "$user/$analysis/Results/graphs/`x'.pdf", replace
		}
		
********************************************************************************
* NUMBER OF VISITS LOST BY QUARTER OF 2020
********************************************************************************
putexcel set "$user/$analysis/Results/Results Service delivery paper IMSS Jul14 revisions.xlsx", sheet(Totallost_w season, replace)  modify
putexcel A2 = "Indicator" B2="Observed" C2="Predicted" D2="Estimated difference" E2="LCL" F2="UCL" 
local i = 2

foreach x in fp_util  anc_util totaldel sc_util vax_util cerv_util breast_util ///
             diab_util hyper_util 	{
			 use "$user/$data/Data for analysis/IMSS_service_delivery.dta", clear
			 xtset deleg rmonth
			 local i = `i'+1
			 xtgee `x'  rmonth spring-winter if rmonth<16, family(gaussian) ///
				       link(identity) corr(exchangeable) vce(robust) 
			predict prd_`x' // linear predictions based on preCovid months and seasons
			predict stdp_`x', stdp // SEs of the predictions
			
			keep if rmonth>15 // keeps only post-Covid months
			keep Deleg rmonth quarter `x' prd_`x' stdp_`x' 
			gen se2_`x' = stdp_`x'^2 // squares the SEs
			collapse (sum)  `x' prd_`x' se2_`x' , by(quarter) // takes the sum of observed, predicted, squared SEs by quarter
			gen sqrse2`x'= sqrt( se2_`x') // square root of the sum of squares
			gen diff`x' =  prd_`x'-`x' // difference in sums predicted minus observed
			gen lcl`x'= diff`x'-(invnormal(1-.05/2)*sqrse2`x') // conf. interval
			gen ucl`x'= diff`x'+(invnormal(1-.05/2)*sqrse2`x')	
	
	forval j = 2/4 {
			local i = `i'+1
			putexcel A`i'="`x'" 
			qui sum `x' if quarter==`j'
			putexcel B`i'=`r(mean)' 
			
			qui sum prd_`x' if quarter==`j'
			putexcel C`i'= `r(mean)' 
			
			qui sum diff`x' if quarter==`j'
			putexcel D`i'= `r(mean)' 
			
			qui sum lcl`x' if quarter==`j'
			putexcel E`i'=  `r(mean)' 
			
			qui sum ucl`x' if quarter==`j'
			putexcel F`i'= `r(mean)' 
		}
}
********************************************************************************
* SUPP. ANALYSIS: EFFECT ON ALL 5 VACCINES SEPARATELY
********************************************************************************	
use "$user/$data/Data for analysis/IMSS_service_delivery.dta", clear

* Descriptives: Average per month, before and during Covid
by postCovid, sort: tabstat $vax if Deleg=="National", stat(mean sd) col(s)

* Regressions
xtset deleg rmonth
putexcel set "$user/$analysis/Results/Results Service delivery paper IMSS Jul14 revisions.xlsx", sheet(Vaccines RR, replace)  modify
putexcel A2 = "Indicator" B2="RR" C2="LCL" D2="UCL" 
local i = 2

foreach var of global vax {
	local i = `i'+1
	
	xtgee `var' i.postCovid rmonth timeafter spring-winter , family(gaussian) ///
	link(identity) corr(exchangeable) vce(robust)	
	
	margins postCovid, post
	nlcom (rr: (_b[1.postCovid]/_b[0.postCovid])) , post
	putexcel A`i' = "`var'"
	putexcel B`i'= (_b[rr])
	putexcel C`i'= (_b[rr]-invnormal(1-.05/2)*_se[rr])  
	putexcel D`i'= (_b[rr]+invnormal(1-.05/2)*_se[rr])
}

* Forest plot
import excel using "$user/$analysis/Results/Results Service delivery paper IMSS Jul14 revisions.xlsx", sheet(SM2 Vaccines RR) firstrow clear
gen rr = ln(RR)
gen lcl= ln(LCL)
gen ucl = ln(UCL)

replace Indic = "BCG" if Indic=="bcg_qual"
replace Indic = "Pentavalent" if Indic=="pent_qual"
replace Indic = "MMR" if Indic=="measles_qual"
replace Indic = "Pneumococcal" if Indic=="pneum_qual"
replace Indic = "Rotavirus" if Indic=="rota_qual"

metan rr lcl ucl ,  eform nooverall nobox ///
label(namevar=Indicator) force graphregion(color(white)) ///
xlabel(0.1, 0.5, 0.9, 1.1,  1.5) xtick (0.1, 0.5, 0.9, 1.1,  1.5) effect(RR)


