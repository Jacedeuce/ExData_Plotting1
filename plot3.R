##Ensure that your working directory is set to an empty folder in your desired
##location before running plot1()
plot3 <- function(){
  
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
  
  ##paste date and time fields into single column
  data1$datetime <- paste(data1$Date, data1$Time, sep=" ")
  
  ##use strptime() to convert datetime column into "POSIXlt" "POSIXt" format
  data1$POSdate <- strptime(data1$datetime, format = "%d/%m/%Y %H:%M:%S")
  
  ##sets graphic device to plot2.png output in repo folder - 480x480 pixels with transparent background
  png('./repo/plot3.png',width=480,height=480,units="px",bg = "transparent")
  
  ##creates plot format without plotting points
  plot(data1$POSdate, data1$Sub_metering_1, type = "n",  ylab = "Energy sub metering", xlab = "")
  ##plots lines of each sub-meter vs Date
  lines(data1$POSdate, data1$Sub_metering_1, col = "black")
  lines(data1$POSdate, data1$Sub_metering_2, col = "red")
  lines(data1$POSdate, data1$Sub_metering_3, col = "blue")
  ##adds legend on top right with lines and color coded
  legend(x="topright", lty = 1, legend = c(names(data1[,7:9])), col = c("black", "red", "blue"))
  
  ##close connection to png
  dev.off()
}