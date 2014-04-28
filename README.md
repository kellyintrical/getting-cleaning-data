#Getting/Cleaning Data on Coursera

##Peer review assessment


This R script creates a tidy dataset of data collected from accelerometers from the Samsung Galaxy S smartphone.

The original data are located here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The R script will download the data, install required packages, read in the data, and manipulate it to print a tidy data set containing the average of each variable for each activity and each subject.

The details on each step of the R script are noted below.

1. Check if UCI HAR Dataset folder exists in Working Directory. If not, create it and download data.
2. Check for required packages, install if necessary
3. Read in data
4. Create data frame for activities and subjects
5. Label activities with appropriate labels (i.e. 1 should be WALKING)
6. Create data frame for measurements
7. Extract rows with means or stds from measurements
8. Combine subjects, activities, measurements to one data frame
9. Melt combined data frame by subject and activity and find means for each measurement
10. Write the tidy data set to a file "tidy.txt" in working directory
