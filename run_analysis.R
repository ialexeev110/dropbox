wd_root <- getwd()
wd_test <- "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test"
wd_train <-  "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train"

## getting information about test subjects and corresponding activities
setwd(wd_root)
setwd(wd_test)
subject_test <- read.table("subject_test.txt", header = FALSE, sep = "", dec = ".")
subject_test <- as.numeric(subject_test[,1])
activity_test <- read.table("y_test.txt", header = FALSE, sep = "", dec = ".")
activity_test <- as.numeric(activity_test[,1])

## getting information about train subjects and corresponding activities
setwd(wd_root)
setwd(wd_train)
subject_train <- read.table("subject_train.txt", header = FALSE, sep = "", dec = ".")
subject_train <- as.numeric(subject_train[,1])
activity_train <- read.table("y_train.txt", header = FALSE, sep = "", dec = ".")
activity_train <- as.numeric(activity_train[,1])

#merging information about subjects
subjects <- c()
activity <- c()
subjects <- c(subject_test,subject_train)
activity <- c(activity_test,activity_train)

# get test data
setwd(wd_root)
setwd(wd_test)
setwd("./Inertial Signals")
datafiles_test=c("body_acc_x_test.txt","body_acc_y_test.txt","body_acc_z_test.txt", 
                 "body_gyro_x_test.txt","body_gyro_y_test.txt","body_gyro_z_test.txt",
                 "total_acc_x_test.txt","total_acc_y_test.txt","total_acc_z_test.txt")
n_test=length(datafiles_test)

stat_test<-c()
for(i in 1:n_test){
  temp <- read.table(datafiles_test[i], header = FALSE, sep = "", dec = ".") 
  temp <- matrix(as.numeric(unlist(temp)), nrow=length(temp), byrow=TRUE)
  stat_test <- rbind(stat_test,colMeans(temp))        # calculates and records mean for test data files
  stat_test<- rbind(stat_test,apply(temp, 2, sd))     # calculates and records std for test data files
}
rm(temp) 

# get train data
setwd(wd_root)
setwd(wd_train)
setwd("./Inertial Signals")
datafiles_train=c("body_acc_x_train.txt","body_acc_y_train.txt","body_acc_z_train.txt", 
                 "body_gyro_x_train.txt","body_gyro_y_train.txt","body_gyro_z_train.txt",
                 "total_acc_x_train.txt","total_acc_y_train.txt","total_acc_z_train.txt")
n_train=length(datafiles_train)

stat_train<-c()
for(i in 1:n_train){
  temp <- read.table(datafiles_train[i], header = FALSE, sep = "", dec = ".") 
  temp <- matrix(as.numeric(unlist(temp)), nrow=length(temp), byrow=TRUE)
  stat_train <- rbind(stat_train,colMeans(temp))          # calculates and records mean for train data files
  stat_train <- rbind(stat_train,apply(temp, 2, sd))      # calculates and records std for train data files
}
rm(temp)

stat_all <- t(cbind(stat_test,stat_train))                # merges mean and std results for test and train data sets
summary=cbind(subjects,activity,stat_all)                 # adds subject and activity columns

col_names <- c("Subject","Activity",
               "body_acc_x_mean","body_acc_x_std","body_acc_y_mean","body_acc_y_std", "body_acc_z_mean","body_acc_z_std",
               "body_gyro_x_mean","body_gyro_x_std","body_gyro_y_mean","body_gyro_y_std","body_gyro_z_mean","body_gyro_z_std",
               "total_acc_x_mean","total_acc_x_std","total_acc_y_mean","total_acc_y_std","total_acc_z_mean","total_acc_z_std")
colnames(summary) <- col_names
summary <- summary[order(summary[,1],decreasing=FALSE),]    # order summary table based on subject number 

summary_L <-summary     # data for all subjects with mean and std values for all measurement sequences
# replacing activity number to meaningful name
size_summary_L <- dim(summary_L)
temp <- c()
for (i in 1:size_summary_L[1]){
  temp[i] <- switch(summary[[i,2]], 
                          "WALKING", 
                          "WALKING_UPSTAIRS", 
                          "WALKING_DOWNSTAIRS",
                          "SITTING",
                          "STANDING",
                          "LAYING")
}
summary_L[,2] <- temp
summary_L <- as.data.frame(summary_L)
rm(temp)


################################################################################
# create second, independent tidy data set with average of each variable for each activity and each subject

subjects_unique <- unique(subjects[order(subjects)])
activity_unique <- unique(activity[order(activity)])

sub_summary <- c()
for (i in 1:length(subjects_unique)){
  index_subjects <- which(summary[,1]==subjects_unique[i])
  subject_summary=summary[index_subjects,]
  for (j in 1:length(activity_unique)){
    index_activity <- which(subject_summary[,2]==activity_unique[j])
    subject_activity_summary <- subject_summary[index_activity,c(1,2,3,5,7,9,11,13,15,17)]
    sub_summary <- rbind(sub_summary,colMeans(subject_activity_summary))
  }
}

summary_S <- sub_summary      # data for all subjects with averaged measurements over same activity
# replacing activity number to meaningful name
size_summary_S <- dim(summary_S)
temp <- c()
for (i in 1:size_summary_S[1]){
  temp[i] <- switch(sub_summary[[i,2]], 
                    "WALKING", 
                    "WALKING_UPSTAIRS", 
                    "WALKING_DOWNSTAIRS",
                    "SITTING",
                    "STANDING",
                    "LAYING")
}
summary_S[,2] <- temp
summary_S <- as.data.frame(summary_S)
rm(temp)

setwd(wd_root)
write.table(summary_S, "Acc_data_summary.txt", row.name=FALSE)
