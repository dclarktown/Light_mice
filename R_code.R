#This is some example code for running some basic calculations and creating the
#ERG waveform plots
setwd("your/path/here")
load("Data_masterfile_FIN.RData")
library(reshape2)
library(lme4)
library(nlme)
library(afex)
library(ggplot2)
library(lsmeans)
library(DescTools) #for Dunnett's test
names (Data_masterfile_FIN)
df <- Data_masterfile_FIN
rownames(df) <- df$ID
#making the A wave values postive rather than negative
df$X3AAmp_WK5 <- abs(df$X3AAmp_WK5)
df$X3AAmp_WK9 <- abs(df$X3AAmp_WK9)
df$X3AAmp_WK13 <- abs(df$X3AAmp_WK13)
df$X3AAmp_WK17 <- abs(df$X3AAmp_WK17)
df$X3AAmp_WK21 <- abs(df$X3AAmp_WK21)
#
df$X4AAmp_WK5 <- abs(df$X4AAmp_WK5)
df$X4AAmp_WK9 <- abs(df$X4AAmp_WK9)
df$X4AAmp_WK13 <- abs(df$X4AAmp_WK13)
df$X4AAmp_WK17 <- abs(df$X4AAmp_WK17)
df$X4AAmp_WK21 <- abs(df$X4AAmp_WK21)
#
df$X5AAmp_WK5 <- abs(df$X5AAmp_WK5)
df$X5AAmp_WK9 <- abs(df$X5AAmp_WK9)
df$X5AAmp_WK13 <- abs(df$X5AAmp_WK13)
df$X5AAmp_WK17 <- abs(df$X5AAmp_WK17)
df$X5AAmp_WK21 <- abs(df$X5AAmp_WK21)
######################################################
#creating a variable for treatment group
df$Treat <- ifelse(df$Light=="CL" & df$Treatment=="CON", "CLcon",
                   ifelse(df$Light=="CL" & df$Treatment=="HFD", "CLhfd",
                          ifelse(df$Light=="CD" & df$Treatment=="CON", "CDcon",
                                 ifelse(df$Light=="CD" & df$Treatment=="HFD", "CDhfd", NA))))
df$Treat <- as.factor(df$Treat)
df$Treat <- relevel(df$Treat,"CLcon") #making CL+CON group the reference
levels(df$Treat) #[1] "CLcon" "CDcon" "CDhfd" "CLhfd"
######################################################
#Analyzing OCT data (1-way ANOVA)
#options(contrasts = c("contr.sum","contr.poly")) #default 
options(contrasts = c("contr.treatment","contr.poly")) #contrasting treatment groups to CL+CON
#Evaluating retinal thickness
model_rt <- aov(AVG_Rt ~ Treat, data=df)# WK19 weight not a sig predictor
anova(model_rt) #Treatment group isn't significant
#DunnettTest(x=df$AVG_Rt, g=df$Treat) #Dunnett's test p-values
model_rt <- aov(AVG_Rt ~ Treat*Sex, data=df) # if wanting to evaluate Sex, can include an interaction term
anova(model_rt) # Sex also isn't significant
model_lt <- aov(AVG_Lt ~ Treat*Sex, data=df) #lens thickness
anova(model_lt) # Sex is significant
model_ct <- aov(AVG_Ct ~ Treat*Sex, data=df) #corneal thickness
anova(model_ct) # Sex, Treat not significant
model_acd <- aov(AVG_ACD ~ Treat*Sex, data=df) #anterior chamber depth thickness
anova(model_acd) # Sex is significant
model_vcd <- aov(AVG_VCD ~ Treat*Sex, data=df) #vitreous chamber depth thickness
anova(model_vcd) # Sex is significant
model_al <- aov(AVG_Al ~ Treat*Sex, data=df) #vitreous chamber depth thickness
anova(model_al) # Sex is significant
######################################################
#Analyzing greencone ERG Wk21 data (1-way ANOVA)
model_gc <- aov(WK21_greencone_B_Amp ~ Treat, data=df)
anova(model_gc)
DunnettTest(x=df$WK21_greencone_B_Amp, g=df$Treat) #Dunnett's test p-values
######################################################
#Analyzing OMR data (mixed-effects model)
# subset to just ID, treatment, and an OMR outcome to convert to "long" format
vars <- c("ID", "Treat", "Sex", "WK5_FREQ_C", "WK9_FREQ_C", "WK13_FREQ_C", "WK17_FREQ_C", "WK21_FREQ_C")
omr <- df[vars]
long_omr <- melt(omr, id.vars = 1:3)
long_omr$Treat <- as.factor(long_omr$Treat)
long_omr$Treat <- relevel(long_omr$Treat,"CLcon") #make CL+CON group the reference
levels(long_omr$Treat) #[1] "CLcon" "CDcon" "CDhfd" "CLhfd"
#
long_omr$time <- ifelse(long_omr$variable=="WK5_FREQ_C", 1,
                        ifelse(long_omr$variable=="WK9_FREQ_C", 2,
                               ifelse(long_omr$variable=="WK13_FREQ_C", 3,
                                      ifelse(long_omr$variable=="WK17_FREQ_C", 4,
                                             ifelse(long_omr$variable=="WK21_FREQ_C", 5, NA)))))
long_omr$time <- as.factor(long_omr$time)
long_omr$Sex <- as.factor(long_omr$Sex)
#
options(contrasts = c("contr.sum","contr.poly"))
model<-lmer(value ~time*Treat + (1|ID) ,data = long_omr, REML = TRUE)#order of variables will alter the result; 
#"time*Treat" will give different results than Treat*time
summary(model)
anova(model) #with the afex package installed, p-values provided
#Sex is a sig variable
model<-lmer(value ~time*Sex + (1|ID) ,data = long_omr, REML = TRUE)
anova(model)
#males have higher contrast values (female is reference)
model_omr_M <- aov(WK21_Michaelson_contrast ~ Treat*Sex, data=df) #wk5, wk9, wk13, wk17, wk21
anova(model_omr_M)

#ERG results; can replace outcome variable with variable of interest
fit <- lm(X5BAmp_WK21 ~ Treat*Sex, data=df)# Sex sig but not as interaction term at WK5, 9, 13, 17, 21
summary(fit) # show results
anova(fit)

#AUC results; can replace outcome variable with variable of interest
model_auc <- aov(WK20_AUC ~ Treat*Sex, data=df) #sex sig 4-20 wks
anova(model_auc) #Treat*Sex interaction at 12 and 16 weeks, but not at 4, 8, or 20 weeks
######################################################
#plotting example waveforms
# plot waveform
waves <- final_waveforms_wk9
#control light + control diet example waveforms wk 9
S1_CL_CON <- waves$CL_con_S1_4319
S2_CL_CON <- waves$CL_con_S2_4339
S3_CL_CON <- waves$CL_con_S3_4049
S4_CL_CON <- waves$CL_con_S4_4038
S5_CL_CON <- waves$CL_con_S5_4049
#control light + hfd example waveforms wk 9
S1_CL_HFD <- waves$CL_hfd_S1_4034
S2_CL_HFD <- waves$CL_hfd_S2_4034
S3_CL_HFD <- waves$CL_hfd_S3_4034
S4_CL_HFD <- waves$CL_hfd_S4_4325
S5_CL_HFD <- waves$CL_hfd_S5_4325
#developmental circadian disruption + control diet example waveforms wk 9
S1_CD_CON <- waves$CD_con_S1_4033
S2_CD_CON <- waves$CD_con_S2_4035
S3_CD_CON <- waves$CD_con_S3_4035
S4_CD_CON <- waves$CD_con_S4_4045
S5_CD_CON <- waves$CD_con_S5_4045
#developmental circadian disruption + hfd example waveforms wk 9
S1_CD_HFD <- waves$CD_hfd_S1_4622
S2_CD_HFD <- waves$CD_hfd_S2_4622
S3_CD_HFD <- waves$CD_hfd_S3_4048
S4_CD_HFD <- waves$CD_hfd_S4_4922
S5_CD_HFD <- waves$CD_hfd_S5_4095
#
par(mfrow=c(1,1))
#can change parameters if wanting to make a multiplot
#CL + CON
plot(S1_CL_CON, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="black", ylim=c(-600, 600))
plot(S2_CL_CON, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="black", ylim=c(-600, 600))
plot(S3_CL_CON, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="black", ylim=c(-600, 600))
plot(S4_CL_CON, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="black", ylim=c(-600, 600))
plot(S5_CL_CON, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="black", ylim=c(-600, 600))
#
#CL + HFD
plot(S1_CL_HFD, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="grey60", ylim=c(-600, 600))
plot(S2_CL_HFD, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="grey60", ylim=c(-600, 600))
plot(S3_CL_HFD, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="grey60", ylim=c(-600, 600))
plot(S4_CL_HFD, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="grey60", ylim=c(-600, 600))
plot(S5_CL_HFD, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="grey60", ylim=c(-600, 600))
#
#CD + CON
plot(S1_CD_CON, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="red", ylim=c(-600, 600))
plot(S2_CD_CON, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="red", ylim=c(-600, 600))
plot(S3_CD_CON, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="red", ylim=c(-600, 600))
plot(S4_CD_CON, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="red", ylim=c(-600, 600))
plot(S5_CD_CON, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="red", ylim=c(-600, 600))
#
#CD + HFD
plot(S1_CD_HFD, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="firebrick", ylim=c(-600, 600))
plot(S2_CD_HFD, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="firebrick", ylim=c(-600, 600))
plot(S3_CD_HFD, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="firebrick", ylim=c(-600, 600))
plot(S4_CD_HFD, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="firebrick", ylim=c(-600, 600))
plot(S5_CD_HFD, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="firebrick", ylim=c(-600, 600))
#########################################################
OP2<- example_OP2_waveforms_wk9_csv
#
S1_CL_CON <- OP2$CL_con_S1_4319
S2_CL_CON <- OP2$CL_con_S2_4022
S3_CL_CON <- OP2$CL_con_S3_4623
S4_CL_CON <- OP2$CL_con_S4_4049
S5_CL_CON <- OP2$CL_con_S5_4022
#
S1_CL_HFD <- OP2$CL_hfd_S1_4044
S2_CL_HFD <- OP2$CL_hfd_S2_4117
S3_CL_HFD <- OP2$CL_hfd_S3_4325
S4_CL_HFD <- OP2$CL_hfd_S4_4162
S5_CL_HFD <- OP2$CL_hfd_S5_4117
#
S1_CD_CON <- OP2$CD_con_S1_4918
S2_CD_CON <- OP2$CD_con_S2_4248
S3_CD_CON <- OP2$CD_con_S3_4918
S4_CD_CON <- OP2$CD_con_S4_4094
S5_CD_CON <- OP2$CD_con_S5_4918
#
S1_CD_HFD <- OP2$CD_hfd_S1_4919
S2_CD_HFD <- OP2$CD_hfd_S2_4622
S3_CD_HFD <- OP2$CD_hfd_S3_4282
S4_CD_HFD <- OP2$CD_hfd_S4_4922
S5_CD_HFD <- OP2$CD_hfd_S5_4099
#
#CL + CON
plot(S1_CL_CON, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="black", ylim=c(-200, 200))
plot(S2_CL_CON, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="black", ylim=c(-200, 200))
plot(S3_CL_CON, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="black", ylim=c(-200, 200))
plot(S4_CL_CON, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="black", ylim=c(-200, 200))
plot(S5_CL_CON, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="black", ylim=c(-200, 200))
#
#CL + HFD
plot(S1_CL_HFD, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="grey60", ylim=c(-200, 200))
plot(S2_CL_HFD, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="grey60", ylim=c(-200, 200))
plot(S3_CL_HFD, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="grey60", ylim=c(-200, 200))
plot(S4_CL_HFD, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="grey60", ylim=c(-200, 200))
plot(S5_CL_HFD, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="grey60", ylim=c(-200, 200))
#
#CD + CON
plot(S1_CD_CON, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="red", ylim=c(-200, 200))
plot(S2_CD_CON, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="red", ylim=c(-200, 200))
plot(S3_CD_CON, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="red", ylim=c(-200, 200))
plot(S4_CD_CON, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="red", ylim=c(-200, 200))
plot(S5_CD_CON, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="red", ylim=c(-200, 200))
#
#CD + HFD
plot(S1_CD_HFD, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="firebrick", ylim=c(-200, 200))
plot(S2_CD_HFD, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="firebrick", ylim=c(-200, 200))
plot(S3_CD_HFD, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="firebrick", ylim=c(-200, 200))
plot(S4_CD_HFD, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="firebrick", ylim=c(-200, 200))
plot(S5_CD_HFD, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="firebrick", ylim=c(-200, 200))
#########################################################
# plot flicker waveforms
flicker <- wk9_flicker_waveforms_csv
F_CL_CON <- flicker$CL_CON_4179
F_CL_HFD <- flicker$CL_HFD_4113
F_CD_CON <- flicker$CD_CON_4045
F_CD_HFD <- flicker$CD_HFD_4277
#all flicker wk 9 example waveforms
plot(F_CL_CON, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="black", ylim=c(-50, 150))
plot(F_CL_HFD, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="grey60", ylim=c(-50, 150))
plot(F_CD_CON, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="red", ylim=c(-50, 150))
plot(F_CD_HFD, type = 'l', xlab = 'Time', ylab = 'Amplitude',lwd=5, col="firebrick", ylim=c(-50, 150))
#

