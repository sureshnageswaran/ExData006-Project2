
source("checkAndDownload.r") # Contains code to download the files in case absent

library(plyr) # For join(), which is faster than merge() for the size of the dataframe
library(ggplot2) # For qplot()

# Function : plot6
# Author   : Suresh Nageswaran
# Input    : Path to the dataset, 
#            Data frame with the NEI dataset if available
#            Data frame with the SCC dataset if available
#            Boolean flag indicating if the output should go to a file
# Output   : File plot6.png with the output plot
# Dependencies : checkAndDownload.r
# How to invoke: On command line, simply type > plot6() 

plot6 <- function(sPath="C:/projects/rwork/exdata006/project2", dfNEI="", dfSCC="", bToFile = TRUE)
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
      # Question: [6]
      # 
      # Compare emissions from motor vehicle sources in Baltimore City
      # with emissions from motor vehicle sources in Los Angeles County,
      # California (fips == "06037").
      # Which city has seen greater changes over time in 
      # motor vehicle emissions?
      #
      # Answer:
      # 
      # Approach: 
      # Output is seen in plot6.png
  # ------------------------------------------------------------------# 
  
  # First combine the two dataframes on SCC
  library(plyr) # For join(), which is faster than merge() for this size
  
  print("Joining dataframes ...")
  # Left inner join
  dfMerged <- join(dfNEI, dfSCC, by="SCC", type="left")
  
  # Emission sources are in the column "EI.Sector" in dfSCC
  vSources <- as.vector(unique(dfSCC$EI.Sector))

  # subset it to recover only the items that are motor vehicle sources
  vSources <- vSources[grep("vehicles",vSources, ignore.case=TRUE)]

  print("Running subset operation on dataframe ...")
  # Subset the merged data to retain only the records with motor vehicle sources i n Baltimore
  dfMerged <- subset(dfMerged, dfMerged$EI.Sector %in% vSources & (fips == "24510" | fips == "06037"), select = c(year, fips, Emissions))  
  
  # Aggregate (using sum) the Emissions column over the indexes year and fips
  dfAns <- aggregate(dfMerged[,3],by=list(dfMerged$year,dfMerged$fips), sum)
  
  # Rename the columns of the resulting dataframe
  colnames(dfAns) <- c("Year", "Fips", "Emissions")
  
  # Get the difference between emissions for the first and last year
  iLADiff  <- round(subset(dfAns, Year==max(unique(dfAns$Year)) & Fips=="06037", select=c(Emissions))-subset(dfAns, Year==min(unique(dfAns$Year)) & Fips=="06037", select=c(Emissions)))
  iBalDiff <- round(subset(dfAns, Year==max(unique(dfAns$Year)) & Fips=="24510", select=c(Emissions))-subset(dfAns, Year==min(unique(dfAns$Year)) & Fips=="24510", select=c(Emissions)))
  
  # Construct the sentence
  sText <- paste(paste(paste("Emissions from motor vehicle sources \nin LA County increased by", iLADiff), "\nwhile emissions in Baltimore decreased by"), iBalDiff)
  
  
  print("Creating plot on disk ...")
  if (bToFile == TRUE)
  {
    # Initialize the PNG device
    png(filename=paste(sPath, "/plot6.png", sep=""), width=1000, height=480)
  }
    
  # Create the plot and annonate it
  p <- ggplot(data=dfAns, aes(x=Year, y=Emissions, group=Fips, shape=Fips)) + 
  geom_line() + geom_point() +
  scale_shape_discrete(name  ="Location", breaks=c("06037", "24510"),labels=c("LA County", "Baltimore")) +
  geom_text(aes(label=round(Emissions)),hjust=0, vjust=1) +
  annotate("text", x = 2004, y = 2000, label = sText)  
 
  print(p)
  
  # Turn off the device i.e. flush to disk  
  if (bToFile == TRUE) dev.off()
  
  print("Cleanup in progress ...")
  # cleanup
  rm(dfMerged, vSources, dfAns, iLADiff, iBalDiff, sText, p) 
  
  print("Complete.")
  return (TRUE)
  
 }