# Description of data processing

Data for this repo were downloaded from this link:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The data here represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site from which the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The code contained in the file run_analysis.R, which is used to create a tidy data set, containing the average of each variable for each subject-activity combination, assumes that the data is already downloaded and located within your working directory.

The script is broken into 5 subheadings:
1) Merge the training and the test sets to create one data set.
2) Extract the measurements of interest (mean and standard deviation) for each measurement.
3) Use descriptive activity names to name the activities in the data set.
4) Appropriately label the data set with descriptive variable names.
5) Create a data set with the average of each variable for each activity and each subject.

The tidy_data set was exported as a txt file: course_project.txt
