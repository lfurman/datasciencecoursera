#source("https://github.com/hadley/httr/blob/master/demo/oauth2-github.r")

install.packages("httpuv")
install.packages("sqldf")
install.packages("RCurl")

library(httr)
library(httpuv)
library(sqldf)
library(RCurl)
library(XML)

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")
#myapp <- oauth_endpoint(authorize = "https://github.com/login/oauth/authorize", access = "https://github.com/login/oauth/access_token")

# 2. Register an application at https://github.com/settings/applications;
#    Use any URL you would like for the homepage URL (http://github.com is fine)
#    and http://localhost:1410 as the callback url
#
#    Insert your client ID and secret below - if secret is omitted, it will
#    look it up in the GITHUB_CONSUMER_SECRET environmental variable.
#myapp <- oauth_app("8d5d9814762e1874eac3", "11b449e1e498b15643975cff08bf94ae9f1429a9")
myapp <- oauth_app("github", "8d5d9814762e1874eac3", secret = "11b449e1e498b15643975cff08bf94ae9f1429a9")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/rate_limit", gtoken)
stop_for_status(req)
content(req)

# Question 2
# The sqldf package allows for execution of SQL commands on R data frames. We will use the sqldf package to practice the queries we might send with the dbSendQuery command in RMySQL. Download the American Community Survey data and load it into an R object called
acsURL <- getURL("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv")
acs <- read.csv(textConnection(acsURL))

# Question 4
url <- "http://biostat.jhsph.edu/~jleek/contact.html"
webpage <- getURL(url)
webpage <- readLines(tc <- textConnection(webpage)); close(tc)
c(nchar(webpage[10]), nchar(webpage[20]), nchar(webpage[30]), nchar(webpage[100]))

# Question 5
url = getURL("http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for")
data <- read.csv("data.csv", header = TRUE)
sum(data$SST)
