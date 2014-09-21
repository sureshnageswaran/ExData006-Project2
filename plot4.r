# Please visit https://github.com/sureshnageswaran/ExData006-Project2
# View this readme file before using the code
# https://github.com/sureshnageswaran/ExData006-Project2/blob/master/README.md

# The source file mentioned below is no longer needed, since the function has been appended to the end of this code file.
#source("checkAndDownload.r") # Contains code to download the files in case absent

library(plyr) # For join(), which is faster than merge() for the size of the dataframe
library(ggplot2) # For qplot()

# Function : plot4
# Author   : Suresh Nageswaran
# Input    : Path to the dataset, 
#            Data frame with the NEI dataset if available
#            Data frame with the SCC dataset if available
#            Boolean flag indicating if the output should go to a file
# Output   : File plot4.png with the output plot
# Dependencies : checkAndDownload.r
# How to invoke: On command line, simply type > plot4() 

plot4 <- function(sPath="C:/projects/rwork/exdata006/project2/ExData006-Project2", dfNEI="", dfSCC="", bToFile = TRUE)
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
    # ------------------------------------------------------------------#
      # Question: [4]
      # 
      # Across the United States, how have emissions from coal 
      # combustion-related sources changed from 1999- 2008?
      #
      # Answer:
      # Plotting emissions vs year for coal-combustion sources with one
      # smoothly fitted line for each type will show the change.
      # Annotations will be added to the graph to call out the change.
      # 
      # Approach: 
      # Output is seen in plot4.png
  # ------------------------------------------------------------------# 
  
  # First combine the two dataframes on SCC
  library(plyr) # For join(), which is faster than merge() for this size
  
  print("Running join operation on dataframe...")  
  
  # Left inner join
  dfMerged <- join(dfNEI, dfSCC, by="SCC", type="left")
  
  # Emission sources are in the column "EI.Sector" in dfSCC
  vSources <- as.vector(unique(dfSCC$EI.Sector))
  # subset it to recover only the items that are coal sources
  vSources <- vSources[grep("Coal",vSources, ignore.case=TRUE)]
  
  # Emissions sources that are coal-based are also in SCC.Level.Three in dfSCC
  vSources1 <- as.vector(unique(dfSCC$SCC.Level.Three))
  # Subset it to recover only the items that are coal sources
  vSources1 <- vSources1[grep("Coal", vSources1, ignore.case=TRUE)]
  
  print("Running subset operation on dataframe...")  
  # Subset the merged data to retain only the records with coal sources  
  dfMerged <- subset(dfMerged, ((dfMerged$EI.Sector %in% vSources) | (dfMerged$SCC.Level.Three %in% vSources1)))
  
  # dfMerged <- subset(dfMerged, dfMerged$EI.Sector %in% vSources)  
  
  # tapply the 'sum' function on the merged dataset along the index year
  dfMerged <- tapply(dfMerged$Emissions, dfMerged$year, sum)
  
  # Create the final dataframe in the form you need
  dfMerged <- data.frame(cbind(Year=as.numeric(rownames(dfMerged)),Emissions=as.numeric(dfMerged[1:4])))
  
  print("Creating plot on disk...")  
  if (bToFile == TRUE)
  {
    # Initialize the PNG device
    png(filename=paste(sPath, "/plot4.png", sep=""), width=1000, height=480)
  }
  
  # Compute the decrease
  iDiff <- round(max(dfMerged[,"Emissions"]) - min(dfMerged[,"Emissions"]))
  sLabel <- paste("Emissions from coal-combustion sources declined by ", iDiff,sep="")
  
  # Compute the % decrease as well
  iPer <- round (iDiff / dfMerged$Emissions[dfMerged$Year == min(dfMerged$Year)] * 100, digits=2)
  sLabel <- paste(sLabel, ".\nThis is a decrease of ", sep="")
  sLabel <- paste(sLabel, iPer, sep="")
  sLabel <- paste(sLabel, "%.", sep="")
  
  #Create the plot  
  p <- qplot(Year, Emissions/1000, data=dfMerged,  geom=c("point", "smooth"), ylab = "Emissions from coal (in 1000s)") + 
  geom_text(aes(label=round(dfMerged$Emissions)),hjust=0, vjust=1) +
  annotate("text", x = 2004, y = 500, label = sLabel)+
  ggtitle("Coal-Combustion Emissions across the US (1998-2008)")
  
  print(p)
  
  # Turn off the device i.e. flush to disk  
  if (bToFile == TRUE) dev.off()
    
  # cleanup
  rm(dfMerged, vSources, p)
  
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