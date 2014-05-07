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


#############################
# generate plot
#############################
png(file="plot1.png",width=480,height=480,bg="transparent")
hist(subData$Global_active_power,
     col="red",bg="white",
     main="Global Active Power",
     xlab="Global Active Power (kilowatts)")
dev.off()  # close the png device


#############################
# clean up
#############################
closeAllConnections() # close connections after last use
unlink(textfile)
rm(subData,classes,fileUrl,textfile,zipfile)
