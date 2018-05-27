## Load column names & filter mean and standard dev column names
column_names <- read.table("features.txt")
column_indexes      <- grep("mean|std", column_names[,2])
activity_labels     <- read.table("activity_labels.txt")

## Load subject files
subject_test    <- read.table("test/subject_test.txt")
subject_train   <- read.table("train/subject_train.txt")

## Naming the subject datesets
names(subject_test)     <- c("subjectno")
names(subject_train)    <- c("subjectno")

## Load X files
x_test      <- read.table("test/X_test.txt")
x_train     <- read.table("train/X_train.txt")

## Get columns with mean and std
x_test      <- x_test[,column_indexes]
x_train     <- x_train[,column_indexes]

## Labels for X dataset
names(x_test)       <- column_names[column_indexes,2]
names(x_train)      <- column_names[column_indexes,2]

## Load Y files
y_test      <- read.table("test/y_test.txt")
y_train     <- read.table("train/y_train.txt")

## Merge y datasets (train and test) with activity labels
y_test      <- merge(activity_labels, y_test)
y_train     <- merge(activity_labels, y_train)

## labeling Y dataset
names(y_test)       <- c("activity_code", "activity_description")
names(y_train)      <- c("activity_code", "activity_description")

## Data frame from test
test_df     <- data.frame(subject_test, y_test, x_test)
## Create data frame from train data
train_df    <- data.frame(subject_train, y_train, x_train)

## Combine into one
dataset <- rbind(test_df, train_df)

## Split dataset by subject and acvitity
splitDS <- split(dataset, list(dataset$subjectno, dataset$activity_code), drop=TRUE)

## Calculate column means (only to certain columns) and transpose
colmeans <- data.frame(t(sapply(splitDS, function(x) colMeans(x[, 4:82], na.rm=TRUE))))

## Get row.names
subject.activity <- row.names(colmeans)
## Delete row.names column
row.names(colmeans)<- NULL
## Create new subject.activity column
colmeans<- cbind(subject.activity, colmeans)

## Tidy data
write.table(dataset, file="dataset1.txt", row.names = FALSE)
write.table(colmeans, file="dataset2.txt", row.names = FALSE)