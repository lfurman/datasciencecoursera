# In terminal:
# 1. Install homebrew:
# ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# 2. Give permission to root to run brew install
# sudo chown root /usr/local/bin/brew
# 3. Install MySQL
# sudo brew install mysql

# In RStudio:
# install packages
install.packages("DBI")
install.packages("RMySQL", type = "source")

# set environment variables
Sys.setenv(PKG_CPPFLAGS = "-I/usr/local/include/mysql")
Sys.setenv(PKG_LIBS = "-L/usr/local/lib -lmysqlclient")

# load libraries
library(DBI)
library(RMySQL)

# connect to database
ucscDb <- dbConnect(MySQL(), user = "genome", host = "genome-mysql.cse.ucsc.edu")

# run query
result <- dbGetQuery(ucscDb, "show databases"); dbDisconnect(ucscDb);

# Listing tables
hg19 <- dbConnect(MySQL(), user = "genome", db = "hg19", host = "genome-mysql.cse.ucsc.edu")
allTables <- dbListTables(hg19)
length(allTables)
allTables[1:5]

# Read data
affyData <- dbReadTable(hg19, "affyU133Plus2")
head(affyData)
dbDisconnect(hg19)

# HDF5 file format
source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")
library(rhdf5)
created <- h5createFile("example.h5")
created
