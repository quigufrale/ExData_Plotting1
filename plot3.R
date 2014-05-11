# Get Data
# Set appropriate directory by using setwd
# For Example:
setwd("C:/Users/quigufrale/Documents/COURSERA/DataScienceSpecialization/SM14_4_ExploratoryDataAnalysis/w1/PrA")
if(!file.exists("data")){dir.create("data")} # First create data folder
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileURL, destfile="./data/household_power_consumption.zip") # Download file
# I will use read.csv.sql from the sqldf package
# for that I will need to unzip the file first
unzip("./data/household_power_consumption.zip",
      files = "household_power_consumption.txt", exdir = "./data")
# Since the sqldf package is required, if not installed, 
# uncomment the following line
# install.packages("sqldf")
library(sqldf)
mySql <- "SELECT * from file WHERE Date = '1/2/2007' OR Date = '2/2/2007'"
PwrData <- read.csv.sql("./data/household_power_consumption.txt", sql=mySql, sep=";")
# Checking missing data ?
checkQM <- PwrData == "?"
if (sum(colSums(checkQM)) == 0){print('No missing data')}

# Create datetime column
PwrData$Date<-as.Date(PwrData$Date, format = '%d/%m/%Y')
PwrData$datetime <- paste(PwrData$Date, PwrData$Time)
PwrData$datetime<-strptime(PwrData$datetime, "%Y-%m-%d %H:%M:%S")

# plot 3
png(file = "./plot3.png", bg = "transparent", width = 480, height = 480, units = "px")
plot(PwrData$datetime,PwrData$Sub_metering_1,type="l",col="black",
     xlab = "",
     ylab = "Energy sub metering")
lines(PwrData$datetime,PwrData$Sub_metering_2,col="red")
lines(PwrData$datetime,PwrData$Sub_metering_3,col="blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
                              lty=c(1,1,1), col=c("black", "red", "blue"))
dev.off()