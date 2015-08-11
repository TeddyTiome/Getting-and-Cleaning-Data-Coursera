#First, download and unzip the raw data (I have not done in my R script).

#Read the data, the paths in my command may vary in yours.
test.y <- read.table("~/Desktop/UCI HAR Dataset/test/y_test.txt", col.names="y")
test.subjects <- read.table("~/Desktop/UCI HAR Dataset/test/subject_test.txt", col.names="subject")
test.X <- read.table("~/Desktop/UCI HAR Dataset/test/X_test.txt")
train.y <- read.table("~/Desktop/UCI HAR Dataset/train/y_train.txt", col.names="y")
train.subjects <- read.table("~/Desktop/UCI HAR Dataset/train/subject_train.txt", col.names="subject")
train.X <- read.table("~/Desktop/UCI HAR Dataset/train/X_train.txt")

##Step 1: Merges the training and the test sets to create one data set.
raw.data <- rbind(cbind(test.subjects, test.y, test.X),
              cbind(train.subjects, train.y, train.X))

#Specific the features (only mean and std) and labels, then extract selected data.
features <- read.table("~/Desktop/UCI HAR Dataset/features.txt", quote="\"")[,2]
names(test.X) <- features
names(train.X) <- features

##Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.
features.mean_std <- grepl("mean|std", features)
tidy.test.X <- test.X[,features.mean_std]
tidy.train.X <- train.X[,features.mean_std]

##Step 3: Uses descriptive activity names to name the activities in the data set
labels <- read.table("~/Desktop/UCI HAR Dataset/activity_labels.txt", quote="\"")[,2]
test.y[,2] <- labels[test.y[,1]]
train.y[,2] <- labels[train.y[,1]]
names(test.y) <- c("ID", "Label")
names(train.y) <- c("ID", "Label")

#Create and bind the selected test and train data.
##Step 4: Appropriately labels the data set with descriptive variable names. 
test.data <- cbind(test.subjects, test.y, tidy.test.X)
train.data <- cbind(train.subjects, train.y, tidy.train.X)
tidy.data <- rbind(test.data, train.data)

##Step 5: From the data set in step 4, creates a second, 
##independent tidy data set with the average of each variable for each activity and each subject.
group.aver.data <- aggregate(tidy.data[, 4:82],
                       by=list(subject = tidy.data[,1], 
                               label = tidy.data[,3]),
                       mean)
write.table(group.aver.data, file = "~/Desktop/step5data.txt",row.name=FALSE)
