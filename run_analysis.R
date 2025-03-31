rm(list=ls())

library(dplyr)

# Read in Data 

x_test <- read.table("C:/Users/sae_y/Box/R_explore/UCI HAR Dataset/test/X_test.txt")
x_train <- read.table("C:/Users/sae_y/Box/R_explore/UCI HAR Dataset/train/X_train.txt")
subject_test <- read.table("C:/Users/sae_y/Box/R_explore/UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("C:/Users/sae_y/Box/R_explore/UCI HAR Dataset/train/subject_train.txt")
y_test <- read.table("C:/Users/sae_y/Box/R_explore/UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("C:/Users/sae_y/Box/R_explore/UCI HAR Dataset/train/y_train.txt")
features <- read.table("C:/Users/sae_y/Box/R_explore/UCI HAR Dataset/features.txt")
activitylabel <-read.table("C:/Users/sae_y/Box/R_explore/UCI HAR Dataset/activity_labels.txt")

# Rename columns with proper variable names

col_names=features$V2
names(x_test) <- col_names
names(x_train) <- col_names
names(subject_test) <- "subjectid"
names(subject_train) <- "subjectid"
names(y_test) <- "activityid"
names(y_train) <- "activityid"
names(activitylabel) <- c("activityid", "activitydescript")


# Bind the data together 
train_set <- cbind(subject_train, y_train, x_train)
test_set <- cbind(subject_test, y_test, x_test)
all_set <- rbind(train_set, test_set)

# extract columns with mean() and std()
x1 <- grep("mean()", names(all_set)) 
x2 <- grep("std()", names(all_set))

# note we want to keep 1st and 2nd columns because they are subject and activity ids.
extract_all0 <-select(all_set, c(1,2,all_of(x1), all_of(x2)))

# apply descriptive activity name to activities in dataset
extract_all <- merge(extract_all0, activitylabel, by= "activityid")

# create the tidy dataset
tidyset <- extract_all  %>%
  group_by(subjectid, activityid, activitydescript) %>%
  summarise_all(mean)

write.table(tidyset, "tidyset.txt", row.names = FALSE)


