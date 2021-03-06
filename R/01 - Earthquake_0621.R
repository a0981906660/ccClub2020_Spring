library(margins)
#Reg Output
library(sjPlot)
#library(sjmisc)
#library(sjlabelled)
library(webshot)

#讀檔
setwd("/Users/Andy 1/Google 雲端硬碟 (r08323004@g.ntu.edu.tw)/0 Semesters/108-2/二 ccClub/0 Github Repo/ccClub2020_Spring/R")

#Read files
earthquake = read.csv("raw/combined_forR_0623.csv")

# Descriptive Statistics
boxplot(earthquake$Distance)
quantile(na.omit(earthquake$Distance), probs = c(.5,.6,.7,.8,.9,.95,.99,1))

# 距離超過244就不要
earthquake = earthquake[earthquake$Distance<=244,]
boxplot(earthquake$Distance)
hist(earthquake$Distance)


# Regression

# Part 1: Probit
## We aim to know the probability of 搶到地震爆文
reg_formula = as.formula("YouWin ~ Distance + ShakingExtent + InCenter+ IsPeak + OffPeak + PopDensity + download_4G + upload_4G")
#LPM
reg1 = lm(reg_formula, data = earthquake)
summary(reg1)

#Probit
reg2 = glm(reg_formula, family = binomial(link = "probit"), data = earthquake)
summary(reg2)
#APE for distance: (1/N)*sum(beta_j * Phi(X*beta))
mean(reg2$coefficients[2]*pnorm(predict(reg2)))
margins(reg2)

#Logit
reg3 = glm(reg_formula, family = binomial(link = "logit"), data = earthquake)
summary(reg3)
margins(reg3)

#reg out
x = tab_model(reg1, reg2, reg3, 
              show.p = T, show.se = T,robust = T, digits = 4,
              title = "Binary Response", file = "output/01/reg.html")
cat(x[["page.style"]], x[["page.complete"]], file = "output/01/reg.html")
reg_out_png = "output/01/reg.png"
webshot("output/01/reg.html", reg_out_png) #save as png
#############################################
# Part 2: Time Difference
## We aim to know the time difference of 地震爆文及失敗地震文
reg_formula = as.formula("TimeDifference ~ Distance + ShakingExtent + InCenter+ IsPeak + OffPeak + PopDensity + download_4G + upload_4G-1")

#LPM
reg1 = lm(reg_formula, data = earthquake)
summary(reg1)

#Poisson
reg2 = glm(reg_formula, family = poisson, data = earthquake)
summary(reg2)
margins(reg2)

#reg out
x = tab_model(reg1, reg2, 
              show.p = T, show.se = T,robust = T, digits = 4,
              title = "Time Difference", file = "output/02/reg.html")
cat(x[["page.style"]], x[["page.complete"]], file = "output/02/reg.html")
reg_out_png = "output/02/reg.png"
webshot("output/02/reg.html", reg_out_png) #save as png

#############################################
# Part 3: Time Difference between 爆文 & 其他地震文
## We aim to know the time difference of 地震爆文及失敗地震文
reg_formula = as.formula("TimeDifference_Bao ~ Distance + ShakingExtent + InCenter+ IsPeak + OffPeak + PopDensity + download_4G + upload_4G-1")
#LPM
reg1 = lm(reg_formula, data = earthquake)
summary(reg1)

#Poisson
reg2 = glm(reg_formula, family = poisson, data = earthquake)
summary(reg2)
margins(reg2)

#reg out
x = tab_model(reg1, reg2, 
              show.p = T, show.se = T,robust = T, digits = 4,
              title = "Time Difference after the first 爆文", file = "output/03/reg.html")
cat(x[["page.style"]], x[["page.complete"]], file = "output/03/reg.html")
reg_out_png = "output/03/reg.png"
webshot("output/03/reg.html", reg_out_png) #save as png
