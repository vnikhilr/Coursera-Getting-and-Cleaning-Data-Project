# Getting and Cleaning Data Course Project
# File name: run_analysis.R
# Nikhil Reddy

# Setting working directory

setwd("C:/Users/getti_000/Documents/Coursera Assignment Data/UCI HAR Dataset")

######### Steps common to Test and Training Data #######

# loading list of features
list_of_features <- read.table("features.txt")

# Loading activity labels. Activity labels Links the class labels with their 
# activity name
activity_labels <- read.table("activity_labels.txt")

# Assigning column names to activity labels data fram
colnames(activity_labels) <-c("Activity", "Activity_Name")

############# Transforming and Merging Test Data ##############################

# loading test data from files in working directory
x_test_data <- read.table("./test/X_test.txt")
y_test_data <- read.table("./test/y_test.txt", col.names = c("Activity"))
subject_test_data <- read.table("./test/subject_test.txt")

# list of features as colum labels for test data
colnames(x_test_data) <- list_of_features[,2]
colnames(subject_test_data) <- "Subject"

# Using cbind to combine y_test_data, x_test_data and subject_test_data
test_data <- cbind(subject_test_data, y_test_data, x_test_data)

############# Transforming and Merging Training Data ########################## 

# loading training data from files in working directory
x_train_data <- read.table("./train/X_train.txt")
y_train_data <- read.table("./train/y_train.txt", col.names = c("Activity"))
subject_train_data <- read.table("./train/subject_train.txt")

# list of features as colum labels for trainin data
colnames(x_train_data) <- list_of_features[,2]
colnames(subject_train_data) <- "Subject"

# Using cbind to combine y_train_data, x_train_data and subject_train_data
train_data <- cbind(subject_train_data, y_train_data, x_train_data)

###############################################################################

# Combining Test and Training Data 

combined_data <- rbind(train_data, test_data)

# Creating a filter to select only the measurements on the mean and standard
# deviation for each measurement.
# As per features_info.txt file: mean()= Mean value; std()= Standard deviation
# ASSUMPTION: only varaibles names with mean() or std() contain mean / std dev value
# and hence ignoring variable names containing meanFreq for this assignment


names_vector <- names(combined_data)

columns_filter <- c(grep("Activity", names_vector),grep("Subject", names_vector), 
                    grep("mean[()]", names_vector),grep("std[()]", names_vector))

# Filtering out variables which do not contain mean()/std() in variable names and
# Keeping variables "Activity" and "Subject"

narrow_data <- combined_data[,columns_filter]

# Adding Activity Names, new colume Activity_Name will be added
narrow_data <- merge(narrow_data,activity_labels,by.x = "Activity")

# Rearranging columns to bring Activity_Name to front and remove activity as it 
# is redundant
narrow_data <- narrow_data[,c(69,1:68)]
narrow_data <- narrow_data[,-2]

# creating an independent tidy data set with the average of each variable for 
# each activity and each subject.

# Loading dplyr package for summarizing grouping and finding mean of all coluns
library(dplyr)

my_tidy_dataset <- data.frame(summarise_all(group_by(narrow_data, Activity_Name, 
                                                     Subject),mean))

# THe final step, sstoring my tidy dataset in txt file
write.table(my_tidy_dataset, "my_tidy_dataset.txt", row.name=FALSE)




