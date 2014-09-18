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

### List of Code Files

No. | File Name          | Function Contained | Description                                          |
--- | -------------------|--------------------|------------------------------------------------------|
1.  | RunAll.r           | RunAll()           |The purpose is to invoke all the other code in one go.|
2.  | checkAndDownload.r | checkAndDownload() |Used internally by all other files to check if the data files are available in the path.   |
3.  | Plot1.r            | Plot1()            |Produces the first plot.                              |
4.  | Plot2.r            | Plot2()            |Produces the second plot.                             |
5.  | Plot3.r            | Plot3()            |Produces the third plot.                              |
6.  | Plot4.r            | Plot4()            |Produces the fourth plot.                             |
7.  | Plot5.r            | Plot5()            |Produces the fifth plot.                              |
8.  | Plot6.r            | Plot6()            |Produces the sixth plot.                              |

### Invocation
