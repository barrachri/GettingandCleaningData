library(reshape2)

# Read the activity labels and features
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("Index", "Features"))
features[,2] <- as.character(features[,2])

# Extracts only the measurements on the mean and standard deviation for each measurement.
features_wanted <- grep(".*mean.*|.*std.*", features[,2])
features_wanted.names <- features[features_wanted,2]
features_wanted.names = gsub('-mean', 'Mean', features_wanted.names)
features_wanted.names = gsub('-std', 'Std', features_wanted.names)
features_wanted.names <- gsub('[-()]', '', features_wanted.names)

# Load the train ad test dataset
train_x <- read.table("UCI HAR Dataset/train/X_train.txt")[features_wanted]
train_y <- read.table("UCI HAR Dataset/train/y_train.txt")
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train_subjects, train_y, train_x)

test_x <- read.table("UCI HAR Dataset/test/X_test.txt")[features_wanted]
test_y <- read.table("UCI HAR Dataset/test/Y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_subjects, test_y, test_x)

# Merges the training and the test sets and appropriately labels the data set with descriptive variable names.
Data <- rbind(train, test)
colnames(Data) <- c("Subject", "Activity", features_wanted.names)

# Uses descriptive activity names to name the activities in the data set
Data$Activity <- factor(Data$Activity, levels = activity_labels[,1], labels = activity_labels[,2])
Data$Subject <- as.factor(Data$Subject)

Data.melted <- melt(Data, id = c("Subject", "Activity"))
Data.mean <- dcast(Data.melted, Subject + Activity ~ variable, mean)

write.table(Data.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
