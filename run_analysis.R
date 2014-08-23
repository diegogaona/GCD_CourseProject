# Getting and Cleaning Data Course Project
#
# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
# The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. 
# You will be required to submit: 
#   1) a tidy data set as described below, 
#   2) a link to a Github repository with your script for performing the analysis, and 
#   3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 
# You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  
# 
# One of the most exciting areas in all of data science right now is wearable computing - see for example  this article . 
# Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. 
# The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 
# A full description is available at the site where the data was obtained: 
#   
#   http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
# 
# Here are the data for the project: 
#   
#   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 
# You should create one R script called run_analysis.R that does the following. 
# 1.Merges the training and the test sets to create one data set.
# 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3.Uses descriptive activity names to name the activities in the data set
# 4.Appropriately labels the data set with descriptive variable names. 
# 5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


# ==========================================================================

## 0.Preparing the data

#create the data directory within the working directory
if(!file.exists("data"))
{
  dir.create("data")
}

# set the URL of the dataset
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 

# download the dataset
download.file(fileUrl, destfile = "data/Dataset.zip")

# upzip
unzip("data/Dataset.zip", exdir="data")


## descriptive labels
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = " ")
features <- read.table("./data/UCI HAR Dataset/features.txt", header = FALSE, sep = " ")

# training data
train.X <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header = FALSE, strip.white = TRUE)
train.y <- read.table("./data/UCI HAR Dataset/train/y_train.txt", header = FALSE)
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", header = FALSE)

# testing data
test.X<-read.table("./data/UCI HAR Dataset/test/X_test.txt", header = FALSE, strip.white = TRUE)
test.y<-read.table("./data/UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_test<-read.table("./data/UCI HAR Dataset/test/subject_test.txt", header = FALSE)

## 1.Merges the training and the test sets to create one data set.

# merging the data
merged.X <- rbind(test.X, train.X)

# setting the column names
colnames(merged.X) <- c(as.character(features[,2]))

## 2.Extracts only the measurements on the mean and standard deviation for each measurement.

# columns that contain 'mean()' and 'std()', 66 in total
columns_to_extract = c(grep("mean()", colnames(merged.X), fixed = TRUE),
                       grep("std()", colnames(merged.X), fixed = TRUE))

# subsetting the data requiered
subset.X = merged.X[,columns_to_extract]

## 3.Uses descriptive activity names to name the activities in the data set

# merging the activity data
merged.y <- rbind(test.y, train.y)

# adding the subset to the activity merged data
merged.y.X <- cbind(merged.y,subset.X)

# naming the activity column
colnames(merged.y.X)[1] <- "Activity"

## 4.Appropriately labels the data set with descriptive variable names. 

# this is needed before to perform the replacement, originally the description of the activity is imported as a factor with six levels
activity_labels$V2<-as.character(activity_labels$V2)

# an iteration to replace the activity numbers for the activity labels
for(i in 1:length(merged.y.X$Activity)){
  merged.y.X$Activity[i]<-activity_labels[merged.y.X$Activity[i],2]
}

## 5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# using the previously dataset in the step 4, it's necesary to add the subjects, take care about to binding in the same order as the previous one, 
# first tests and after the trainings.
merged.subject <- rbind(subject_test, subject_train)

# naming the activity column
colnames(merged.subject)[1] <- "Subject"

# merging all the data
merged.subject.y.X <- cbind(merged.subject, merged.y.X)

# to summarize the data I found some alternatives, using the ddply with sapply over the columns with the data like the following, it's needed to use the package plyr
# use the install.packages("plyr") if you dont have plyr package installed.

library(plyr)
tidy_data <- ddply(merged.subject.y.X, .(Subject, Activity), function(x) sapply(x[3:68], mean)) 

# Write file
write.table(tidy_data, file = "tidy_data.txt", row.names = FALSE)

#load file