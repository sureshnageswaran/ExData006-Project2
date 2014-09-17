# Function : checkAndDownload
# Author   : Suresh Nageswaran
# Input    : Path to the dataset, 
# Output   : Boolean
# Dependencies : None
# How to invoke: On command line, simply type > checkAndDownload()
# Purpose  : This function checks if the input files required are present.
#            If absent, they are downloaded into the current folder.

checkAndDownload <- function(sPath="C:/projects/rwork/exdata006/project2")
{
 # List of required files
  files <- c(
            "summarySCC_PM25.rds",           # NEI
            "Source_Classification_Code.rds" # SCC
           )         
 # Check if the files are in the working directory     
  if( !all(file.exists(files)) )
  {    
    # download the files
    temp <- tempfile()
    fileURL <-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(fileURL,temp)
    unzip(temp,files=files)
    file.remove(temp)
    sPath = getwd()
  }
  
  return (TRUE)

}