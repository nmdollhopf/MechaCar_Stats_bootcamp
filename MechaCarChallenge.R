library(dplyr)
library(tidyverse)

###############################################
# Deliverable 1
###############################################
mechacars <- read.csv("MechaCar_mpg.csv")

# use the period notation for "all [other] columns"
themodel <- lm(mpg ~ ., data=mechacars)
lmfit <- summary(lm(mpg ~ ., data=mechacars))
lmfit
# mpg = 6.3*length + 0.001*weight + 0.069*spoiler + 3.5*clearance - 3.4*AWD - 100, p=5.4e-11, r^2=0.71
# p values: 2.6e-12       0.08           0.3              5.2e-8      0.2
# residual error: 8.8
sqrt(mean(lmfit$residuals^2))
# rms: 8.2

summary(mechacars$mpg) #mean = 45.13
sd(mechacars$mpg) #std dev = 15.57

themodel$fitted.values

#ggplot(data = data.frame(x = df1$x, y = df2$y), aes(x = x, y = y))
# 1:1 match of the data to its error
ggplot(data = data.frame(x=mechacars$mpg, y=(themodel$residuals)), aes(x=x, y=y)) + geom_point() +
  labs(title="Errors on respective datapoint", x="MPG datapoint", y="Residual from lm fit") # + geom_smooth(method=lm)
#best fit line of datapoint to its error
summary(lm(y ~ x, data = data.frame(x=mechacars$mpg, y=(themodel$residuals))))

# boxplot of all errors
ggplot(data = data.frame(x=mechacars$mpg, y=(themodel$residuals)), aes(y=y)) + geom_boxplot()
# density of all errors
ggplot(data = data.frame(x=mechacars$mpg, y=(themodel$residuals)), aes(x=y)) + geom_density()


##########
# Deliverable 1 -- IGNORABLE
# Keep scrolling for deliverable 2
##########
?ggplot
ggplot(data=mechacars, aes(x=mpg)) + geom_density()
ggplot(data=mechacars, aes(y=mpg, x=vehicle_length)) + geom_point()
ggplot(data=mechacars, aes(y=mpg, x=vehicle_weight)) + geom_point()
ggplot(data=mechacars, aes(y=mpg, x=spoiler_angle)) + geom_point()
ggplot(data=mechacars, aes(y=mpg, x=ground_clearance)) + geom_point()
ggplot(data=mechacars, aes(y=mpg, x=factor(AWD))) + geom_point()

summary(lm(mpg ~ vehicle_length, data=mechacars)) #y=0.4.7x - 25, p=0.0000026, r^2=0.4, res err=12.5
summary(lm(mpg ~ vehicle_weight, data=mechacars)) #y=0.00077x + 40, p=0.53, r^2=0.008, res err=15.7
summary(lm(mpg ~ spoiler_angle, data=mechacars)) #y=-0.02x + 46, p=0.88, r^2=4e-5, res err=15.7
summary(lm(mpg ~ ground_clearance, data=mechacars)) #y=2.0x + 19, p=0.02, r^2=0.1, res err=14.9
summary(lm(mpg ~ AWD, data=mechacars)) #y=-4.3x + 47, p=0.33, r^2=0.02, res err=15.6

# best options
summary(lm(mpg ~ vehicle_length + ground_clearance, data=mechacars))
# mpg = 6.1*length + 3.6*clearance -91.6, p=3.6e-12, r^2=0.674
# residual error: 9.1
sqrt(mean(summary(lm(mpg ~ vehicle_length + ground_clearance, data=mechacars))$residuals^2))
#rms: 8.8

summary(lm(mpg ~ vehicle_length + ground_clearance + AWD, data=mechacars))
# mpg = 6.1*length + 3.5*clearance - 3.8*AWD - 89, p=9.9e-12, r^2=0.69
# residual error: 9.0
sqrt(mean(summary(lm(mpg ~ vehicle_length + ground_clearance + AWD, data=mechacars))$residuals^2))
#rms: 8.6

summary(lm(mpg ~ vehicle_length + ground_clearance + AWD + vehicle_weight, data=mechacars))
# mpg = 6.2*length + 3.4*clearance - 3.7*AWD + 0.0012*weight, p=1.6e-11, r^2=0.71
# residual error: 8.8
sqrt(mean(summary(lm(mpg ~ vehicle_length + ground_clearance + AWD + vehicle_weight, data=mechacars))$residuals^2))
#rms: 8.33


###############################################
# Deliverable 2
###############################################
suspCoils <- read.csv("Suspension_Coil.csv")

total_summary <- summarize(suspCoils, mean=mean(PSI), median=median(PSI), variance=var(PSI), StDev=sd(PSI))
total_summary # Summary statistics of entire dataset

lot_summary <- suspCoils %>% group_by(Manufacturing_Lot) %>% summarize(mean=mean(PSI), median=median(PSI), variance=var(PSI), StDev=sd(PSI))
lot_summary # Summary statistics for each production lot

###############################################
# Deliverable 3
###############################################

?t.test
# NULL hypothesis: the mean is 1500 and the coils are in compliance
t.test(suspCoils$PSI, mu=1500)
# a 6% chance the null hypothesis is correct. to reject or not reject?


# subset on Lot1
t.test(PSI ~ 1, data=suspCoils, mu=1500, subset=(Manufacturing_Lot == "Lot1"))
# probability is 100% that the null hypothesis is correct. Lot1 is in compliance

# subset on Lot2
t.test(PSI ~ 1, data=suspCoils, mu=1500, subset=(Manufacturing_Lot == "Lot2"))
# probability is 61% that null hypothesis is correct and Lot2 is in compliance

# subset on Lot3
t.test(PSI ~ 1, data=suspCoils, mu=1500, subset=(Manufacturing_Lot == "Lot3"))
# only 4% chance null hypothesis is correct. thus, we reject it and say Lot3 is NOT in compliance

