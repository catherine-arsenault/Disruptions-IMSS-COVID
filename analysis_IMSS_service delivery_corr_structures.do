* Service delivery during Covid 19 at IMSS
* Created by: Catherine Arsenault, Dec 2020

global user "/Users/acatherine/Dropbox (Harvard University)"
global data "/HMIS Data for Health System Performance Covid (Mexico)"
global analysis "/Quest Center/Active projects/HS performance Covid (internal)/Country-specific papers/Mexico"
* This dataset was created by the HS performance during Covid project
* See GitHub repo: https://github.com/catherine-arsenault/HS-performance-during-covid-do-files

use "$user/$data/Data for analysis/IMSS_service_delivery.dta", clear

global maternal fp_util anc_util totaldel cs_rate
global child sc_util vax_util 
global chronic cerv_util breast_util diab_util diab_qual hyper_util hyper_qual 

global all $maternal $child $chronic

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

* FP 
qic fp_util postCovid rmonth timeafter spring-winter , i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(ar1) robust	

qic fp_util postCovid rmonth timeafter spring-winter , i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(exchangeable) robust	

qic fp_util postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(unstructured) robust	
  

* ANC 
qic anc_util postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(ar1) robust	

qic anc_util postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(exchangeable) robust	

qic anc_util postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(unstructured) robust	
  

* Deliveries
qic totaldel postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(ar1) robust	

qic totaldel postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(exchangeable) robust	

qic totaldel postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(unstructured) robust	
  

* CS rate
qic cs_rate postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(ar1) robust	

qic cs_rate postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(exchangeable) robust	

qic cs_rate postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(unstructured) robust	
 

* Sick child 
qic sc_util postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(ar1) robust	

qic sc_util  postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(exchangeable) robust	

qic sc_util  postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(unstructured) robust	
 

* Vaccination 
qic vax_util  postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(ar1) robust	

qic vax_util   postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(exchangeable) robust	

qic vax_util   postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(unstructured) robust	


* Cervical cancer screening
qic cerv_util  postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(ar1) robust	

qic cerv_util  postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(exchangeable) robust	

qic cerv_util  postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(unstructured) robust	


* Breast cancer screening
qic  breast_util postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(ar1) robust	

qic  breast_util postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(exchangeable) robust	

qic  breast_util postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(unstructured) robust	


* Diabetes visits
qic  diab_util postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(ar1) robust	

qic   diab_util postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(exchangeable) robust	

qic   diab_util postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(unstructured) robust	


*Diabetes control
qic   diab_qual postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(ar1) robust	

qic    diab_qual postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(exchangeable) robust	

qic    diab_qual postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(unstructured) robust	
 

*Hypertension visits
qic  hyper_util postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(ar1) robust	

qic     hyper_util postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(exchangeable) robust	

qic     hyper_util postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(unstructured) robust	
 

*Hypertension visits
qic  hyper_qual postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(ar1) robust	

qic  hyper_qual postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(exchangeable) robust	

qic  hyper_qual postCovid rmonth timeafter spring-winter, i(deleg) t(rmonth) family(gaussian) ///
	link(identity) corr(unstructured) robust	
 
