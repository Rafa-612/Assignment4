data_dir <- "/Users/ruei-yangjhong/Desktop/Coursera R/ProjAssignment4/Assignment4/UCI_HAR_Dataset"

# read features and activities table
features <- read.table(file.path(data_dir, "features.txt"), col.names = c("index", "feature"))
activities <- read.table(file.path(data_dir, "activity_labels.txt"), col.names = c("code", "activity"))

# read training set
x_train <- read.table(file.path(data_dir, "train", "X_train.txt"))
y_train <- read.table(file.path(data_dir, "train", "y_train.txt"), col.names = "activity")
subject_train <- read.table(file.path(data_dir, "train", "subject_train.txt"), col.names = "subject")

# read testing set
x_test <- read.table(file.path(data_dir, "test", "X_test.txt"))
y_test <- read.table(file.path(data_dir, "test", "y_test.txt"), col.names = "activity")
subject_test <- read.table(file.path(data_dir, "test", "subject_test.txt"), col.names = "subject")

#merge traing set and testing set 
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# label the dataset variables with 
colnames(x_data) <- features$feature

# Use grepl function to locate the column which has the column name mean() or std()
mean_std_cols <- grepl("mean\\(\\)|std\\(\\)", features$feature)

# Only preserve the column corresponds to the boolean vector mean_std_cols
x_mean_std <- x_data[, mean_std_cols]

# combine subject_data, y_data, x_mean_std into a complete dataframe
colnames(merged_data) <- cbind(subject_data, y_data, x_mean_std) 

# Use activities code to translate the activity code into activity name
colnames(merged_data)$activity <- factor(colnames(merged_data)$activity, 
                                 levels = activities$code, 
                                 labels = activities$activity)

# Appropriately labels the data set with descriptive variable names
colnames(merged_data) <- gsub("^t", "TimeDomain.", colnames(merged_data))
colnames(merged_data) <- gsub("^f", "FrequencyDomain.", colnames(merged_data))

# 感測器類型
colnames(merged_data) <- gsub("Acc", "Accelerometer", colnames(merged_data))
colnames(merged_data) <- gsub("Gyro", "Gyroscope", colnames(merged_data))

# 感測對象
colnames(merged_data) <- gsub("BodyBody", "Body", colnames(merged_data))
colnames(merged_data) <- gsub("Body", "Body.", colnames(merged_data))
colnames(merged_data) <- gsub("Gravity", "Gravity.", colnames(merged_data))

# Jerk 與 Magnitude
colnames(merged_data) <- gsub("Jerk", "JerkSignal", colnames(merged_data))
colnames(merged_data) <- gsub("Mag", "Magnitude", colnames(merged_data))

# 統計指標
colnames(merged_data) <- gsub("-mean\\(\\)", ".Mean", colnames(merged_data))
colnames(merged_data) <- gsub("-std\\(\\)", ".STD", colnames(merged_data))

# 軸向
colnames(merged_data) <- gsub("-X", ".XAxis", colnames(merged_data))
colnames(merged_data) <- gsub("-Y", ".YAxis", colnames(merged_data))
colnames(merged_data) <- gsub("-Z", ".ZAxis", colnames(merged_data))

# 清除殘留的符號
colnames(merged_data) <- gsub("[\\(\\)-]", "", colnames(merged_data))

# 更新欄位名稱
names(filtered_data) <- colnames(merged_data)



