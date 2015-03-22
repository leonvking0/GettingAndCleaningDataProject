## Extract feature names
features <- read.table("features.txt", colClasses = "character")
features <- features[,2]
features <- c("subject_ID", features, "activity")

## Read in test and training data
test <- read.table("./test/X_test.txt")
test <- cbind(read.table("./test/subject_test.txt"), test)
test <- cbind(test, read.table("./test/y_test.txt"))
colnames(test) <- features

train <- read.table("./train/X_train.txt")
train <- cbind(read.table("./train/subject_train.txt"), train)
train <- cbind(train, read.table("./train/y_train.txt"))
colnames(train) <- features

## Merge the two datasets
mergedData <- rbind(test,train)

## Extract only the measurements on the mean and std for each measurement
mergedData <- mergedData[, c(1, grep("mean|std", features), ncol(mergedData))]

## Read in descriptive activity names
activity_labels <- read.table("activity_labels.txt", colClasses = "character")

## Replace activity id with descriptive activity names
for(i in 1:nrow(activity_labels)) {
        mergedData$activity[mergedData$activity == activity_labels[i,1]] <- activity_labels[i,2]
}

## Creates a data set with the average of each variable for each activity and each subject
summary <- aggregate(mergedData[2:80], 
                     by = list(subject_ID = mergedData$subject_ID, 
                               activity = mergedData$activity), mean)

## Write the tidy data into text file
write.table(summary, file = "tidy_data.txt", row.name=FALSE)