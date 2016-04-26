# read training set
x_train <- read.csv("UCI_HAR_Dataset/train/X_train.txt", sep = " ")
y_train <- read.csv("UCI_HAR_Dataset/train/y_train.txt", sep = " ")
subject_train <- read.csv("UCI_HAR_Dataset/train/subject_train.txt", sep = " ")

# read test set
x_test <- read.csv("UCI_HAR_Dataset/test/X_test.txt", sep = " ")
y_test <- read.csv("UCI_HAR_Dataset/test/y_test.txt", sep = " ")
subject_test <- read.csv("UCI_HAR_Dataset/test/subject_test.txt", sep = " ")

# merge training and test sets
features <- read.table("UCI_HAR_Dataset/features.txt")
x_train <- subset(x_train, select = c(1 : length(features[, 2])))
colnames(x_train) <- c(1 : length(features[, 2]))
x_test <- subset(x_test, select = c(1 : length(features[, 2])))
colnames(x_test) <- c(1 : length(features[, 2]))
x_total <- rbind(x_train, x_test)

# generate mean and standard deviation for each column
total_means <- sapply(x_total, function(x) mean(x, na.rm = TRUE))
total_sds <- sapply(x_total, function(x) sd(x, na.rm = TRUE))
total_stats <- rbind(total_means, total_sds)

# swap rows and columns
tidy_df <- data.frame(t(total_stats))
colnames(tidy_df) <- c("Mean", "Standard_Deviation")

# save data to file
write.table(tidy_df, file = "project_tidy_data.txt", append = FALSE, quote = TRUE, sep = " ", eol = "\n", na = "NA", dec = ".", row.names = FALSE, col.names = TRUE, qmethod = c("escape", "double"), fileEncoding = "")
