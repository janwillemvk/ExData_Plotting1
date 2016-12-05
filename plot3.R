# plot3.R
# Coursera Plotting Assignment 1 for Exploratory Data Analysis 
# by JWvK
# date: 05-12-2016
# The purpose to examine how household energy usage varies over a 2-day period in February, 2007. 
# Specifically to reconstruct the number of given plots, all of which were constructed using the base plotting system.

# Generic library setting and data file download
library(dplyr)
# The dataset has 2,075,259 rows and 9 columns.
# Let suppose that the dataset contains only numeric data. 
# How much memory is required to store this data frame? 
# Most modern computers double precision floating point numbers³ are stored using 64 bits of memory, 
# or, 8 bytes. Given that information, i can do the following calculation
# 2075259 × 9 × 8 bytes/numeric = 149418648 bytes
# = 149418648 / 2²??? bytes/MB  --> 2²???=1048576
# = 142,50 MB
# = 0,142 GB
# So the dataset would require about 0.1 GB of RAM.
ls() #see a list of the variables in the local workspace
rm(list=ls()) #clear the workspace
setwd("C:/JWvK/R-home/exploratory_data_analysis")  #please customise for your local computer
if(!file.exists("mydata")){dir.create("mydata")}
fileUrl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile="./mydata/exdata_data_household_power_consumption.zip", method="auto")
unzip("./mydata/exdata_data_household_power_consumption.zip", overwrite = TRUE, exdir = "./mydata")
list.files("./mydata") # expected outcome: [1] "getdata_projectfiles_UCI HAR Dataset.zip" "UCI HAR Dataset"
# load the data into a data frame
raw_hpc<-read.table("./mydata/household_power_consumption.txt", header=TRUE, sep=";", na.strings="?", strip.white=TRUE)
head(raw_hpc)  # examine the first few records
dim(raw_hpc)   # examine size
names(raw_hpc)  # look at column names
str(raw_hpc)    # look at datatypes
#We will only be using data from the dates 2007-02-01 and 2007-02-02. 
subset_hpc<-subset(raw_hpc, Date=='1/2/2007'|Date=='2/2/2007' )
dim(subset_hpc) # result must be [1] 2880   10
# we combine the Time and Date data into a date format (=datetime column)
subset_hpc$datetime <-strptime(paste(subset_hpc$Date,subset_hpc$Time, sep="-"),"%d/%m/%Y-%H:%M:%S", tz="CET")
# remove the Date and Time column 
hpc<-select(subset_hpc,datetime,Global_active_power:Sub_metering_3)
head(hpc) # checkout the result
# check for the impact of NA values by comparing row counts with and without NA
length(na.omit(hpc$Sub_metering_1))
length(hpc$Sub_metering_1)
length(na.omit(hpc$Sub_metering_2))
length(hpc$Sub_metering_2)
length(na.omit(hpc$Sub_metering_3))
length(hpc$Sub_metering_3)
######### plot 3 ############
with(hpc, plot(datetime, Sub_metering_1, type="n",ylab="Energy sub metering", xlab=""))
points(hpc$datetime, hpc$Sub_metering_1, type="l", col="black")
points(hpc$datetime, hpc$Sub_metering_2, type="l", col="red")
points(hpc$datetime, hpc$Sub_metering_3, type="l",col="blue")
legend("topright", pch=NA, lwd=1, col=c("black","blue", "red"), legend= c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"))
mtext("  Plot 3", outer = TRUE, adj = 0)
# print to file
dev.copy(png, file="plot3.png", width = 480, height = 480, units = "px")  
dev.off() ## Don't forget to close the png device!
