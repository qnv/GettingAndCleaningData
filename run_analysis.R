### Getting and Cleaning Data ###
### Programming assignemnt    ###
### Date:  2016-12-07
### Author: qnv
### Purpose: Loading UCI HAR Dataset about, merging and reshaping a subset of it
### source of data: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

rm(list=ls())
###-------------------------------------------------------------------------###
### 0 load packages for some data reshaping functions used below (and install if necesary)
###
if(!require(tidyr)){
  install.packages("tidyr")
  library(tidyr)
  }
if(!require(dplyr)){
  install.packages("dplyr")
  library(dplyr)
}

###-------------------------------------------------------------------------###
### 1 read files
###
# general
activity_labels <- read.table("UCI HAR Dataset\\activity_labels.txt",col.names=c("activity_code", "activity_label"))
features <- read.table("UCI HAR Dataset\\features.txt",col.names = c("feat_code","feat_label"))
# train
X_train <- read.table("UCI HAR Dataset\\train\\X_train.txt", col.names = features$feat_label)
y_train <- read.table("UCI HAR Dataset\\train\\y_train.txt",col.names=c("activity_code"))
subject_train <- read.table("UCI HAR Dataset\\train\\subject_train.txt",col.names=c("subject"))
X_train$source_file <- "train"
# test
X_test <- read.table("UCI HAR Dataset\\test\\X_test.txt", col.names = features$feat_label)
y_test <- read.table("UCI HAR Dataset\\test\\y_test.txt",col.names=c("activity_code"))
subject_test <- read.table("UCI HAR Dataset\\test\\subject_test.txt",col.names=c("subject"))
X_test$source_file <- "train"

###-------------------------------------------------------------------------###
### 2 merge everything
###
# columns
df_train <- cbind(y_train, subject_train, X_train)
df_test <- cbind(y_test, subject_test, X_test)
# rows
df_stacked <- rbind(df_train,df_test)

###-------------------------------------------------------------------------###
### 3 create table as described in assignment
###
# select mean and standard deviation fields only
df_main <- select(df_stacked, c(1,2,source_file,contains(".mean"),contains(".std")))
# get descriptive activity names
df_main <- merge(activity_labels, df_main, by = "activity_code")

###-------------------------------------------------------------------------###
### 4 Time to get a tidy version
###
# melt the table for easy averaging, i.e. wide table --> long table
df_interim <- gather(df_main,"measure_name","measure_value", 5:ncol(df_main))
# group to detail level of observations (subject + activity) and average per variable (feature measures)
df_interim <- group_by(df_interim, source_file, subject, activity_label, measure_name) %>%
      summarise(avg_measure_value = mean(measure_value))
# spread variables again so that each variable is in one column and rename to make obvious that those are averages
df_tidy <- spread(df_interim, measure_name, avg_measure_value)
names(df_tidy) <- c(names(df_tidy[1:3]),paste0("Avg_",names(df_tidy[3:ncol(df_tidy)])))

###-------------------------------------------------------------------------###
### write output
###
write.table(df_tidy, file="TidyDataSet.txt",row.name=FALSE)

