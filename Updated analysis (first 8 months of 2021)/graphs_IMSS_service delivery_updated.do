
********************************************************************************
* GRAPHS
******************************************************************************** 
* NO TRENDS (for commentary)
	use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear 
	collapse (sum) fp_util , by(rmonth)
	twoway (line fp_util rmonth, msize(vsmall)  sort), ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xline(28, lpattern(dash) lcolor(gray)) ytitle("") ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Contraceptive users", size(small)) ///
			xlabel(1(1)32) xlabel(, labsize(small)) ylabel(0(10000)70000, labsize(small))
	
			graph export "$user/$analysis/Results/graphs/raw_fp_util.pdf", replace

	use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear 
	
	collapse (sum) anc_util , by(rmonth)
	twoway (line anc_util rmonth, msize(vsmall)  sort), ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xline(28, lpattern(dash) lcolor(gray)) ytitle("") ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Antenatal care visits", size(small)) ///
			xlabel(1(1)32) xlabel(, labsize(small)) ylabel(0(75000)375000, labsize(small))
	
			graph export "$user/$analysis/Results/graphs/raw_anc_util.pdf", replace	
			
	use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear		
	collapse (sum) totaldel , by(rmonth)
	twoway (line totaldel rmonth, msize(vsmall)  sort), ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xline(28, lpattern(dash) lcolor(gray)) ytitle("") ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Deliveries", size(small)) ///
			xlabel(1(1)32) xlabel(, labsize(small)) ylabel(0(5000)45000, labsize(small))
	
			graph export "$user/$analysis/Results/graphs/raw_totaldel.pdf", replace
	
	use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear		
	collapse (sum) sc_util , by(rmonth)
	twoway (line sc_util rmonth, msize(vsmall)  sort), ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xline(28, lpattern(dash) lcolor(gray)) ytitle("") ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Sick child visits", size(small)) ///
			xlabel(1(1)32) xlabel(, labsize(small)) ylabel(0(5000)20000, labsize(small))
	
			graph export "$user/$analysis/Results/graphs/raw_sc_util.pdf", replace
			
	use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear		
	collapse (sum) vax_util , by(rmonth)
	twoway (line vax_util rmonth, msize(vsmall)  sort), ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xline(28, lpattern(dash) lcolor(gray)) ytitle("") ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Childhood vaccinations", size(small)) ///
			xlabel(1(1)32) xlabel(, labsize(small))  ylabel(10000(20000)130000, labsize(small))
	
			graph export "$user/$analysis/Results/graphs/raw_vax_util.pdf", replace
			
	use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear		
	collapse (sum) cerv_util , by(rmonth)
	twoway (line cerv_util rmonth, msize(vsmall)  sort), ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xline(28, lpattern(dash) lcolor(gray)) ytitle("") ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Cervical cancer screening", size(small)) ///
			xlabel(1(1)32) xlabel(, labsize(small)) ylabel(0(50000)300000, labsize(small))
	
			graph export "$user/$analysis/Results/graphs/raw_cerv_util.pdf", replace
	
	use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear
	collapse (sum) breast_util , by(rmonth)
	twoway (line breast_util rmonth, msize(vsmall)  sort), ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xline(28, lpattern(dash) lcolor(gray)) ytitle("") ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Breast cancer screening", size(small)) ///
			xlabel(1(1)32) xlabel(, labsize(small)) ylabel(0(20000)120000, labsize(small))
	
			graph export "$user/$analysis/Results/graphs/raw_breast_util.pdf", replace
	
	use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear
	collapse (sum) diab_util , by(rmonth)
	twoway (line diab_util rmonth, msize(vsmall)  sort), ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xline(28, lpattern(dash) lcolor(gray)) ytitle("") ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Diabetes visits", size(small)) ///
			xlabel(1(1)32) xlabel(, labsize(small)) ylabel(0(250000)1500000, labsize(small))
	
			graph export "$user/$analysis/Results/graphs/raw_diab_util.pdf", replace
	
	use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear
	collapse (sum) hyper_util , by(rmonth)
	twoway (line hyper_util rmonth, msize(vsmall)  sort), ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xline(28, lpattern(dash) lcolor(gray)) ytitle("") ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Hypertension visits", size(small)) ///
			xlabel(1(1)32) xlabel(, labsize(small)) ylabel(0(350000)1800000, labsize(small))
	
			graph export "$user/$analysis/Results/graphs/raw_hyper_util.pdf", replace
			
* Rates
foreach x in  cs_rate diab_qual hyper_qual {

			 use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear
			collapse (mean)  `x' , by(rmonth)

			twoway (line `x' rmonth, sort ),  ///
			xline(28, lpattern(dash) lcolor(gray)) ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("`x'", size(small)) ///
			xlabel(1(1)32) xlabel(, labsize(small)) ylabel(20(20)80)

			graph export "$user/$analysis/Results/graphs/raw_`x'.pdf", replace
		}
		
		
******************************************************************************** 			
* WITH TRENDS			
* fp_util
			 use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear
			 drop if rmonth>15
			 xtset deleg rmonth
			 xtgee fp_util rmonth , family(gaussian) ///
				link(identity) corr(exchangeable) vce(robust)	

			u "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear
			rename fp_util fp_util_real
			predict fp_util

			collapse (sum) fp_util_real fp_util , by(rmonth)

			twoway (scatter fp_util_real rmonth, msize(vsmall)  sort) ///
			(line fp_util rmonth ,lpattern(dash)) ///
			(lfit fp_util rmonth if rmonth<16, lcolor(cranberry)) ///
			(lfit fp_util_real rmonth if rmonth>=16 & rmonth<=24 , lcolor(green)) ///
			(lfit fp_util_real rmonth if rmonth>=25 & rmonth<=32 , lcolor(blue)),  ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xline(24, lpattern(dash) lcolor(gray)) ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Contraceptive users", size(small)) ///
			xlabel(1(1)32) xlabel(, labsize(small)) ylabel(0(10000)70000, labsize(small))

			graph export "$user/$analysis/Results/graphs/fp_util.pdf", replace
* anc_util
			 use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear
			 drop if rmonth>15
			 xtset deleg rmonth
			 xtgee anc_util rmonth, family(gaussian) ///
				link(identity) corr(exchangeable) vce(robust)	

			u "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear
			rename anc_util anc_util_real
			predict anc_util

			collapse (sum) anc_util_real anc_util , by(rmonth)

			twoway (scatter anc_util_real rmonth, msize(vsmall)) (line anc_util rmonth,  lpattern(dash)) ///
			(lfit anc_util rmonth if rmonth<16, lcolor(cranberry)) ///
			(lfit anc_util_real rmonth if rmonth>=16 & rmonth<=24 , lcolor(green))  ///
			(lfit anc_util_real rmonth if rmonth>=25 & rmonth<=32 , lcolor(blue)), ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xline(24, lpattern(dash) lcolor(gray)) ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Antenatal care visits", size(small)) ///
			xlabel(1(1)32, labsize(small))  ylabel(0(75000)375000, labsize(small))

			graph export "$user/$analysis/Results/graphs/anc_util.pdf", replace
* totaldel
			 use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear
			 drop if rmonth>15
			 xtset deleg rmonth
			 xtgee totaldel rmonth, family(gaussian) ///
				link(identity) corr(exchangeable) vce(robust)	

			u "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear
			rename totaldel totaldel_real
			predict totaldel

			collapse (sum) totaldel_real totaldel , by(rmonth)

			twoway (scatter totaldel_real rmonth, msize(vsmall)) (line totaldel rmonth,  lpattern(dash)) ///
			(lfit totaldel rmonth if rmonth<16, lcolor(cranberry)) ///
			(lfit totaldel_real rmonth if rmonth>=16 & rmonth<=24 , lcolor(green))  ///
			(lfit totaldel_real rmonth if rmonth>=25 & rmonth<=32 , lcolor(blue)), ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xline(24, lpattern(dash) lcolor(gray)) ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Deliveries", size(small)) ///
			xlabel(1(1)32) xlabel(, labsize(vsmall)) ylabel(0(5000)45000, labsize(vsmall))

			graph export "$user/$analysis/Results/graphs/totaldel.pdf", replace
* sc_util
			 use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear
			 drop if rmonth>15
			 xtset deleg rmonth
			 xtgee sc_util rmonth , family(gaussian) ///
				link(identity) corr(exchangeable) vce(robust)	

			u "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear
			rename sc_util sc_util_real
			predict sc_util

			collapse (sum) sc_util_real sc_util , by(rmonth)

			twoway (scatter sc_util_real rmonth, msize(vsmall)) (line sc_util rmonth,  lpattern(dash)) ///
			(lfit sc_util rmonth if rmonth<16, lcolor(cranberry)) ///
			(lfit sc_util_real rmonth if rmonth>=16 & rmonth<=24 , lcolor(green))  ///
			(lfit sc_util_real rmonth if rmonth>=25 & rmonth<=32 , lcolor(blue)), ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xline(24, lpattern(dash) lcolor(gray)) ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Sick child visits", size(small)) ///
			xlabel(1(1)32, labsize(vsmall)) ylabel(0(5000)20000, labsize(vsmall))

			graph export "$user/$analysis/Results/graphs/sc_util.pdf", replace	

* vax_util
			 use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear
			 drop if rmonth>15
			 xtset deleg rmonth
			 xtgee vax_util rmonth, family(gaussian) ///
				link(identity) corr(exchangeable) vce(robust)	

			u "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear
			rename vax_util vax_util_real
			predict vax_util

			collapse (sum) vax_util_real vax_util , by(rmonth)

			twoway (scatter vax_util_real rmonth, msize(vsmall)) (line vax_util rmonth,  lpattern(dash)) ///
			(lfit vax_util rmonth if rmonth<16, lcolor(cranberry)) ///
			(lfit vax_util_real rmonth if rmonth>=16 & rmonth<=24 , lcolor(green))  ///
			(lfit vax_util_real rmonth if rmonth>=25 & rmonth<=32 , lcolor(blue)), ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xline(24, lpattern(dash) lcolor(gray)) ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Vaccinations", size(small)) ///
			xlabel(1(1)32, labsize(vsmall)) ylabel(10000(20000)130000, labsize(vsmall))

			graph export "$user/$analysis/Results/graphs/vax_util.pdf", replace	
			
* cerv_util 

			use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear
			 drop if rmonth>15
			 xtset deleg rmonth
			 xtgee cerv_util rmonth, family(gaussian) ///
				link(identity) corr(exchangeable) vce(robust)	

			u "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear
			rename cerv_util cerv_util_real
			predict cerv_util

			collapse (sum) cerv_util_real cerv_util , by(rmonth)

			twoway (scatter cerv_util_real rmonth, msize(vsmall)) (line cerv_util rmonth,  lpattern(dash)) ///
			(lfit cerv_util rmonth if rmonth<16, lcolor(cranberry)) ///
			(lfit cerv_util_real rmonth if rmonth>=16 & rmonth<=24 , lcolor(green))  ///
			(lfit cerv_util_real rmonth if rmonth>=25 & rmonth<=32 , lcolor(blue)), ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xline(24, lpattern(dash) lcolor(gray)) ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Cervical cancer screening", size(small)) ///
			xlabel(1(1)32, labsize(vsmall)) ylabel(0(50000)300000, labsize(vsmall))

			graph export "$user/$analysis/Results/graphs/cerv_util.pdf", replace	
			
* breast_util 
			use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear
			 drop if rmonth>15
			 xtset deleg rmonth
			 xtgee breast_util rmonth, family(gaussian) ///
				link(identity) corr(exchangeable) vce(robust)	

			u "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear
			rename breast_util breast_util_real
			predict breast_util

			collapse (sum) breast_util_real breast_util , by(rmonth)

			twoway (scatter breast_util_real rmonth, msize(vsmall)) ///
			(line breast_util rmonth,  lpattern(dash)) ///
			(lfit breast_util rmonth if rmonth<16, lcolor(cranberry)) ///
			(lfit breast_util_real rmonth if rmonth>=16 & rmonth<=24 , lcolor(green))  ///
			(lfit breast_util_real rmonth if rmonth>=25 & rmonth<=32 , lcolor(blue)), ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xline(24, lpattern(dash) lcolor(gray)) ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Breast cancer screening", size(small)) ///
			xlabel(1(1)32, labsize(vsmall)) ylabel(0(20000)120000, labsize(vsmall))

			graph export "$user/$analysis/Results/graphs/breast_util.pdf", replace	

*  diab_util  
			use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear
			 drop if rmonth>15
			 xtset deleg rmonth
			 xtgee diab_util rmonth, family(gaussian) ///
				link(identity) corr(exchangeable) vce(robust)	

			u "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear
			rename diab_util diab_util_real
			predict diab_util

			collapse (sum) diab_util_real diab_util , by(rmonth)

			twoway (scatter diab_util_real rmonth, msize(vsmall)) ///
			(line diab_util rmonth,  lpattern(dash)) ///
			(lfit diab_util rmonth if rmonth<16, lcolor(cranberry)) ///
			(lfit diab_util_real rmonth if rmonth>=16 & rmonth<=24 , lcolor(green)) ///
			(lfit diab_util_real rmonth if rmonth>=25 & rmonth<=32 , lcolor(blue)), ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xline(24, lpattern(dash) lcolor(gray)) ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Diabetes visits", size(small)) ///
			xlabel(1(1)32, labsize(vsmall)) ylabel(0(250000)1500000, labsize(vsmall))

			graph export "$user/$analysis/Results/graphs/diab_util.pdf", replace	
			
* hyper_util
			use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear
			 drop if rmonth>15
			 xtset deleg rmonth
			 xtgee hyper_util rmonth, family(gaussian) ///
				link(identity) corr(exchangeable) vce(robust)	

			u "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear
			rename hyper_util hyper_util_real
			predict hyper_util

			collapse (sum) hyper_util_real hyper_util , by(rmonth)

			twoway (scatter hyper_util_real rmonth, msize(vsmall)) ///
			(line hyper_util rmonth,  lpattern(dash)) ///
			(lfit hyper_util rmonth if rmonth<16, lcolor(cranberry)) ///
			(lfit hyper_util_real rmonth if rmonth>=16 & rmonth<=24 , lcolor(green)) ///
			(lfit hyper_util_real rmonth if rmonth>=25 & rmonth<=32 , lcolor(blue)), ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xline(24, lpattern(dash) lcolor(gray)) ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("Hypertension visits", size(small)) ///
			xlabel(1(1)32, labsize(vsmall)) ylabel(0(350000)1800000, labsize(vsmall))

			graph export "$user/$analysis/Results/graphs/hyper_util.pdf", replace	
			
* Rates
foreach x in  cs_rate  diab_qual hyper_qual {

			 use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear
			drop if rmonth>15
			xtset deleg rmonth
			xtgee `x' rmonth, family(gaussian) ///
				link(identity) corr(exchangeable) vce(robust)	

			u "$user/$data/Data for analysis/IMSS_service_delivery_updated2021.dta", clear
			rename `x' `x'_real
			predict `x'

			collapse (mean) `x'_real `x' , by(rmonth)

			twoway (scatter `x'_real rmonth, msize(vsmall)) (line `x' rmonth, lpattern(dash)) ///
			(lfit `x' rmonth if rmonth<16, lcolor(cranberry)) ///
			(lfit `x'_real rmonth if rmonth>=16 & rmonth<=24 , lcolor(green))  ///
			(lfit `x'_real rmonth if rmonth>=25 & rmonth<=32 , lcolor(blue)), ///
			xline(24, lpattern(dash) lcolor(gray)) ///
			ylabel(, labsize(small)) xline(15, lpattern(dash) lcolor(black)) ///
			xtitle("Months since January 2019", size(small)) legend(off) ///
			graphregion(color(white)) title("`x'", size(small)) ///
			xlabel(1(1)32) xlabel(, labsize(small)) ylabel(20(20)80)

			graph export "$user/$analysis/Results/graphs/`x'.pdf", replace
		}
