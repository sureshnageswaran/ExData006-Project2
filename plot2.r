# Please visit https://github.com/sureshnageswaran/ExData006-Project2
# View this readme file before using the code
# https://github.com/sureshnageswaran/ExData006-Project2/blob/master/README.md

# The source file mentioned below is no longer needed, since the function has been appended to the end of this code file.
#source("checkAndDownload.r") # Contains code to download the files in case absent

library(plyr)    # For join(), which is faster than merge() for the size of the dataframe
library(ggplot2) # For qplot()

# Function : plot2
# Author   : Suresh Nageswaran
# Input    : Path to the dataset, 
#            Data frame with the NEI dataset if available
#            Data frame with the SCC dataset if available
#            Boolean flag indicating if the output should go to a file
# Output   : File plot2.png with the output plot
# Dependencies : checkAndDownload.r
# How to invoke: On command line, simply type > plot2() 

plot2 <- function(sPath="C:/projects/rwork/exdata006/project2/ExData006-Project2", dfNEI="", dfSCC="", bToFile = TRUE)
{
  
  if(!is.data.frame(dfNEI) || !is.data.frame(dfSCC))
  {
    if ( checkAndDownload(sPath) == FALSE )
    {
      sPath = getwd()
    }
   
    # read in the NEI and SCC rds files into dataframes
    print("Reading in NEI dataframe ...")
    dfNEI <- readRDS("summarySCC_PM25.rds")
    print("Reading in SCC dataframe ...")
    dfSCC <- readRDS("Source_Classification_Code.rds")
  }
  
  # ------------------------------------------------------------------#
    # Question: [2]
    # 
    # Have total emissions from PM2.5 decreased in the Baltimore City, 
    # Maryland (fips == "24510") from 1999 to 2008? Use the base 
    # plotting system to make a plot answering this question.
    # 
    # Answer:
    # We will plot the emissions data over the years for Baltimore.
    # 
    # Approach: 
    # For the second plot, we summarize the PM2.5 data for Baltimore
    # tapply the 'sum' function on Emissions along the index year
    # Finally invoke the plot function for the graph.
    # Output is seen in plot2.png
  # ------------------------------------------------------------------#
  
  # For the second plot, we summarize the PM2.5 data for Baltimore
   print("Running subset operation on dataframe ...")
   dfBalt <- subset(dfNEI, fips == "24510", select = c(year, Emissions))
  
  # tapply the 'sum' function on 'Emissions' along the index 'year'
  lBalt <- tapply(dfBalt$Emissions, dfBalt$year, sum)
  
  dfBalt <- data.frame(Year=as.numeric(names(lBalt)), Emissions=as.numeric(lBalt))
  
  iDiff <- round(max(dfBalt[,"Emissions"]) - min(dfBalt[,"Emissions"]))
  sLabel <- paste("Emissions (PM 2.5) in Baltimore declined by", iDiff)
    
  print("Creating plot on disk...")
  if (bToFile == TRUE)
  {
    # Initialize the PNG device
    png(filename=paste(sPath, "/plot2.png", sep=""), width=1000, height=480)
  }
  
  #Create the plot using the base plotting tools
  par(pch=22, col="red")
  plot(dfBalt$Year, dfBalt$Emissions, type="o", xlab="Year", ylab="Emissions", col="red")
  title("Plot#2: Emissions vs. Year in Baltimore", sub=sLabel)
 
 
  #p <- qplot(Year, Emissions, data=dfBalt, ylab="Emissions", geom=c("point", "smooth")) +
  #     annotate("text", x = 2004, y = 2000, label = sLabel)+
  #     geom_text(aes(label=round(dfBalt$Emissions)),hjust=.5, vjust=.1)  
  #print(p)
  
  # Turn off the device i.e. flush to disk  
  if (bToFile == TRUE) dev.off()
    
  # cleanup
  rm(dfBalt,lBalt)
  
  print("Complete.")
  
  return (TRUE)
  
}

# Function : checkAndDownload
# Author   : Suresh Nageswaran
# Input    : Path to the dataset, 
# Output   : Boolean
#            True if the given path was valid; False otherwise
# Dependencies : None
# How to invoke: On command line, simply type > checkAndDownload("<Path>")
# Purpose  : This function checks if the input files required are present.
#            If absent, they are downloaded into the current folder.

checkAndDownload <- function(sPath="")
{
 # List of required files
  files <- c(
            "summarySCC_PM25.rds",           # NEI
            "Source_Classification_Code.rds" # SCC
           )     
           
 if( ! file.exists(sPath) )
 {
    # Either no path was given or path was wrong
    # In this case, we set the current directory as the path
    sPath = getwd()
    setwd(sPath)
    retVal <- FALSE
  }
  else
  {
    retVal <- TRUE
  }
  
 # Check if the files are in the working directory     
  if( !all(file.exists(files)) )
  {    
    # download the files
    temp <- tempfile()
    fileURL <-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(fileURL,temp)
    unzip(temp,files=files)
    file.remove(temp)    
  }

  
  return (retVal)

}