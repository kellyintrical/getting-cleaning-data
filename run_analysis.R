##read in data
testX <- read.table("./X_test.txt")
testY <- read.table("./y_test.txt")
subjectTest <- read.table("./subject_test.txt")
trainX <- read.table("./X_train.txt")
trainY <- read.table("./y_train.txt")
subjectTrain <- read.table("./subject_train.txt")

##create table with measurements
xy <- rbind(testX, trainX)

##calculate row means and sd, add to table
xy$mean <- rowMeans(xy, na.rm = TRUE)
xy$SD <- apply(xy,1, sd, na.rm = TRUE)

#extract only means and SD in data frame
meanSD <- subset(xy, select=c("mean", "SD"))

#create data frame for activities and subjects
activities <- rbind(testY, trainY)
subjects <- rbind(subjectTest, subjectTrain)

#label activities
activities[,1] <- gsub(1, "WALKING", as.matrix(activities[,1]))
activities[,1] <- gsub(2, "WALKING_UPSTAIRS", as.matrix(activities[,1]))
activities[,1] <- gsub(3, "WALKING_DOWNSTAIRS", as.matrix(activities[,1]))
activities[,1] <- gsub(4, "SITTING", as.matrix(activities[,1]))
activities[,1] <- gsub(5, "STANDING", as.matrix(activities[,1]))
activities[,1] <- gsub(6, "LAYING", as.matrix(activities[,1]))

#merge subjects, activities, and means and SDs
tidy <- cbind(subjects, activities, meanSD)
names(tidy)[1:4] = c("subject", "activity", "mean", "SD")
