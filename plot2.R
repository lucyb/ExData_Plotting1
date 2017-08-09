outputdir  <- "data"
orgdataset <- "dataset.zip"
outputfile <- "household_power_consumption.txt"

fetch_data <- function(outputdir, orgdataset, outputfile) {
    # Download and extract the dataset
    if (!dir.exists(outputdir)) {
        dir.create(outputdir)
    }
    if (!file.exists(file.path(outputdir, orgdataset))) {
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", file.path(outputdir, orgdataset))
    }
    
    unzip(file.path(outputdir, orgdataset), exdir = outputdir)
    
    # Read in the dataset
    hpc <- read.table(file.path(outputdir, outputfile), header = T, sep = ";", na.strings = "?", stringsAsFactors = F)
    
    # Correct date formats
    hpc$Date <- as.Date(hpc$Date, format="%d/%m/%Y")
    
    # Filter only the rows where the date is 2007-02-01 or 2007-02-02
    hpc <- hpc[hpc$Date == '2007-02-01' | hpc$Date == '2007-02-02',]
    
    # Merge into a new datetime field
    hpc$NewDate <- strptime(paste(hpc$Date, hpc$Time, sep = ", "), format = "%Y-%m-%d, %H:%M:%S")
    
    # Tidy Up by deleting the extracted data
    unlink(outputdir)
    
    hpc
}

# Retrieve data and load into a data frame
hpc <- fetch_data(outputdir, orgdataset, outputfile)

#Our overall goal here is simply to examine how household energy usage varies over a 2-day period in February, 2007.

# Open a PNG graphics device
png("plot2.png", height=480, width=480) 

# Plot voltage over time
plot(hpc$NewDate, hpc$Global_active_power, main = "", ylab = "Global Active Power (kilowatts)", xlab = "", type = 'l')

# Close the png device
dev.off() 
