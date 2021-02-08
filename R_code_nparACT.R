#counting activity
setwd("your/path/here")
library(nparACT)
library(lubridate)
#SR (sample rate) = 6/60 (6 samples - every 10 sec - over 60 sec) = 0.1
##################################
load(file="nparACT_data.RData")
#actigraphy fig 2
apr <- apr_nparact
aug <- aug_nparact
sept <- sept_nparact
jul <- jul_nparact
#NOTE: the F3_CL PIR data from April is a cage of females fed CON diet (rather than chow)
#need to trim date info to be correct format
apr$Time = substr(apr$Time_apr,1,nchar(apr$Time_apr)-5)#trims the last 4 off
apr$date <- gsub("[a-zA-Z ]", " ", apr$Time_apr) #delete the T in the date format
apr$Time_apr <- apr$date
apr$date <- NULL
apra<- apr[c(1:2)] #CL
#
name<- "apra"
output_apr_F3cl <- nparACT_base(name, 0.10, cutoff = 1, plot = T, fulldays = T)

#need to trim date info to be correct format
aug$Time_aug = substr(aug$Time_aug,1,nchar(aug$Time_aug)-5)#trims the last 4 off
aug$date <- gsub("[a-zA-Z ]", " ", aug$Time_aug) #delete the T in the date format
aug$Time_aug <- aug$date
aug$date <- NULL
auga<- aug[c(1:2)] #CL
augb<- aug[c(1,3)] #CD
augc<- aug[c(1,4)] #CD
#
name<- "auga"
output_aug_F1cl <- nparACT_base(name, 0.10, cutoff = 1, plot = T, fulldays = T)

name<- "augb"
output_aug_F1cd <- nparACT_base(name, 0.10, cutoff = 1, plot = T, fulldays = T)

name<- "augc"
output_aug_F2cd <- nparACT_base(name, 0.10, cutoff = 1, plot = T, fulldays = T)

#need to trim date info to be correct format
sept$Time_sept = substr(sept$Time_sept,1,nchar(sept$Time_sept)-5)#trims the last 4 off
sept$date <- gsub("[a-zA-Z ]", " ", sept$Time_sept) #delete the T in the date format
sept$Time_sept <- sept$date
sept$date <- NULL
septa<- sept[c(1:2)] #CD
#
name<- "septa"
output_sept_F3cd <- nparACT_base(name, 0.10, cutoff = 1, plot = T, fulldays = T)

#need to trim date info to be correct format
jul$Time_jul = substr(jul$Time_jul,1,nchar(jul$Time_jul)-5)#trims the last 4 off
jul$date <- gsub("[a-zA-Z ]", " ", jul$Time_jul) #delete the T in the date format
jul$Time_jul <- jul$date
jul$date <- NULL
jula<- jul[c(1:2)] #CL
#
name<- "jula"
output_jul_F2cl <- nparACT_base(name, 0.10, cutoff = 1, plot = T, fulldays = T)
