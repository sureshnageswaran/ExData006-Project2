# Please visit https://github.com/sureshnageswaran/ExData006-Project2
# View this readme file before using the code
# https://github.com/sureshnageswaran/ExData006-Project2/blob/master/README.md

# The source file mentioned below is no longer needed, since the function has been appended to the end of this code file.
#source("checkAndDownload.r") # Contains code to download the files in case absent

library(plyr) # For join(), which is faster than merge() for the size of the dataframe
library(ggplot2) # For qplot()
library(reshape) # For melt()

# Function : plot3
# Author   : Suresh Nageswaran
# Input    : Path to the dataset, 
#            Data frame with the NEI dataset if available
#            Data frame with the SCC dataset if available
#            Boolean flag indicating if the output should go to a file
# Output   : File plot3.png with the output plot
# Dependencies : checkAndDownload.r
# How to invoke: On command line, simply type > plot3() 

plot3 <- function(sPath="C:/projects/rwork/exdata006/project2/ExData006-Project2", dfNEI="", dfSCC="", bToFile = TRUE)
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
    # Question: [3]
    # 
    # Of the four types of sources indicated by the 
    # type (point, nonpoint, onroad, nonroad) variable, 
    # which of these four sources have seen decreases in emissions
    # from 1999-2008 for Baltimore City? 
    # Which have seen increases in emissions from 1999-2008? 
    # Use the ggplot2 plotting system to make a plot answer this question.
    #
    # Answer:
    # Plotting emissions vs year for Baltimore with one smoothly fitted
    # line for each type will show both the increase and the decrease.
    # Annotations will be added to the graph to call out these changes.
    # 
    # Approach: 
    # For the plot, we summarize the PM2.5 data by year for B'more.
    # tapply the 'sum' function on Emissions along indexes year,type
    # Finally invoke the qplot function from ggplot2 for the graph.
    # Output is seen in plot3.png
  # ------------------------------------------------------------------# 
  
  # For the third plot, we summarize the PM2.5 data for Baltimore
  # We are required to use ggplot2 for this
  
  print("Running subset operation on dataframe ...")  
  dfBalt <- subset(dfNEI, fips == "24510", select = c(year, type, Emissions))
  
  # tapply the 'sum' function on 'Emissions' along the indexes 'year' and 'type'
  dfBalt <- as.data.frame(tapply(dfBalt$Emissions, list(dfBalt$year, dfBalt$type), sum))
  
  dfBalt <- cbind(Year=as.numeric(rownames(dfBalt)), dfBalt)
  rownames(dfBalt)<-NULL
  dfBalt <- melt(dfBalt, id=c("Year"))
  colnames(dfBalt) <- c("Year", "Type", "Emissions")
  
  print("Creating plot on disk...")  
  if (bToFile == TRUE)
  {
    # Initialize the PNG device
    png(filename=paste(sPath, "/plot3.png", sep=""), width=1000, height=480)
  }
  
  #Create the plot  
  p <- qplot(Year, Emissions, data=dfBalt, color=Type, geom=c("point", "smooth")) +
       geom_text(aes(label=round(dfBalt$Emissions)),hjust=.5, vjust=.1)+
       annotate("text", x = 2004, y = 1000, label = "Emissions from all sources except Point have declined.")
  
  print(p)
  
  # Turn off the device i.e. flush to disk  
  if (bToFile == TRUE) dev.off()
  
  # cleanup
  rm(dfBalt, p)
  
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