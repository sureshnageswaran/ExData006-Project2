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