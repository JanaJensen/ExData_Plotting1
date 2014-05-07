#############################
# Class:      Exploratory Data Analysis
# URL:        https://class.coursera.org/exdata-002
# Assignment: Course Project 1
# Student:    Jeanne-Anne Jensen, jana.jensen@comcast.net
#############################
library(R.utils)  # countLines
library(sqldf)    # read.csv.sql
setwd("~/GitHub/ExData_Plotting1")


#############################
# get the source data, download if necessary, and unzip the only file
#############################
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipfile <- "exdata-data-household_power_consumption.zip"
if(!file.exists(zipfile)){download.file(fileUrl,destfile=zipfile)}
unzip(zipfile, list=FALSE)
textfile <- unzip(zipfile,files=NULL,list=TRUE)[1,"Name"] # let zip tell us text file name


#############################
# prep data
#############################
sampData <- read.table(textfile,header=TRUE,sep=";",na.strings="?",n=5) 
classes <- sapply(sampData,class) # derive data classes from first few rows
rm(sampData) # free up memory after last use

# read in the rows we want
subData <- read.csv.sql(textfile,header=TRUE,sep=";",
                        sql="select * from file where Date in ('1/2/2007','2/2/2007')",
                        colClasses = classes)

# set variables for later use
subData$DtTm <-strptime(paste(subData$Date,subData$Time), "%d/%m/%Y %H:%M:%S")
scaleSubMeter <- max(subData$Sub_metering_1,subData$Sub_metering_2,subData$Sub_metering_3)


#############################
# generate plot
#############################
png(file="plot4.png",width=480,height=480,bg="transparent")
par(mfrow = c(2,2))  # four plots aranged 2x2 row-wise
# 1
with(subData,plot(DtTm,Global_active_power,
                  type="l",
                  xlab="",
                  ylab="Global Active Power"))
# 2
with(subData,plot(DtTm,Voltage,
                  type="l",
                  xlab="datetime",))
# 3
with(subData,plot(DtTm,Sub_metering_1,
                  type="l",
                  xlab="",
                  ylab="Energy sub metering",
                  ylim=c(0,scaleSubMeter),
                  col="black"))
par(new=TRUE)  # paint additional charts on same frame
with(subData,plot(DtTm,Sub_metering_2,
                  type="l",
                  xlab="",
                  ylab="",
                  ylim=c(0,scaleSubMeter),
                  col="red"))
par(new=TRUE)  # paint additional charts on same frame
with(subData,plot(DtTm,Sub_metering_3,
                  type="l",
                  xlab="",
                  ylab="",
                  ylim=c(0,scaleSubMeter),
                  col="blue"))
par(new=FALSE)  # reset to default
legend("topright",lwd=1, bty="n",
       col=c("black","red","blue"),
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
# 4
with(subData,plot(DtTm,Global_reactive_power,
                  type="l",
                  xlab="datetime",))
par(mfrow = c(1,1))  # reset to default
dev.off()  # close the png device


#############################
# clean up
#############################
closeAllConnections() # close connections after last use
unlink(textfile)
rm(subData,classes,fileUrl,textfile,zipfile,scaleSubMeter)
