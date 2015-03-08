##Ensure that your working directory is set to an empty folder in your desired
##location before running plot1()
plot1 <- function(){
  
  #load required sqldf library.  sqldf is used to subset the desired 
  ##days from large data file when loading the data
  library(sqldf)
  
  ##Data source
  dataURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  ##name downloaded file
  zipName <- "PowerConsumption.zip"
  ##download the file from the source
  download.file(dataURL, zipName, mode = "wb")
  
  ##Unzip the file into the set working directory
  unzip(zipName)
  
  ##Assuming data is in a text file retrieves the name of the data file.
  ##if the data is stored in a different file type this code must be modified
  files <- list.files()
    file <- grep(pattern = "\\.txt", files, value = TRUE)
  
  ##Reads the data using an sql statement to select only the desired days from the data
  data1 <<- read.csv.sql(file, sql = "SELECT * FROM file 
                        WHERE Date = '1/2/2007' 
                        OR Date = '2/2/2007'", header = TRUE, sep = ";")
  closeAllConnections()
  
  ##Convert columns 3 to end to numeric
  numercol <- c(3:ncol(data1))
    data1[,numercol] <- as.numeric(as.character(unlist(data1[,numercol])))
  
  ##sets graphic device to png output 480x480 pixels with transparent background
  png('./repo/plot1.png',width=480,height=480,units="px",bg = "transparent")
  
  ##writes histogram to png renaming main title, setting fill color and labelling x axis.
  hist(data1$Global_active_power, main = "Global Active Power", col = "red", xlab = "Global Active Power (kilowatts)")
  
  ##close connection to png
  dev.off()
}