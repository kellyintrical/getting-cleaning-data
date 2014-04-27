#first, checks if UCI HAR Dataset folder exists in WD. If not, pulls
# the zip file from the link and unzips it
folder <- "UCI HAR Dataset"
if(!file.exists(folder)) {
  zipFile <- "src_data.zip"
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, destfile=zipFile, method="curl")
  unzip(zipFile)
  file.remove(zipFile)
}

#check for required packages, install if necessary
if (!require("reshape")) {
  install.packages("reshape")
}

if (!require("data.table")) {
  install.packages("data.table")
}

#load required packages
library("reshape")
library("data.table")


#read in data
subjectTest <- read.table(paste(folder, "/test/subject_test.txt", sep=""))
testY <- read.table(paste(folder, "/test/y_test.txt", sep=""))
testX <- read.table(paste(folder, "/test/X_test.txt", sep=""))

subjectTrain <- read.table(paste(folder, "/train/subject_train.txt", sep=""))
trainY <- read.table(paste(folder, "/train/y_train.txt", sep=""))
trainX <- read.table(paste(folder, "/train/X_train.txt", sep=""))

variables <- read.table(paste(folder, "/features.txt", sep=""))
varNames <- as.character(variables[,2])


#create data frame for activities and subjects
activities <- rbind(testY, trainY)
subjects <- rbind(subjectTest, subjectTrain)

##clean up R working space, delete items no longer needed
rm(testY, trainY, subjectTest, subjectTrain, variables, fileUrl, folder, zipFile)

#label activities
activities[,1] <- gsub(1, "WALKING", as.matrix(activities[,1]))
activities[,1] <- gsub(2, "WALKING_UPSTAIRS", as.matrix(activities[,1]))
activities[,1] <- gsub(3, "WALKING_DOWNSTAIRS", as.matrix(activities[,1]))
activities[,1] <- gsub(4, "SITTING", as.matrix(activities[,1]))
activities[,1] <- gsub(5, "STANDING", as.matrix(activities[,1]))
activities[,1] <- gsub(6, "LAYING", as.matrix(activities[,1]))

##create data frame for measurements
measurements <- rbind(testX, trainX)
names(measurements) <- varNames

##clean up R working space, delete items no longer needed
rm(testX, trainX, varNames)

##extract rows with means or stds from measurements
mesMeans <- measurements[ , grepl("mean", names(measurements)) ]
mesMeans <- mesMeans[, -grep("Freq", names(mesMeans))]
mesStds <- measurements[ , grepl("std", names(measurements)) ]
mesSub <- cbind(mesMeans, mesStds)

##clean up R working space, delete items no longer needed
rm(mesMeans, mesStds)

#merge subjects, activities, measurements
data <- cbind(subjects, activities, mesSub)
names(data)[1:2] = c("subject", "activity")

##clean up R working space, delete items no longer needed
rm(subjects, activities, measurements, mesSub)

#melt dataset and find means by sub and act
melted <- melt(data, id.vars = c("subject", "activity"))
tidy <- cast(melted, subject + activity ~ variable, mean)

##write the tidy data to a file
write.table(tidy, file= "tidy.txt")
