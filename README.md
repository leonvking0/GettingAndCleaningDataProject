Data Cleanning Project
======================

## Instructions on running the script
1. copy run_analysis.R and the unzipped [dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip ) into your working directory of R
2. run run_analysis.R

## Below gives step by step details on the analysis and data cleaning of run_analysis.R
Extract feature names

```r
features <- read.table("features.txt", colClasses = "character")
head(features, 3)
```

```
##   V1                V2
## 1  1 tBodyAcc-mean()-X
## 2  2 tBodyAcc-mean()-Y
## 3  3 tBodyAcc-mean()-Z
```


```r
features <- features[,2]
features <- c("subject_ID", features, "activity")
```

Read in test and training data

```r
test <- read.table("./test/X_test.txt")
test <- cbind(read.table("./test/subject_test.txt"), test)
test <- cbind(test, read.table("./test/y_test.txt"))
colnames(test) <- features

train <- read.table("./train/X_train.txt")
train <- cbind(read.table("./train/subject_train.txt"), train)
train <- cbind(train, read.table("./train/y_train.txt"))
colnames(train) <- features
```

Merge the two datasets

```r
mergedData <- rbind(test,train)
dim(mergedData)
```

```
## [1] 10299   563
```

Extract only the measurements on the mean and std for each measurement

```r
mergedData <- mergedData[, c(1, grep("mean|std", features), ncol(mergedData))]
```

Read in descriptive activity names

```r
activity_labels <- read.table("activity_labels.txt", colClasses = "character")
activity_labels
```

```
##   V1                 V2
## 1  1            WALKING
## 2  2   WALKING_UPSTAIRS
## 3  3 WALKING_DOWNSTAIRS
## 4  4            SITTING
## 5  5           STANDING
## 6  6             LAYING
```

Replace activity id with descriptive activity names

```r
for(i in 1:nrow(activity_labels)) {
        mergedData$activity[mergedData$activity == activity_labels[i,1]] <- activity_labels[i,2]
}
```


```r
dim(mergedData)
```

```
## [1] 10299    81
```


Creates a data set with the average of each variable for each activity and each subject

```r
summary <- aggregate(mergedData[2:80], 
                     by = list(subject_ID = mergedData$subject_ID, activity = mergedData$activity), mean)
```

Write the tidy data into text file

```r
write.table(summary, file = "tidy_data.txt", row.name=FALSE) 
```




