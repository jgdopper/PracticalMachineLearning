library(caret)
library(randomForest)

## Download the datafiles for training and testing
url <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
download.file(url, destfile="/home/jgdopper/Documenten/Coursera/Data_Science/
              8_Practical_Machine_Learning/Week4/Assignment/Data/
              pml-training.csv", method="curl")

url <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
download.file(url, destfile="/home/jgdopper/Documenten/Coursera/Data_Science
              /8_Practical_Machine_Learning/Week4/Assignment/Data/
              pml-testing.csv", method="curl")
str(training)

## Read the datafiles
training <- read.csv("/home/jgdopper/Documenten/Coursera/Data_Science/
                     8_Practical_Machine_Learning/Week4/Assignment/Data/
                     pml-training.csv", header=TRUE)

testing <- read.csv("/home/jgdopper/Documenten/Coursera/Data_Science/
                    8_Practical_Machine_Learning/Week4/Assignment/Data/
                    pml-testing.csv", header=TRUE)

## Data Cleaning.
## Idea: Base the prediction algorithm on the direct data from 
## the accelerometers directly.
## This means
## 1. Removing the first 7 variables
## 2. removing all variables which are not direct observations, but calculated / 
## derived measures, like "kurtosis", "skewness", "max", "min", "amplitude", 
##"var", "avg", "stddev", 

training <- training[,8:160]

training <- training[-grep("kurtosis_", names(training))]
training <- training[-grep("skewness_", names(training))]
training <- training[-grep("max_", names(training))]
training <- training[-grep("min_", names(training))]
training <- training[-grep("amplitude_", names(training))]
training <- training[-grep("var_", names(training))]
training <- training[-grep("avg_", names(training))]
training <- training[-grep("stddev_", names(training))]

## Now we have 53 variables left over: one outcome and 52 predictors.
## We now test on any missing values

colSums(is.na(training))

## Great, there are no missing values. Now let's get started with the model.

set.seed(12345)
modFit <- randomForest(classe ~.,  data=training)

## To get an idea of the variables of importance, we plot the mean decrease Gini
varImpPlot(modFit)

##  From the description of randomForest: In random forests, there is no need for 
## cross-validation or a separate test set to get an unbiased estimate of the 
## test set error. It is estimated internally, during the run, as follows. 
## This means that we expect the expected out of sample error slightly higher 
## than the OOB estimate of error rate, which is equal to 0.29%. 

## Now we test on the testing data.
## We first need to clean the testing set in a similar way as the training set.

testing <- testing[,8:160]

testing <- testing[-grep("kurtosis_", names(testing))]
testing <- testing[-grep("skewness_", names(testing))]
testing <- testing[-grep("max_", names(testing))]
testing <- testing[-grep("min_", names(testing))]
testing <- testing[-grep("amplitude_", names(testing))]
testing <- testing[-grep("var_", names(testing))]
testing <- testing[-grep("avg_", names(testing))]
testing <- testing[-grep("stddev_", names(testing))]
