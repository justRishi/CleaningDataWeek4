#EXAMPLE 
# e.g
# x<-run_analysis()
#head(x[,c(1:3)])

# activity subject tbodyaccmeanx
# (fctr)   (int)         (dbl)
# 1  walking       1     0.2773308
# 2  walking       2     0.2764266


run_analysis = function(download=FALSE)
{
    #################
    #LOAD LIBRARIES #
    #################
    
    library(dplyr)
    library(data.table)

    ###############
    #RETRIEVE DATA#
    ###############

    if(download){
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","uci.zip")
        unzip("uci.zip")
    }
    
    ############
    #META DATA #
    ############
    
    #read in  test and training column names and tidy column names
    colNames<-fread("UCI HAR Dataset/features.txt",data.table=FALSE)
    colNames<-tolower(colNames[,2])
    colNames<-gsub("[(),-]","",colNames)
    
    #create activity vectors based on info in activity_labels.txt
    activityLevels<-c("1","2","3","4","5","6")
    activityLabels<-c("walking","walking-upstairs","walking-downstairs","sitting","standing","laying")
    
    #############
    # TEST DATA #
    #############
    
    #read in test data using colNames as col.names
    xtest<-fread("UCI HAR Dataset/test/X_test.txt",col.names=colNames, data.table=FALSE)
    
    #read test activities
    testactivities<-fread("UCI HAR Dataset/test/y_test.txt", data.table=FALSE)
    
    #add activity column to test table and transform to factor
    testactivities[1]<-factor(as.character(testactivities[[1]]), levels=activityLevels, labels=activityLabels)
    xtest[,"activity"]<-testactivities[[1]]
   
    #read in subjects and add to test table
    testsubjects<-fread("UCI HAR Dataset/test/subject_test.txt", data.table=FALSE)
    xtest[,"subject"]<-testsubjects[[1]]
    
    ###############
    #TRAINING DATA#
    ###############
    
    #read in training data using colNames as col.names
    xtrain<-fread("UCI HAR Dataset/train/X_train.txt",col.names=colNames, data.table=FALSE)
    
    #read training activities
    trainactivities<-fread("UCI HAR Dataset/train/y_train.txt", data.table=FALSE)
    
    #add activity column to train table and transform to factor
    trainactivities[1]<-factor(as.character(trainactivities[[1]]), levels=activityLevels, labels=activityLabels)
    xtrain[,"activity"]<-trainactivities[[1]]
    
    #read in subjects and add to training table
    trainsubjects<-fread("UCI HAR Dataset/train/subject_train.txt", data.table=FALSE)
    xtrain[,"subject"]<-trainsubjects[[1]]
    
    ##############################
    #MERGE TEST AND TRAINING DATA#
    ##############################
    traintest<-merge(xtrain,xtest, all = TRUE)
    
    ####################
    #CLEAN UP & AVERAGE#
    ####################
    
    #remove none mean and none std columns (and keep subject and activity of course)
    traintest <- traintest %>% select(matches("mean|std|subject|activity") )
    
    #average by activity and subject
    traintestGroup <- group_by(traintest,activity, subject) %>% summarise_each(funs(mean))
}