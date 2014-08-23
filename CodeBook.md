---
title: "CodeBook"
author: "Diego Gaona"
date: "Saturday, August 23, 2014"
output: html_document
---

This is the codebook requested with the data to indicate all the variables and summariescalculated, along with units, and any other relevant information

# Input Data

After perform the transformations the new dataset was generated in the working directory `tidy_data.txt`. See the [README.md](README.md) which details the steps.

If you have any questions about the original dataset, please review the information [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#).

```
For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.
```

# Output Data

It was generated **the average of each of the following variables for each activity and each subject**.

```{r}
tBodyAcc
tGravityAcc
tBodyAccJerk
tBodyGyro
tBodyGyroJerk
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc
fBodyAccJerk
fBodyGyro
fBodyAccMag
fBodyBodyAccJerkMag
fBodyBodyGyroMag
fBodyBodyGyroJerkMag
```

# Transformations

The script, `run_analysis.R`, does the following,

0. Get the data
  + Prepare the directory
  + Download the file and upzip
  + Load the data in the proper R objects
1. Merges the training and the test sets to create one data set.
  + Merging the datasets
  + Adding the column names to each of the variables.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
  + Search the columns that contains the mean and std with grep.
3. Uses descriptive activity names to name the activities in the data set.
  + Replacing the Activity IDs for the names of each activity.
4. Appropriately labels the data set with descriptive variable names.
  + Setting all variables with the proper names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  + Using the package plyr and the functions ddply, sapply and mean to get the desired result.