# Please visit https://github.com/sureshnageswaran/ExData006-Project2
# View this readme file before using the code
# https://github.com/sureshnageswaran/ExData006-Project2/blob/master/README.md

# The source file mentioned below is no longer needed, since the function has been appended to the end of this code file.
#source("checkAndDownload.r") # Contains code to download the files in case absent

library(plyr)    # For join(), which is faster than merge() for the size of the dataframe
# library(ggplot2) 

# Function : plot1
# Author   : Suresh Nageswaran
# Input    : Path to the dataset, 
#            Data frame with the NEI dataset if available
#            Data frame with the SCC dataset if available
#            Boolean flag indicating if the output should go to a file
# Output   : File plot1.png with the output plot
# Dependencies : checkAndDownload.r
# How to invoke: On command line, simply type > plot1() 

plot1 <- function(sPath="C:/projects/rwork/exdata006/project2/ExData006-Project2", dfNEI="", dfSCC="", bToFile = TRUE)
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
    # Question: [1]
    # 
    # Have total emissions from PM2.5 decreased in the United States 
    # from 1999 to 2008? Using the base plotting system, make a plot
    # showing the total PM2.5 emission from all sources for each of 
    # the years 1999, 2002, 2005, and 2008?
    # 
    # Answer:
    # 
    # We will plot the emissions data over the years to show this.
    # Annotations will be provided to show the net decrease as well
    # as the % decrease.
    # Approach:
    # 
    # For the first plot, we summarize the PM2.5 data by year
    # tapply the 'sum' function on Emissions along the index year
    # Finally invoke the plot function for the graph.
    # Output is seen in plot1.png
  # ------------------------------------------------------------------#
  
  print("Running tapply operation on dataframe...")
  # We tapply the sum function along the index year
  lPlot1 <- tapply(dfNEI$Emissions, dfNEI$year, sum)
  
  # Convert to dataframe
  dfPlot1 <- data.frame(Year=as.numeric(names(lPlot1)), Emissions=as.numeric(lPlot1))
  
  iMin <- dfPlot1$Emissions[dfPlot1$Year==min(dfPlot1$Year)]
  iMax <- dfPlot1$Emissions[dfPlot1$Year==max(dfPlot1$Year)]
  # Compute the net decrease

  iDiff <- round((iMax - iMin)* -1, digits=2)
  dPercent <- round(((iMax - iMin)/iMin)*-1*100, digits=2)
  
  #iDiff <- round(max(dfPlot1[,"Emissions"]) - min(dfPlot1[,"Emissions"]))
  
  # Text for hte graph
  sLabel <- paste(paste("Emissions from PM 2.5 in the US declined by", format(iDiff, big.mark=",", scientific=F)), ".", sep="")
  sLabel <- paste(paste(sLabel, "\nThis is a net decrease of ", dPercent), "%.", sep="")
  
  # Compute the % decrease from 1998 to 2008  
  # dPercent <- 100 * round(min(dfPlot1[,"Emissions"]) / max(dfPlot1[,"Emissions"]), digits = 2)
  
  
  print("Creating plot on disk...")    
  # Initialize the device
  if (bToFile == TRUE)
  {
    # Initialize the PNG device
    png(filename=paste(sPath, "/plot1.png", sep=""), width=1000, height=480)
  }
    
  par(pch=22, col="red")
  plot(dfPlot1$Year, dfPlot1$Emissions/1000, type="o", xlab="Year", ylab="Emissions (in millions)", col="red")
  title("Plot#1: Emissions vs. Year",sub="") # sub=sLabel)
  text(2004, 5000, sLabel, cex=.8) 
   
  #Create the plot  
  #p <- qplot(Year, Emissions/1000, data=dfPlot1, ylab="Emissions (in millions)", geom=c("point", "smooth")) +
  #     annotate("text", x = 2004, y = 1000, label = sLabel)+
  #     geom_text(aes(label=round(dfPlot1$Emissions/1000)),hjust=.5, vjust=1)  
  #print(p)
   
  # Turn off the device i.e. flush to disk
  if (bToFile == TRUE) dev.off()
    
  # cleanup
  rm(lPlot1)
  
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