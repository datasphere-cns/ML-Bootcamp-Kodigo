library(ggplot2)
library(plyr)

#Read data
ds<-read.table("C:/virtual_environment/Mod01/R-Lang/hr_data.csv",dec=".",sep=",",header=TRUE,colClasses=c("numeric","numeric","numeric","numeric","numeric","factor","factor","factor","factor","factor"))
attach(ds)

#Explore the distribution of the target variable
table(ds$left)
prop.table(table(ds$left))

#Create the set of people who left (1) and stayed (0)
left <- ds[ds$left == "yes",]
stay <- ds[ds$left == "no",]

*****
Numeric attributes
*****
---satisfaction_level---
hist(ds$satisfaction_level,main=NULL,xlab="Satisfaction level",ylab="Density",col=gray(seq(0.9,0.4,length=10)),cex.axis=1.2,cex.lab=1.5,font.lab=1,freq=FALSE,xlim=c(0,1),ylim=c(0,2))
hist(ds$satisfaction_level,main=NULL,xlab="Satisfaction level",ylab="Frequency",col=gray(seq(0.9,0.4,length=10)),cex.axis=1.2,cex.lab=1.5,font.lab=1,freq=TRUE,xlim=c(0,1),ylim=c(0,1500))
boxplot(satisfaction_level~left,ds,horizontal=TRUE,xlab="Satisfaction level",ylab="Left",cex.lab=1.5,font.lab=1)
boxplot.stats(left$satisfaction_level)
boxplot.stats(stay$satisfaction_level)

---last_evaluation---
hist(ds$last_evaluation,main=NULL,xlab="Last evaluation",ylab="Density",col=gray(seq(0.9,0.4,length=10)),cex.axis=1.2,cex.lab=1.5,font.lab=1,freq=FALSE,xlim=c(0,1),ylim=c(0,3))
hist(ds$last_evaluation,main=NULL,xlab="Last evaluation",ylab="Frequency",col=gray(seq(0.9,0.4,length=10)),cex.axis=1.2,cex.lab=1.5,font.lab=1,freq=TRUE,xlim=c(0,1),ylim=c(0,2000))
boxplot(last_evaluation~left,ds,horizontal=TRUE,xlab="Last evaluation",ylab="Left",cex.lab=1.5,font.lab=1)
boxplot.stats(left$last_evaluation)
boxplot.stats(stay$last_evaluation)

---average_monthly_hours---
hist(ds$average_monthly_hours,main=NULL,xlab="Avg. montly hours",ylab="Density",col=gray(seq(0.9,0.4,length=10)),cex.axis=1.2,cex.lab=1.5,font.lab=1,freq=FALSE,xlim=c(0,400),ylim=c(0,0.01))
hist(ds$average_monthly_hours,main=NULL,xlab="Avg. montly hours",ylab="Frequency",col=gray(seq(0.9,0.4,length=10)),cex.axis=1.2,cex.lab=1.5,font.lab=1,freq=TRUE,xlim=c(0,400),ylim=c(0,3000))
boxplot(average_monthly_hours~left,ds,horizontal=TRUE,xlab="Avg. monthly hours",ylab="Left",cex.lab=1.5,font.lab=1)
boxplot.stats(left$average_monthly_hours)
boxplot.stats(stay$average_monthly_hours)

#Scatter plot between two numeric variables (sample of data)
ds.sample <- ds[1:200,]
plot(ds.sample$satisfaction_level,ds.sample$last_evaluation,xlab="Satisfaction level",ylab="Last evaluation",cex.lab=1.5,font.lab=1,pch=19)
plot(ds.sample$satisfaction_level,ds.sample$average_montly_hours,xlab="Satisfaction level",ylab="Avg. montly hours",cex.lab=1.5,font.lab=1,pch=19)
plot(ds.sample$last_evaluation,ds.sample$average_montly_hours,xlab="Last evaluation",ylab="Avg. montly hours",cex.lab=1.5,font.lab=1,pch=19)


*****
Categorical/binary attributes
*****
#Evaluate the distribution of the categorical variables towards class attribute
---number_project---
barplot(table(ds$number_project),xlab="Num. projects",ylab="Frequency",col=gray(seq(0.9,0.4,length=4)),cex.names=1.2,cex.axis=1.2,cex.lab=1.5,font.lab=1,space=0.1,xlim=c(0,6),ylim=c(0,5000))
sum.number_project <- count(ds,c("left","number_project"))
names(sum.number_project)[3] <- "Num"
ggplot(sum.number_project,aes(factor(number_project),Num,fill = left)) + geom_bar(stat="identity", position = "dodge") + scale_fill_brewer(palette = "Set1")

---time_spend_company---
barplot(table(ds$time_spend_company),xlab="Time with the company",ylab="Frequency",col=gray(seq(0.9,0.4,length=4)),cex.names=1.2,cex.axis=1.2,cex.lab=1.5,font.lab=1,space=0.1,xlim=c(0,6),ylim=c(0,7000))
sum.time_spend_company <- count(ds,c("left","time_spend_company"))
names(sum.time_spend_company)[3] <- "Num"
ggplot(sum.time_spend_company,aes(factor(time_spend_company),Num,fill = left)) + geom_bar(stat="identity", position = "dodge") + scale_fill_brewer(palette = "Set1")

---work_accident---
prop.table(table(ds$work_accident))
sum.work_accident <- count(ds,c("left","work_accident"))
names(sum.work_accident)[3] <- "Num"
ggplot(sum.work_accident,aes(factor(work_accident),Num,fill = left)) + geom_bar(stat="identity", position = "dodge") + scale_fill_brewer(palette = "Set1")

---promotion_last_2years---
prop.table(table(ds$promotion_last_2years))
sum.promotion_last_2years <- count(ds,c("left","promotion_last_2years"))
names(sum.promotion_last_2years)[3] <- "Num"
ggplot(sum.promotion_last_2years,aes(factor(promotion_last_2years),Num,fill = left)) + geom_bar(stat="identity", position = "dodge") + scale_fill_brewer(palette = "Set1")

---division---
prop.table(table(ds$division))
sum.division <- count(ds,c("left","division"))
names(sum.division)[3] <- "Num"
ggplot(sum.division,aes(factor(division),Num,fill = left)) + geom_bar(stat="identity", position = "dodge") + scale_fill_brewer(palette = "Set1")
prop.table(table(left$division))
prop.table(table(stay$division))

---salary---
prop.table(table(ds$salary))
sum.salary <- count(ds,c("left","salary"))
names(sum.salary)[3] <- "Num"
ggplot(sum.salary,aes(factor(salary),Num,fill = left)) + geom_bar(stat="identity", position = "dodge") + scale_fill_brewer(palette = "Set1")
prop.table(table(left$salary))
prop.table(table(stay$salary))


