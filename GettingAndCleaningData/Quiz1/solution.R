# install packages
install.packages("xlsx")
install.packages("XML")
install.packages("RCurl")
install.packages("data.table")

# load libraries
library(xlsx)
library(XML)
library(RCurl)
library(data.table)

# Question 1
# The American Community Survey distributes downloadable data about United States communities.
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here: 
#   
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv 
# 
# and load the data into R. The code book, describing the variable names is here: 
#   
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf 
# 
# How many properties are worth $1,000,000 or more?

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileURL, destfile = "question1.txt", method = "curl")
data <- read.csv("question1.txt", header = TRUE)
nrow(data[which(data$VAL == 24), ])

# Question 2
# Use the data you loaded from Question 1.
# Consider the variable FES in the code book. Which of the "tidy data" principles does this variable violate?

# Answer: Tidy data has one variable per column
# Reference: http://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html

# Question 3
# Download the Excel spreadsheet on Natural Gas Aquisition Program here: 
#   
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx
# 
# Read rows 18-23 and columns 7-15 into R and assign the result to a variable called:
#   dat 
# What is the value of:
#   sum(dat$Zip*dat$Ext,na.rm=T) 
# (original data source: http://catalog.data.gov/dataset/natural-gas-acquisition-program)
#fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
#download.file(fileURL, destfile = "NGAP.xlsx", method = "curl")
file <- "NGAP.xlsx"
dat <- read.xlsx(file, 1, rowIndex = 18:23, colIndex = 7:15, as.data.frame = TRUE, header = TRUE)
sum(dat$Zip * dat$Ext, na.rm = T)
# Answer: 36534720

# Question 4
# Read the XML data on Baltimore restaurants from here: 
#   
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml
# 
# How many restaurants have zipcode 21231?
fileURL <- sub("https", "http", "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml")
data <- xmlTreeParse(getURL(fileURL), useInternalNodes = TRUE)
zipcodes <- xpathSApply(data, "//response/row/row/zipcode", xmlValue)
length(zipcodes[sapply(zipcodes, function(x) x == "21231")])
# Answer: 127

# Question 5
# The American Community Survey distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here: 
#   
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv 
# 
# using the fread() command load the data into an R object
# DT 
# Which of the following is the fastest way to calculate the average value of the variable
# pwgtp15 
# broken down by sex using the data.table package?
# sapply(split(DT$pwgtp15,DT$SEX),mean)
# DT[,mean(pwgtp15),by=SEX]
# tapply(DT$pwgtp15,DT$SEX,mean)
# mean(DT$pwgtp15,by=DT$SEX)
# mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)
# rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]
#fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
#download.file(fileURL, destfile = "question5.csv", method = "curl")
DT <- fread("question5.csv", header = TRUE)
system.time(average <- sapply(split(DT$pwgtp15,DT$SEX),mean)) # eslapsed: 0.001 -> FASTEST!!!
system.time(average <- DT[,mean(pwgtp15),by=SEX]) # elapsed: 0.002
system.time(average <- tapply(DT$pwgtp15,DT$SEX,mean)) # elapsed: 0.002
system.time(average <- mean(DT$pwgtp15,by=DT$SEX)) # elapsed: 0 -> SOMETHING IS FISHY HERE!!!
system.time(average <- mean(DT[DT$SEX==1,]$pwgtp15), mean(DT[DT$SEX==2,]$pwgtp15)) # elapsed: 0.020
system.time(average <- rowMeans(DT)[DT$SEX==1], rowMeans(DT)[DT$SEX==2])
