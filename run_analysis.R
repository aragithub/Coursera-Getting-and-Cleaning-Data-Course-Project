
filename <- "proyecto.zip"

if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

################################################################################################
# 1.Merges the training and the test sets to create one data set.-------------------------------

#Load datasets
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

#Create x_Data
x_Data<-rbind(x_train,x_test)

#Create y_Data
y_Data<-rbind(y_train,y_test)

#Create subject_Data
subject_Data<-rbind(subject_train,subject_test)

#################################################################################################
# 2.Extracts only the measurements on the mean and standard deviation for each measurement.----- 

# Load dataset
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Get only columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# Subset the desired columns
x_Data<-x_Data[,mean_and_std_features]

# Correct the column names
names(x_Data) <- features[mean_and_std_features, 2]

##################################################################################################
# 3. Uses descriptive activity names to name the activities in the data set.----------------------

# Load dataset
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])

# Update values with correct activity names
y_Data[, 1] <- activityLabels[y_Data[, 1], 2]

# Correct column name
names(y_Data) <- "activity"

##################################################################################################
# 4. Appropriately labels the data set with descriptive variable names.---------------------------

# Correct column name
names(subject_Data) <- "subject"

# bind all the data in a single data set
all_Data <- cbind(subject_Data, y_Data, x_Data)

###################################################################################################
# 5. From the data set in step 4, creates a second, independent tidy data set with the average-----
#    of each variable for each activity and each subject.


library(dplyr)
average_Data<-all_Data%>%group_by(subject,activity)%>%summarise_each(funs(mean))

write.table(average_Data,"average_Data.txt",row.names=FALSE)
