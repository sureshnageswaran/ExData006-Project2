# Please visit https://github.com/sureshnageswaran/ExData006-Project2
# View this readme file before using the code
# https://github.com/sureshnageswaran/ExData006-Project2/blob/master/README.md

# The source file mentioned below is no longer needed, since the function has been appended to the end of this code file.
#source("checkAndDownload.r") # Contains code to download the files in case absent

library(plyr)      # For join(), which is faster than merge() for the size of the dataframe
library(ggplot2)   # For qplot()


# Function : plot5
# Author   : Suresh Nageswaran
# Input    : Path to the dataset, 
#            Data frame with the NEI dataset if available
#            Data frame with the SCC dataset if available
#            Boolean flag indicating if the output should go to a file
# Output   : File plot5.png with the output plot
# Dependencies : checkAndDownload.r
# How to invoke: On command line, simply type > plot5() 

plot5 <- function(sPath="C:/projects/rwork/exdata006/project2/ExData006-Project2", dfNEI="", dfSCC="", bToFile = TRUE)
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
  
  # Emission sources are also in SCC.Level.Two and SCC.Level.Three
  
  vSources2 <- as.vector(unique(dfSCC$SCC.Level.Two))
  vSources3 <- as.vector(unique(dfSCC$SCC.Level.Three))
  
  print("Running subset operation on dataframe ...")  
  
  # subset it to recover only the items that are motor vehicle sources
  vSources  <- vSources [grep("vehicle",vSources,  ignore.case=TRUE)]
  vSources2 <- vSources2[grep("vehicle",vSources2, ignore.case=TRUE)]
  vSources3 <- vSources3[grep("vehicle",vSources3, ignore.case=TRUE)]

  # Subset the merged data to retain only the records with motor vehicle sources in Baltimore
  dfMerged <- subset(dfMerged, ((dfMerged$EI.Sector %in% vSources) | (dfMerged$SCC.Level.Two %in% vSources2) | (dfMerged$SCC.Level.Three %in% vSources3)) & (fips == "24510") )
  
  # tapply the 'sum' function on the merged dataset along the index year
  dfMerged <- tapply(dfMerged$Emissions, dfMerged$year, sum)

  # Create the final dataframe in the form you need
  dfMerged <- data.frame(cbind(Year=as.numeric(rownames(dfMerged)),Emissions=as.numeric(dfMerged[1:4])))

  # Add an incremental % change column
  PerChange <- as.vector(1: nrow(dfMerged))  
  for(i in 1:nrow(dfMerged)) 
  { 
  	if (i == 1) 
  		PerChange[i]=0 
  	else 
  		PerChange[i] <- ((dfMerged$Emissions[i]-dfMerged$Emissions[i-1])/dfMerged$Emissions[i-1])*-1*100 
  }
  
  # Bind this new col into the dataframe
  dfMerged <- cbind(dfMerged, PerChange)
    
  print("Creating plot on disk ...")  
  
  if (bToFile == TRUE)
  {
    # Initialize the PNG device
    png(filename=paste(sPath, "/plot5.png", sep=""), width=1000, height=480)
  }
  
  # Compute the decrease
  iDiff <- round(max(dfMerged[,"Emissions"]) - min(dfMerged[,"Emissions"]))
  sLabel <- paste(paste("Emissions from motor vehicles in Baltimore from 1998-2008\n declined by", iDiff, sep=" "), ".\n", sep="")
  
  # Compute the total % decrease as well
  iPer <- round(((dfMerged$Emissions[dfMerged$Year == max(dfMerged$Year)] - dfMerged$Emissions[dfMerged$Year == min(dfMerged$Year)])/dfMerged$Emissions[dfMerged$Year == min(dfMerged$Year)] )*-1*100, digits=2)  
  #iPer <- round (dfMerged$Emissions[dfMerged$Year == max(dfMerged$Year)] / dfMerged$Emissions[dfMerged$Year == min(dfMerged$Year)] * 100, digits=2)
  sLabel <- paste(sLabel, "This is a total decrease of ", sep="")
  sLabel <- paste(sLabel, iPer, sep="")
  sLabel <- paste(sLabel, "%.", sep="")
   
  #Create the first plot  
  p1 <- qplot(Year, Emissions, data=dfMerged,  geom=c("point", "smooth"), ylab = "Emissions from motor vehicles in Baltimore") + 
  geom_text(aes(label=round(dfMerged$Emissions)),hjust=0, vjust=1) +
  annotate("text", x = 2004, y = 350, label = sLabel) +
  ggtitle("Overall Emissions from motor vehicles for Baltimore")
   
  #print(p)
  
  #Create the second plot to show incremental % changes
  p2 <- qplot(Year, PerChange, data=dfMerged,  geom=c("point", "smooth"), ylab = "Y-on-Y % changes in emissions") + 
    geom_text(aes(label=round(dfMerged$PerChange)),hjust=0, vjust=1) +
    annotate("text", x = 2004, y = 150, label = "The changes indicate a decline in emissions.") +
    ggtitle("Y-o-Y % changes - motor vehicle emissions for Baltimore")
    
  # Print the plots
  multiplot(p1, p2, cols=2)
  
  # Turn off the device i.e. flush to disk  
  if (bToFile == TRUE) dev.off()
  
  # cleanup
  rm(dfMerged, vSources, p, sLabel, iDiff)
  
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

# Multiple plot function
# 
#
# Note: This code was downloaded from 
# http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  require(grid)

  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)

  numPlots = length(plots)

  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                    ncol = cols, nrow = ceiling(numPlots/cols))
  }

 if (numPlots==1) {
    print(plots[[1]])

  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))

    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))

      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}