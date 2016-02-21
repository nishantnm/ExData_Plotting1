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

dt.final.1 <- filter(dt.final, Global_active_power != "?") %>%
              mutate(Global_active_power = as.numeric(Global_active_power))

png("plot1.png", width=480, height=480)

hist(dt.final.1$Global_active_power, col = "red",
     xlab = "Global Active Power (kilowatts)", 
     main = "Global Active Power")

dev.off()
