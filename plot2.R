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
data$Time<-as.POSIXlt(paste(unlist(originData$Date), unlist(originData$Time),
                            sep=" ", collapse=NULL), format="%d/%m/%Y %X")
  
# Draw the plot.
windows()

plot(data$Time, data$Global_active_power, type="l", bg="transparent",
     xlab="", ylab="Global Active Power (kilowatts)")

# Save the plot to a .png file and restore previous working directory and locale.
dev.copy(png, file="plot2.png", bg="transparent")
dev.off()

setwd("..")
Sys.setlocale(category = "LC_ALL", locale = "")