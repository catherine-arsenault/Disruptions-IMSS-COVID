*HL user paths
global user "/Users/leslieh/Dropbox/Work/Harvard/mexico/Covid"
global data ""

*Required programs
ssc install variog 
ssc install qic
ssc install metan 

*Data creation
run "$user/Do files/crIMSS_Covid2021.do"
*Inputs: Concentrado de indicadoresIMSS_Nov 2021.xlsx, RECONVERSION OCUPACION COVID HISTORICO.xlsm, Población Adscrita_Dic2021.xlsx, IMSS_service_delivery_raw.dta, 
*Outputs: IMSS_service_delivery_2021.dta, IMSS_beds.dta, IMSSpop2021.dta, IMSS_service_delivery_updated.dta, IMSS_service_delivery_updated2021.dta

run "$user/Do files/crIMSS_Vaccines 20-21.do"
*Inputs: Vacunas_Aplicadas_Dosis_Deleg_Harvard_202001_202012_Preliminar.xlsx, Vacunas_Aplicadas_Dosis_Delegacion_202101_202112_Preliminar.xlsx
*Outputs: Vaccines_20-21.dta, IMSS_service_delivery_updated2021_nat_v2.dta, IMSS_service_delivery_updated2021_v2.dta

*Data analysis - using updated2021_v2.dta
*Correlation structure
do "$user/Do files/anIMSS_Covid2021_01.do"

*Main analysis
do "$user/Do files/anIMSS_Covid2021_02.do"
