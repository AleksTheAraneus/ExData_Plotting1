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
windows(xpinch=360, ypinch=360)

par(mfrow=c(2,2))
with(data, {
    plot(Time, Global_active_power, type="l", bg="transparent",
         xlab="", ylab="Global Active Power")
    plot(Time, Voltage, type="l", bg="transparent",
         xlab="datetime", ylab="Voltage")
    plot(Time, Sub_metering_1, type="n", bg="transparent",
          xlab="", ylab="Energy sub metering")
    lines(Time, Sub_metering_1, col="black")
    lines(Time, Sub_metering_2, col="red")
    lines(Time, Sub_metering_3, col="blue")
    legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
           col=c("black", "red", "blue"), lty=c(1,1), bty="n", cex=0.8)
    plot(Time, Global_reactive_power, type="l", bg="transparent",
         xlab="datetime")
})


# Save the plot to a .png file and restore previous working directory and locale.
dev.copy(png, file="plot4.png", bg="transparent")
dev.off()

setwd("..")
Sys.setlocale(category = "LC_ALL", locale = "")