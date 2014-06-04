# Load required packages.
library(utils)

# Set locale.
Sys.setlocale(category = "LC_TIME", locale = "C")

# Create and set working directory. Download and unzip file.
url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

if (!file.exists("figure")) {
    dir.create("figure")
}
setwd("./figure")

if (!file.exists("household_power_consumption.txt")) {
    download.file(url, destfile="./exdata_data_household_power_consumption.zip")
    file<-unzip(zipfile="./exdata_data_household_power_consumption.zip") #from utils package
}

# Obtain data in desired form.
originFile<-"household_power_consumption.txt"

colNamesRaw<-(read.table(originFile, nrows=1, sep=";", header=F))[1,]
colNames<-as.character(unlist(colNamesRaw))
originData<-read.table(originFile, header=F, skip=66637, nrows=2880,
                       col.names=colNames, sep=";", na.strings="?")

data<-originData
x<-unlist(originData$Date)
y<-unlist(originData$Time)
data$Time<-as.POSIXlt(paste(x, y, sep=" ", collapse=NULL), format="%d/%m/%Y %X")

# Draw the plot.
windows()

plot(data$Time, data$Sub_metering_1, type="n", bg="transparent",
     xlab="", ylab="Energy sub metering")
lines(data$Time, data$Sub_metering_1, col="black")
lines(data$Time, data$Sub_metering_2, col="red")
lines(data$Time, data$Sub_metering_3, col="blue")
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col=c("black", "red", "blue"), lty=c(1,1), adj=0.08)
# argument adj changes the position of the legend labels. Used here
# because (on my computer at least) the legend labels had cut ends.

# Save the plot to a .png file and restore previous working directory and locale.
dev.copy(png, file="plot3.png", bg="transparent")
dev.off()

setwd("..")
Sys.setlocale(category = "LC_ALL", locale = "")