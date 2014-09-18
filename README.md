ExData006-Project2
==================

#Overview
Fine particulate matter analysis project. Part of Coursera's ExData 006 course.

##Project Goal
The overall goal of this assignment is to explore the National Emissions Inventory database and see what it says about fine particulate matter pollution in the United states over the 10-year period 1999–2008.

## Key Questions
The following questions were posed as part of the assignment -

1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.

3. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.

4. Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

5. How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

6. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?
 
#Delivered Code, Data and Output Files

### List of All Delivered Files

| No. | File Name | File Type | Function Contained | Description |
| ------------- | ------------- |------------- |------------- |------------- |
| 1.   |  RunAll.r           | Code       | RunAll()           |The purpose is to invoke all the other code in one go. |
| 2.   | Content Cell  | Code       | checkAndDownload() |Used internally by all other files to check if the data files are available in the path.
| 3.   |  Plot1.r           | Code       | Plot1()            | Produces the first plot.                              |
| 4.   |  Plot2.r           | Code       | Plot2()            | Produces the second plot.                             |
| 5.   |  Plot3.r           | Code       | Plot3()            | Produces the third plot.                              |
| 6.   |  Plot4.r           | Code       | Plot4()            | Produces the fourth plot.                             |
| 7.   |  Plot5.r           | Code       | Plot5()            | Produces the fifth plot.                              |
| 8.   |  Plot6.r           | Code       | Plot6()            | Produces the sixth plot.                              |
| 9.   |  Plot1.png         | Image      | -NA-               | Output from running Plot1()                           |
| 10.  |  Plot2.png         | Image      | -NA-               | Output from running Plot1()                           |
| 11.  |  Plot3.png         | Image      | -NA-               | Output from running Plot1()                           |
| 12.  |  Plot4.png         | Image      | -NA-               | Output from running Plot1()                           |
| 13.  |  Plot5.png         | Image      | -NA-               | Output from running Plot1()                           |
| 14.  |  Plot6.png         | Image      | -NA-               | Output from running Plot1()                           |
| 15.  | summarySCC_PM25.rds | Data       | -NA-               | Data downloaded from course website - Input           |
| 16.  | SourceClassificationCode.rds | Data       | -NA-   | Data downloaded from course website - Input           |


### How to Run

1. For your convenience, a RunAll() function has been provided in the RunAll.r file. 

2. The RunAll() function will automatically download the required data, read in the input dataframes exactly once and run all the plotting functions one after another. This is faster than invoking each individual function. 
   * This can be run at the R command line like so:
   * > RunAll()

3. The plotting functions can also be invoked with parameters that reduce the memory used and time consumed. These parameters are:
   * Path to the input data files - this is also the path used as the working directory and where the output is generated.
   * dfNEI - a dataframe containing the NEI data (from summarySCC_PM25.rds)
   * dfSCC - a dataframe containing the SCC data (from SourceClassificationCode.rds)
   * Boolean (True/False) - This flag tells the code to either write to disk or simply plot to the screen. True: Disk
   * e.g.
   *         > dfNEI <- readRDS("summarySCC_PM25.rds")
   *         > dfSCC <- readRDS("Source_Classification_Code.rds")
   *         > plot1("c:/temp", dfNEI, dfSCC, TRUE)
   
4. All the plotting functions can be invoked at the R command line without any parameters like so: 
```
> plot1()
> plot2()
...
> plot6()
```
### Additional Notes
1. All files have detailed comments explaining the approach taken.
2. Some of the questions required base plotting (plots 1,2) and the others have used qplot (from ggplot2).

### Viewing the Output
1. The output is generated as PNG files (1000 x 480).
2. These files contain the graphic output of the code as well as text annotations about the nature of the conclusions reached.


Thanks for reading! Please be sure to leave explanatory comments in your peer review. I'd love to hear your view.
-Suresh 
