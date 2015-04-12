## Getting full dataset
filePath <- "./data/household_power_consumption.txt"
bfileExist <- file.exists(filePath)

if(!bfileExist)
{
  mainDir <- getwd()
  subDir <- "data"
  
  dir.create(file.path(mainDir, subDir), showWarnings = FALSE)
  
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  zipfile <- "./data/household_power_consumption.zip"
  
  download.file(url,zipfile)
  
  unzip(zipfile, exdir="./data")
}

## Getting full dataset
data <- read.csv(   filePath,
                    header=TRUE, 
                    sep=';', 
                    na.strings="?", 
                    nrows=2075259, 
                    check.names=FALSE, 
                    stringsAsFactors=FALSE, 
                    quote='\"')

data$Date <- as.Date(data$Date, format="%d/%m/%Y")

## Subsetting the data (data of interest)
doi <- subset(data, subset=(Date >= "2007-02-01" & Date <= "2007-02-02"))
rm(data)

## Converting dates
datetime <- paste(as.Date(doi$Date), doi$Time)
doi$Datetime <- as.POSIXct(datetime)

## Plot 4
par(mfrow=c(2,2), mar=c(4,4.2,2,1), oma=c(0,0,2,0))
with(doi, {
        plot( Global_active_power~Datetime, 
              type="l", 
              ylab="Global Active Power (kilowatts)", 
              xlab="")
        plot( Voltage~Datetime, 
              type="l", 
              ylab="Voltage (volt)", 
              xlab="")
        plot( Sub_metering_1~Datetime, 
              type="l", 
              ylab="Global Active Power (kilowatts)", 
              xlab="")
        lines(Sub_metering_2~Datetime,col='Red')
        lines(Sub_metering_3~Datetime,col='Blue')
        legend( "topright", 
                col=c("black", "red", "blue"), 
                lty=1, 
                lwd=1, 
                bty="n",
                legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
        plot( Global_reactive_power~Datetime, 
              type="l", 
              ylab="Global Rective Power (kilowatts)",
              xlab="")
})

## Saving to file
dev.copy(png, file="./data/plot4.png", height=480, width=480)
dev.off()
