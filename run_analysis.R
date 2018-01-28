##### GETTING AND CLEANING DATA PROJECT #######
setwd("/Users/marlonvinan/Documents/Doctorado/Getting_and_cleaning_data_course/")
library(reshape2)
filename <- "getdata_dataset.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

# load activity labels
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
str(activityLabels)
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
str(features)
features[,2] <- as.character(features[,2])

# Load the train dataset
train <- read.table("UCI HAR Dataset/train/X_train.txt")
str(train)
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
str(trainActivities)
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
str(trainSubjects)
train <- cbind(trainSubjects, trainActivities, train)

# Load test dataset

test <- read.table("UCI HAR Dataset/test/X_test.txt")
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# extract only mean and standard deviation for train and test

featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

train <- train[featuresWanted]
test <- test[featuresWanted]

ha <- rbind(train, test)
colnames(ha) <- c("subject", "activity", featuresWanted.names[3:79])

## turn activity and subject as factor 

ha$activity <- factor(ha$activity, levels = activityLabels[,1], 
                           labels = activityLabels[,2])
ha$subject <- factor(ha$subject)

library(dplyr)

haMeans <- ha %>%
            group_by(subject, activity) %>%
            summarise_all(funs(mean))

write.table(haMeans, "tidy.txt", row.names = FALSE, quote = FALSE)

