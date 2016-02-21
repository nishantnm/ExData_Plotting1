library(data.table)
library(plyr)
library(dplyr)
library(lubridate)



# Download the zip file and unzip it
file.url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(file.url, destfile = "data.zip")
unzip("data.zip")

dt <- read.table("household_power_consumption.txt", stringsAsFactors = FALSE,
                 sep = ";", header = TRUE)


dt <- mutate(dt,
             Date = as.Date(Date, "%d/%m/%Y"))

dt.final <- filter(dt, Date >= as.Date("2007-02-01", "%Y-%m-%d") & 
                     Date <= as.Date("2007-02-02", "%Y-%m-%d"))

dt.final.1 <- filter(dt.final, Global_active_power != "?" &
                       Global_reactive_power != "?" &
                       Voltage != "?" &
                       Sub_metering_1 != "?" &
                       Sub_metering_2 != "?" &
                       Sub_metering_3 != "?") %>%
  mutate(Global_active_power = as.numeric(Global_active_power),
         Global_reactive_power = as.numeric(Global_reactive_power),
         Voltage = as.numeric(Voltage),
         Sub_metering_1 = as.numeric(Sub_metering_1),
         Sub_metering_2 = as.numeric(Sub_metering_2),
         Sub_metering_3 = as.numeric(Sub_metering_3))

datetime <- strptime(paste(dt.final.1$Date, dt.final.1$Time, sep = " "), "%Y-%m-%d %H:%M:%S")

png("plot4.png", width=480, height=480)

par(mfrow = c(2,2))

plot(datetime, dt.final.1$Global_active_power, type = "l",
     xlab = "", ylab = "Global Active Power")

plot(datetime, dt.final.1$Voltage, type = "l",
     xlab = "datetime", ylab = "Voltage")

plot(datetime, dt.final.1$Sub_metering_1, type = "l",
     xlab = "", ylab = "Energy sub metering")
lines(datetime, dt.final.1$Sub_metering_2, type = "l",
      col = "red")
lines(datetime, dt.final.1$Sub_metering_3, type = "l",
      col = "blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty=1, lwd=1, bty = "n", col=c("black", "red", "blue"))

plot(datetime, dt.final.1$Global_reactive_power, type = "l",
     xlab = "datetime", ylab = "Global_reactive_power")

dev.off()