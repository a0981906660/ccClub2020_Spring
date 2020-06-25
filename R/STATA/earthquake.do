/*
	Purpose		 : This do file is for ccClub Project
	Topics		 : PTT Earthquake
	Author		 : Chen Boyie
	Date		 : 2020/06/24
	Last Modified: 2020/06/24
*/


clear all

pwd
cd "/Users/Andy 1/Google 雲端硬碟 (r08323004@g.ntu.edu.tw)/0 Semesters/108-2/二 ccClub/0 Github Repo/ccClub2020_Spring/R/STATA"
import delimited "combined_forSTATA.csv"

//log using "hw9", replace

** Commands
*Define Variables
global X "distance shakingextent incenter ispeak offpeak popdensity download_4g upload_4g"
xtset groupid



// Binary Response
*POLS or LPM
reg youwin $X, cluster(groupid)

*RE
xtreg youwin $X, re cluster(groupid)

*FE //拿掉Ci 原本是那些不隨時間改變的事物（只depends on i, not t）
	//現在的dim是g,i，分別是group 和 individual
	//那些只隨地震而改變，不隨使用者而改變的東西是現在要被FE拿掉的
xtreg youwin $X, fe cluster(groupid)
xtreg youwin distance incenter popdensity download_4g upload_4g, fe cluster(groupid)

*Probit
probit youwin $X, cluster(groupid)
mfx

*Logit
logit youwin $X, cluster(groupid)
mfx


// TimeDifference
*POLS
reg timedifference $X, cluster(groupid) noconstant

*RE
xtreg timedifference $X, re cluster(groupid)

*FE //拿掉Ci 原本是那些不隨時間改變的事物（只depends on i, not t）
	//現在的dim是g,i，分別是group 和 individual
	//那些只隨地震而改變，不隨使用者而改變的東西是現在要被FE拿掉的
xtreg timedifference $X, fe cluster(groupid)
xtreg timedifference distance incenter popdensity download_4g upload_4g, fe cluster(groupid)
*Poisson
poisson timedifference $X, cluster(groupid)
mfx


// TimeDifference between 爆文 & 其他地震文
*POLS
reg timedifference_bao $X, cluster(groupid) noconstant

*RE
xtreg timedifference_bao $X, re cluster(groupid)

*FE //拿掉Ci 原本是那些不隨時間改變的事物（只depends on i, not t）
	//現在的dim是g,i，分別是group 和 individual
	//那些只隨地震而改變，不隨使用者而改變的東西是現在要被FE拿掉的
xtreg timedifference_bao $X, fe cluster(groupid)
xtreg timedifference_bao distance incenter popdensity download_4g upload_4g, fe cluster(groupid)
*Poisson
poisson timedifference_bao $X, cluster(groupid)
mfx



*輸出table
//Binary Response
reg youwin $X, cluster(groupid)
outreg2 using BinaryResponse, replace tex ct(LPM:POLS)

xtreg youwin $X, re cluster(groupid)
outreg2 using BinaryResponse, append tex ct(LPM:RE)

xtreg youwin distance incenter popdensity download_4g upload_4g, fe cluster(groupid)
outreg2 using BinaryResponse, append tex ct(LPM:FE)

probit youwin $X, cluster(groupid)
outreg2 using BinaryResponse, append tex ct(Probit)

logit youwin $X, cluster(groupid)
outreg2 using BinaryResponse, append tex ct(Logit)


//Time Difference
reg timedifference $X, cluster(groupid)
outreg2 using TimeDifference, replace tex ct(POLS)

xtreg timedifference $X, re cluster(groupid)
outreg2 using TimeDifference, append tex ct(RE)

xtreg timedifference distance incenter popdensity download_4g upload_4g, fe cluster(groupid)
outreg2 using TimeDifference, append tex ct(FE)

poisson timedifference $X, cluster(groupid)
outreg2 using TimeDifference, append tex ct(Poisson)

//Time Difference_Bao
reg timedifference_bao $X, cluster(groupid)
outreg2 using TimeDifference_bao, replace tex ct(POLS)

xtreg timedifference_bao $X, re cluster(groupid)
outreg2 using TimeDifference_bao, append tex ct(RE)

xtreg timedifference_bao distance incenter popdensity download_4g upload_4g, fe cluster(groupid)
outreg2 using TimeDifference_bao, append tex ct(FE)

poisson timedifference_bao $X, cluster(groupid)
outreg2 using TimeDifference_bao, append tex ct(Poisson)
