* Main do file

* Disruption in essential health services at the Mexican Institute for Social Security
* Created by: Catherine Arsenault, December 2020
* Last edited July, 2021

global user "/Users/acatherine/Dropbox (Harvard University)"
global data "/HMIS Data for Health System Performance Covid (Mexico)"
global analysis "SPH-Kruk Team/Quest Network/Core Research/HS performance Covid (internal)/Country-specific papers/Mexico IMSS"
global dofiles "/Users/acatherine/Documents/GitHub/Disruptions-IMSS-covid"

* Raw data used for this analysis was obtained from the IMSS Epidemiologic and Health Services Research Unit
* The raw dataset was compiled for the HS performance during Covid project (created in the "format" do file)
* See GitHub repo: https://github.com/catherine-arsenault/HS-performance-during-covid-do-files

* Variable creation
do "$user/$dofiles/creation_IMSS_service delivery.do"


