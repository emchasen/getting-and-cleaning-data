# Course Project: Getting and Cleaning Data

#set working directory
setwd("~/Google Drive/coursera/getting and cleaning data/course project")

#load libraries
library(dplyr)

### 1. Merge the training and the test sets to create one data set.
#download data
        test <- read.table("./UCI HAR Dataset/test/X_test.txt")
        test_labels <- read.table("./UCI HAR Dataset/test/Y_test.txt")
        test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")

        train <- read.table("./UCI HAR Dataset/train/X_train.txt")
        train_labels <- read.table("./UCI HAR Dataset/train/Y_train.txt")
        train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

        # change the column name for train_labels, test_labels, train_subject, test_subject
        ## will be important for step 3
        test_lbs <- rename(test_labels, label = V1)
        test_sub <- rename(test_subject, subject = V1)
        train_lbs <- rename(train_labels, label = V1)
        train_sub <- rename(train_subject, subject = V1)
        # bind column labels and subjects to data frames
        test_data <- cbind.data.frame(test_sub, test_lbs, test)
        train_data <- cbind.data.frame(train_sub, train_lbs, train)
        #row bind data
        full_data <- rbind(test_data, train_data)
        #convert to tbl_df
        full_data_tbl <- tbl_df(full_data)
        str(full_data_tbl)

### 2. Extract only the measurements on the mean and standard deviation for each measurement.
        #download features.txt
        features <- read.table("./UCI HAR Dataset/features.txt")
        # find features that are mean and standard deviation measurements
        # (creates numerical list)
        mn <- grep("mean", features$V2)
        st <- grep("std", features$V2)
        # since the full data set has an extra two rows (subject & activity),
        # at the front end, add 2
        adjust_mn <- mn + 2
        adjust_st <- st + 2
        # create new data set with just columns of interest
        data_mn_st <- full_data_tbl[c(1, 2, adjust_mn, adjust_st)]

### 3. Uses descriptive activity names to name the activities in the data set
        # break data into sets containing only one activity
        walk <- filter(data_mn_st, label == 1)
        walk_up <- filter(data_mn_st, label == 2)
        walk_down <- filter(data_mn_st, label == 3)
        sit <- filter(data_mn_st, label == 4)
        stand <- filter(data_mn_st, label == 5)
        lay <- filter(data_mn_st, label == 6)
        
        # add column in each subset of data for the activity
        wlk <- mutate(walk, activity = "walking")
        wlk_up <- mutate(walk_up, activity = "walking_upstairs")
        wlk_down <- mutate(walk_down, activity = "walking_downstairs")
        stg <- mutate(sit, activity = "sitting")
        stnd <- mutate(stand, activity = "standing")
        ly <- mutate(lay, activity = "laying")
        
        # bind rows to put data frames back together
        dat_labels <- bind_rows(wlk, wlk_up, wlk_down, stg, stnd, ly)
        
        # make data set with subect, activity, then measurements        
        set1 <- select(dat_labels, subject, activity, V1:V543)
        
### 4. Appropriately label the data set with descriptive variable names.
        # create list of variables from features
        mn_names <- grep("mean", features$V2, value = TRUE)
        st_names <- grep("std", features$V2, value = TRUE)
        labs <- c(mn_names, st_names)
        # change "t" to "time"
        labst <- gsub("^t", "time", labs)
        # change "f" to "freq"
        labsf <- gsub("^f", "freq", labst)
        # remove "()"
        lbls <- gsub("[()]", "", labsf)
        # remove "-"
        lbl <- gsub("[-]", "", lbls)
        # change "mean" to "Mean"
        lblmean <- gsub("mean", "Mean", lbl)
        # change "std" to "Stdev"
        labels <- gsub("std", "Stdev", lblmean)
        # sub "-" with ""
        lbls1 <- gsub("[-]", "", labels)
        
        # add column names to data set!
        colnames(set1) <- c("subject", "activity", lbls1)

### 5. From the data set in step 4, creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.
       tidy_data <- 
               set1 %>%
                group_by(subject, activity) %>%
                summarise_each_(funs(mean), names(set1)[-(1:2)])
        