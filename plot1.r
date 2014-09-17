source("checkAndDownload.r") # Contains code to download the files in case absent

library(plyr)    # For join(), which is faster than merge() for the size of the dataframe
library(ggplot2) # For qplot()

# Function : plot1
# Author   : Suresh Nageswaran
# Input    : Path to the dataset, 
#            Data frame with the NEI dataset if available
#            Data frame with the SCC dataset if available
#            Boolean flag indicating if the output should go to a file
# Output   : File plot1.png with the output plot
# Dependencies : checkAndDownload.r
# How to invoke: On command line, simply type > plot1() 

plot1 <- function(sPath="C:/projects/rwork/exdata006/project2", dfNEI="", dfSCC="", bToFile = TRUE)
{
  
  if(!is.data.frame(dfNEI) || !is.data.frame(dfSCC))
  {
    checkAndDownload()
  
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
    # 
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
  
  # Compute the net decrease
  iDiff <- round(max(dfPlot1[,"Emissions"]) - min(dfPlot1[,"Emissions"]))
  sLabel <- paste("Emissions from PM 2.5 in the US declined by", iDiff)
  
  print("Creating plot on disk...")    
  # Initialize the device
  if (bToFile == TRUE)
  {
    # Initialize the PNG device
    png(filename=paste(sPath, "/plot1.png", sep=""), width=480, height=480)
  }
     
  #Create the plot  
  p <- qplot(Year, Emissions/1000, data=dfPlot1, ylab="Emissions (in millions)", geom=c("point", "smooth")) +
       annotate("text", x = 2004, y = 1000, label = sLabel)+
       geom_text(aes(label=round(dfPlot1$Emissions/1000)),hjust=.5, vjust=1)
  
  print(p)
   
  # Turn off the device i.e. flush to disk
  if (bToFile == TRUE) dev.off()
    
  # cleanup
  rm(lPlot1)
  
  print("Complete.")  
  return (TRUE)
  
}