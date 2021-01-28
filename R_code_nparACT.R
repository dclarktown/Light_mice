#counting activity
setwd("your/path/here")
library(nparACT)
library(lubridate)
#SR= 6/60 (6 samples - every 10 sec - over 60 sec) = 0.1
##################################
load(file="nparACT_data.RData")
#actigraphy fig 2
feb4 <- feb4_oneweek_PIR24_R
aug22 <- aug22_oneweek_PIR146_R
sept11 <- sept11_oneweek_PIR6_R
#need to trim date info to be correct format
feb4$Time = substr(feb4$Time,1,nchar(feb4$Time)-5)#trims the last 4 off
feb4$date <- gsub("[a-zA-Z ]", " ", feb4$Time) #delete the T in the date format
feb4$Time <- feb4$date
feb4$date <- NULL
feba<- feb4[c(1:2)] #CL
febb<- feb4[c(1, 3)] #CL
#
name<- "feba"
output_feb_PIR2 <- nparACT_base(name, 0.10, cutoff = 1, plot = T, fulldays = T)
#
name<- "febb"
output_feb_PIR4 <- nparACT_base(name, 0.10, cutoff = 1, plot = T, fulldays = T)

#need to trim date info to be correct format
aug22$Time = substr(aug22$Time,1,nchar(aug22$Time)-5)#trims the last 4 off
aug22$date <- gsub("[a-zA-Z ]", " ", aug22$Time) #delete the T in the date format
aug22$Time <- aug22$date
aug22$date <- NULL
auga<- aug22[c(1:2)] #CD
augb<- aug22[c(1,3)] #CL
augc<- aug22[c(1,4)] #CD
#
name<- "auga"
output_aug_PIR1 <- nparACT_base(name, 0.10, cutoff = 1, plot = T, fulldays = T)

name<- "augb"
output_aug_PIR4 <- nparACT_base(name, 0.10, cutoff = 1, plot = T, fulldays = T)

name<- "augc"
output_aug_PIR6 <- nparACT_base(name, 0.10, cutoff = 1, plot = T, fulldays = T)

#need to trim date info to be correct format
sept11$Time = substr(sept11$Time,1,nchar(sept11$Time)-5)#trims the last 4 off
sept11$date <- gsub("[a-zA-Z ]", " ", sept11$Time) #delete the T in the date format
sept11$Time <- sept11$date
sept11$date <- NULL
septa<- sept11[c(1:2)] #CD
#
name<- "septa"
output_sept_PIR6 <- nparACT_base(name, 0.10, cutoff = 1, plot = T, fulldays = T)
