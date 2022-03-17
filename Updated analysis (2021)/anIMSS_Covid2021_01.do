* Service delivery during Covid 19 at IMSS
* Created by: Catherine Arsenault, Dec 2020
* Updated for recovery analysis by Hannah Leslie, March 2022

*Data and globals
use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021_v2.dta", clear

global maternal fp_util anc_util totaldel cs_rate
global child sc_util vax_util 
global chronic cerv_util breast_util diab_util  hyper_util  
global serv $maternal $child $chronic

global qual diab_qual hyper_qual
global all $serv $qual

global covars postPolicy timeafter_pol timeafter_cov ln_beds spring summer fall 
global covars_lag postPolicy_lag timeafter_pol_lag timeafter_cov_lag ln_beds_lag spring summer fall 

********************************************************************************
* INVESTIGATING CORRELATION STRUCTURES TO CHOOSE WORKING CORR FOR GEE MODELS
********************************************************************************
* Variograms for each of the 13 outcomes
foreach x of global all {
	variog `x'
	graph export "$user/$analysis/Results/variograms/variog`x'.pdf", replace
}
* Choosing the correlation structure for GEE: Compare AR, exchangeable and unstructured
* The correlation structure that minimises the QIC should be used
* See: https://journals.sagepub.com/doi/pdf/10.1177/1536867X0700700205


matrix input qic_mat = (., ., ., ., ., ., ., ., ., ., ., ., \ ., ., ., ., ., ., ., ., ., ., ., ., \ ., ., ., ., ., ., ., ., ., ., ., .,) 

local i = 1
foreach var of varlist fp_util anc_util totaldel {
	cap noisily qic `var' $covars, i(deleg) t(rmonth) family(poisson) link(log) corr(ar1) exposure(women1549) robust
	if _rc == 0 {
		matrix qic_mat[1,`i'] = r(qic)
		}
	cap noisily qic `var' $covars, i(deleg) t(rmonth) family(poisson) link(log) corr(exchangeable) exposure(women1549) robust
	if _rc == 0 {
		matrix qic_mat[2,`i'] = r(qic)
		}
	cap noisily qic `var' $covars, i(deleg) t(rmonth) family(poisson) link(log) corr(unstructured) exposure(women1549) robust
	if _rc == 0 {
		matrix qic_mat[3,`i'] = r(qic)
		}
	local i = `i' + 1
}

cap noisily qic sc_util $covars, i(deleg) t(rmonth) family(poisson) link(log) corr(ar1) exposure(u5) robust
	if _rc == 0 {
		matrix qic_mat[1,4] = r(qic)
		}

cap noisily qic sc_util $covars, i(deleg) t(rmonth) family(poisson) link(log) corr(exc) exposure(u5) robust
	if _rc == 0 {
		matrix qic_mat[2,4] = r(qic)
		}

cap noisily qic sc_util $covars, i(deleg) t(rmonth) family(poisson) link(log) corr(uns) exposure(u5) robust
	if _rc == 0 {
		matrix qic_mat[3,4] = r(qic)
		}
	
cap noisily qic vax_util $covars, i(deleg) t(rmonth) family(poisson) link(log) corr(ar1) exposure(u10) robust
	if _rc == 0 {
		matrix qic_mat[1,5] = r(qic)
		}

cap noisily qic vax_util $covars, i(deleg) t(rmonth) family(poisson) link(log) corr(exc) exposure(u10) robust
	if _rc == 0 {
		matrix qic_mat[2,5] = r(qic)
		}

cap noisily qic vax_util $covars, i(deleg) t(rmonth) family(poisson) link(log) corr(uns) exposure(u10) robust
	if _rc == 0 {
		matrix qic_mat[3,5] = r(qic)
		}	

cap noisily qic cerv_util $covars, i(deleg) t(rmonth) family(poisson) link(log) corr(ar1) exposure(women2564) robust
	if _rc == 0 {
		matrix qic_mat[1,6] = r(qic)
		}

cap noisily qic cerv_util $covars, i(deleg) t(rmonth) family(poisson) link(log) corr(exc) exposure(women2564) robust
	if _rc == 0 {
		matrix qic_mat[2,6] = r(qic)
		}

cap noisily qic cerv_util $covars, i(deleg) t(rmonth) family(poisson) link(log) corr(uns) exposure(women2564) robust
	if _rc == 0 {
		matrix qic_mat[3,6] = r(qic)
		}	

cap noisily qic breast_util $covars, i(deleg) t(rmonth) family(poisson) link(log) corr(ar1) exposure(women5069) robust
	if _rc == 0 {
		matrix qic_mat[1,7] = r(qic)
		}

cap noisily qic breast_util $covars, i(deleg) t(rmonth) family(poisson) link(log) corr(exc) exposure(women5069) robust
	if _rc == 0 {
		matrix qic_mat[2,7] = r(qic)
		}

cap noisily qic breast_util $covars, i(deleg) t(rmonth) family(poisson) link(log) corr(uns) exposure(women5069) robust
	if _rc == 0 {
		matrix qic_mat[3,7] = r(qic)
		}	

local i = 8		
		
foreach var of varlist diab_util hyper_util {
		
cap noisily qic `var' $covars, i(deleg) t(rmonth) family(poisson) link(log) corr(ar1) exposure(all20plus) robust
	if _rc == 0 {
		matrix qic_mat[1,`i'] = r(qic)
		}

cap noisily qic `var' $covars, i(deleg) t(rmonth) family(poisson) link(log) corr(exc) exposure(all20plus) robust
	if _rc == 0 {
		matrix qic_mat[2,`i'] = r(qic)
		}

cap noisily qic `var' $covars, i(deleg) t(rmonth) family(poisson) link(log) corr(uns) exposure(all20plus) robust
	if _rc == 0 {
		matrix qic_mat[3,`i'] = r(qic)
		}	

local i = `i' + 1	
}	

cap noisily qic cs_util $covars, i(deleg) t(rmonth) family(poisson) link(log) corr(ar1) exposure(totaldel) robust
	if _rc == 0 {
		matrix qic_mat[1,10] = r(qic)
		}

cap noisily qic cs_util $covars, i(deleg) t(rmonth) family(poisson) link(log) corr(exc) exposure(totaldel) robust
	if _rc == 0 {
		matrix qic_mat[2,10] = r(qic)
		}

cap noisily qic cs_util $covars, i(deleg) t(rmonth) family(poisson) link(log) corr(uns) exposure(totaldel) robust
	if _rc == 0 {
		matrix qic_mat[3,10] = r(qic)
		}				

cap noisily qic diab_qual_num $covars_lag, i(deleg) t(rmonth) family(poisson) link(log) corr(ar1) exposure(diab_util) robust
	if _rc == 0 {
		matrix qic_mat[1,11] = r(qic)
		}

cap noisily qic diab_qual_num $covars_lag, i(deleg) t(rmonth) family(poisson) link(log) corr(exc) exposure(diab_util) robust
	if _rc == 0 {
		matrix qic_mat[2,11] = r(qic)
		}

cap noisily qic diab_qual_num $covars_lag, i(deleg) t(rmonth) family(poisson) link(log) corr(uns) exposure(diab_util) robust
	if _rc == 0 {
		matrix qic_mat[3,11] = r(qic)
		}	

cap noisily qic hyper_qual_num $covars_lag, i(deleg) t(rmonth) family(poisson) link(log) corr(ar1) exposure(hyper_util) robust
	if _rc == 0 {
		matrix qic_mat[1,12] = r(qic)
		}

cap noisily qic hyper_qual_num $covars_lag, i(deleg) t(rmonth) family(poisson) link(log) corr(exc) exposure(hyper_util) robust
	if _rc == 0 {
		matrix qic_mat[2,12] = r(qic)
		}

cap noisily qic hyper_qual_num $covars_lag, i(deleg) t(rmonth) family(poisson) link(log) corr(uns) exposure(hyper_util) robust
	if _rc == 0 {
		matrix qic_mat[3,12] = r(qic)
		}	
		
matrix colnames qic_mat = fp_util anc_util totaldel sc_util vax_util cerv_util breast_util diab_util hyper_util cs_util diab_qual_num hyper_qual_num
matrix rownames qic_mat = AR1 Exc Uns
matrix list qic_mat

*Updated with data from Covid to Nov 2021, ln_beds:
*With Poisson model
*AR for sc_util vax_util cerv_util breast_util diab_util  hyper_util 
*Exc for fp_util anc_util totaldel cs_util diab_qual hyper_qual


*Vaccines
use "$user/$data/Data for analysis/IMSS_service_delivery_updated2021_v2.dta", clear
global vax bcg_qual pent_qual measles_qual rota_qual pneum_qual
global vax10  pent_qual measles_qual rota_qual pneum_qual
matrix input qic_mat_v = (., ., ., ., .,  \ ., ., ., ., .,  \ ., ., ., ., ., ) 

local i = 1
foreach var of varlist bcg_qual {
	cap noisily qic `var' $covars, i(deleg) t(rmonth) family (poisson) link(log) exposure(u1) corr(ar1) robust
	if _rc == 0 {
		matrix qic_mat_v[1,`i'] = r(qic)
		}
	cap noisily qic `var' $covars, i(deleg) t(rmonth) family (poisson) link(log) exposure(u1) corr(exchangeable) robust
	if _rc == 0 {
		matrix qic_mat_v[2,`i'] = r(qic)
		}
	cap noisily qic `var' $covars, i(deleg) t(rmonth) family (poisson) link(log) exposure(u1) corr(unstructured) robust
	if _rc == 0 {
		matrix qic_mat_v[3,`i'] = r(qic)
		}
	local i = `i' + 1
}

local i = 2
foreach var of varlist $vax10 {
	cap noisily qic `var' $covars, i(deleg) t(rmonth) family (poisson) link(log) exposure(u10) corr(ar1) robust
	if _rc == 0 {
		matrix qic_mat_v[1,`i'] = r(qic)
		}
	cap noisily qic `var' $covars, i(deleg) t(rmonth) family (poisson) link(log) exposure(u10) corr(exchangeable) robust
	if _rc == 0 {
		matrix qic_mat_v[2,`i'] = r(qic)
		}
	cap noisily qic `var' $covars, i(deleg) t(rmonth) family (poisson) link(log) exposure(u10) corr(unstructured) robust
	if _rc == 0 {
		matrix qic_mat_v[3,`i'] = r(qic)
		}
	local i = `i' + 1
}

matrix colnames qic_mat_v = $vax
matrix rownames qic_mat_v = AR1 Exc Uns
matrix list qic_mat_v
*AR: BCG, pent, measles, rota, pneum


*Linear models, main outcomes
matrix input qic_mat_lin = (., ., ., ., ., ., ., ., ., ., ., ., \ ., ., ., ., ., ., ., ., ., ., ., ., \ ., ., ., ., ., ., ., ., ., ., ., .,) 

local i = 1
foreach var of varlist $serv {
	cap noisily qic `var' $covars, i(deleg) t(rmonth) family (gaussian) link(identity) corr(ar1) robust
	if _rc == 0 {
		matrix qic_mat_lin[1,`i'] = r(qic)
		}
	cap noisily qic `var' $covars, i(deleg) t(rmonth) family (gaussian) link(identity) corr(exchangeable) robust
	if _rc == 0 {
		matrix qic_mat_lin[2,`i'] = r(qic)
		}
	cap noisily qic `var' $covars, i(deleg) t(rmonth) family (gaussian) link(identity) corr(unstructured) robust
	if _rc == 0 {
		matrix qic_mat_lin[3,`i'] = r(qic)
		}
	local i = `i' + 1
}

local i = 11
foreach var of varlist $qual {
	cap noisily qic `var' $covars_lag, i(deleg) t(rmonth) family (gaussian) link(identity) corr(ar1) robust
	if _rc == 0 {
		matrix qic_mat_lin[1,`i'] = r(qic)
		}
	cap noisily qic `var' $covars_lag, i(deleg) t(rmonth) family (gaussian) link(identity) corr(exchangeable) robust
	if _rc == 0 {
		matrix qic_mat_lin[2,`i'] = r(qic)
		}
	cap noisily qic `var' $covars_lag, i(deleg) t(rmonth) family (gaussian) link(identity) corr(unstructured) robust
	if _rc == 0 {
		matrix qic_mat_lin[3,`i'] = r(qic)
		}
	local i = `i' + 1
}

matrix colnames qic_mat_lin = $serv $qual
matrix rownames qic_mat_lin = AR1 Exc Uns
matrix list qic_mat_lin

*Updated with data from Covid to Nov 2021, ln_beds:
*AR for fp_util anc_util cs_rate vax_util cerv_util breast_util 
*Exc for totaldel  sc_util  diab_util hyper_util diab_qual hyper_qual
