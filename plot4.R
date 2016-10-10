# Include required libraries
library(dplyr)

if (!file.exists("data.zip")) {
    temp <- tempfile()
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
    
    
} else {
    temp <- tempfile()
    file.copy("data.zip", temp)
}

# Read exactly the data chunk for the task, optimized by skip and nrows
# enhance table with "tbl_df"
# then mutate a new column with the date and time information using as.POSIXct
df <- read.csv(unz(temp, "household_power_consumption.txt"), na.strings = "?", sep=";", skip=66637, nrows = 2880, header=FALSE, col.names = c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3"))%>%tbl_df%>%mutate(DateTime=as.POSIXct(paste(as.character(Date),as.character(Time)), format = "%d/%m/%Y %H:%M:%S", tz=""))
unlink(temp)

# creating graph in the screen
# disclaimer x-axist in spanish abbreviation for day names in the committed image due local idiom on my PC

# Split the device for 4 charts
par(mfrow=c(2,2))

# top-left plot
plot(df$DateTime, df$Global_active_power, ylab="Global Active Power", xlab = "", type = "l")
# top-right plot
plot(df$DateTime, df$Voltage, ylab="Voltage", xlab = "datetime", type = "l")
# bottom-left plot
plot(df$DateTime, df$Sub_metering_1, ylab="Energy sub metering", xlab = "", type = "l")
points(df$DateTime, df$Sub_metering_2, type = "l", col="red")
points(df$DateTime, df$Sub_metering_3, type = "l", col="blue")
legend("topright", names(df)[7:9], lty=1, col = c("black", "red", "blue"), bty='n', cex=.5)
# bottom-right plot
with(df, plot(DateTime, Global_reactive_power, type = "l"))

# saving to file plot4.png
dev.copy(png, filename="plot4.png")
dev.off()

writeLines("plot4.png generated!")
