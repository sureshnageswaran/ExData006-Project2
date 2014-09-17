
source("checkAndDownload.r") # Contains code to download the files in case absent

library(plyr) # For join(), which is faster than merge() for the size of the dataframe
library(ggplot2) # For qplot()

# Function : plot5
# Author   : Suresh Nageswaran
# Input    : Path to the dataset, 
#            Data frame with the NEI dataset if available
#            Data frame with the SCC dataset if available
#            Boolean flag indicating if the output should go to a file
# Output   : File plot5.png with the output plot
# Dependencies : checkAndDownload.r
# How to invoke: On command line, simply type > plot5() 

plot5 <- function(sPath="C:/projects/rwork/exdata006/project2", dfNEI="", dfSCC="", bToFile = TRUE)
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
    # ------------------------------------------------------------------#
      # Question: [5]
      # 
      # How have emissions from motor vehicle sources changed from
      # 1999-2008 in Baltimore City?
      #
      # Answer:
      # 
      # Approach: 
      # Output is seen in plot5.png
  # ------------------------------------------------------------------# 

  # First combine the two dataframes on SCC
  library(plyr) # For join(), which is faster than merge() for this size
  
  print("Running join operation on dataframe ...")  
  # Left inner join
  dfMerged <- join(dfNEI, dfSCC, by="SCC", type="left")
  
  # Emission sources are in the column "EI.Sector" in dfSCC
  vSources <- as.vector(unique(dfSCC$EI.Sector))
  
  print("Running subset operation on dataframe ...")  
  # subset it to recover only the items that are motor vehicle sources
  vSources <- vSources[grep("vehicles",vSources, ignore.case=TRUE)]

  # Subset the merged data to retain only the records with motor vehicle sources in Baltimore
  dfMerged <- subset(dfMerged, dfMerged$EI.Sector %in% vSources & fips == "24510", select = c(year, EI.Sector, Emissions))
  
  # tapply the 'sum' function on the merged dataset along the index year
  dfMerged <- tapply(dfMerged$Emissions, dfMerged$year, sum)

  # Create the final dataframe in the form you need
  dfMerged <- data.frame(cbind(Year=as.numeric(rownames(dfMerged)),Emissions=as.numeric(dfMerged[1:4])))
  
  print("Creating plot on disk ...")  
  
  if (bToFile == TRUE)
  {
    # Initialize the PNG device
    png(filename=paste(sPath, "/plot5.png", sep=""), width=1000, height=480)
  }
  
  # Compute the decrease
  iDiff <- round(max(dfMerged[,"Emissions"]) - min(dfMerged[,"Emissions"]))
  sLabel <- paste("Emissions from motor vehicles in Baltimore declined by", iDiff)
  
  
  #Create the plot  
  p <- qplot(Year, Emissions, data=dfMerged,  geom=c("point", "smooth"), ylab = "Emissions from motor vehicles in Baltimore") + 
  geom_text(aes(label=round(dfMerged$Emissions)),hjust=0, vjust=1) +
  annotate("text", x = 2004, y = 350, label = sLabel) 
   
  print(p)
  
  # Turn off the device i.e. flush to disk  
  if (bToFile == TRUE) dev.off()
  
  # cleanup
  rm(dfMerged, vSources, p, sLabel, iDiff)
  
  print("Complete.")  
  
  return (TRUE)
  
 }