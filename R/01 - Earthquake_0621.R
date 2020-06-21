#讀檔
setwd("/Users/Andy 1/Google 雲端硬碟 (r08323004@g.ntu.edu.tw)/0 Semesters/108-2/二 ccClub/0 Github Repo/ccClub2020_Spring/R")

#Read files
earthquake = read.csv("raw/combined_forR_0621.csv")

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
reg_formula = as.formula("YouWin ~ Distance + ShakingExtent + InCenter+ IsPeak + OffPeak + PopDensity")
#LPM
reg1 = lm(reg_formula, data = earthquake)
summary(reg1)

#Probit
reg2 = glm(reg_formula, family = binomial(link = "probit"), data = earthquake)
summary(reg2)

#Logit
reg3 = glm(reg_formula, family = binomial(link = "logit"), data = earthquake)
summary(reg3)


#############################################
# Part 2: Time Difference
## We aim to know the time difference of 地震爆文及失敗地震文
reg_formula = as.formula("TimeDifference ~ Distance + ShakingExtent + InCenter+ IsPeak + OffPeak + PopDensity")
#LPM
reg1 = lm(reg_formula, data = earthquake)
summary(reg1)

#Poisson
reg2 = glm(reg_formula, family = poisson, data = earthquake)
summary(reg2)



