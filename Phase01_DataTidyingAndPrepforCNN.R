#' 2021_11_29 Data tidying and prep for a CNN classifier
#' to distinguish between NFL and FL in 2 subjects
#' 
#' Goal of this script: Resampled, NA infilled, and labeled 
#' 
#' JC_data_tidied_forR.xlsx
#' 
#' RK_data_tidied_forR.xlsx
#' 
#' # packages (run install.packages("packagename") for any package that fails to load)
library(dplyr)
library(ggplot2)
library(readxl)
library(akima)
library(gdata)
library(fame)
library(tidyverse)
library(ggformula)
library(stringr)
library(plyr)

#data path
JCPath <- "JC_data_tidied_forR.xlsx"
RKPath <- "RK_data_tidied_forR.xlsx"


#bring in dataframes for asthma and control
JCData <- read_excel(path = JCPath, sheet = "Expiration")
RKData <- read_excel(path = RKPath)

#improve names
names(JCData) <- str_remove(names(JCData),"#")
names(JCData) <- make.names(names(JCData))

names(RKData) <- str_remove(names(RKData),"#")
names(RKData) <- make.names(names(RKData))

#One-off fix for bad data at row 153 of NFL.13.Volume column
JCData$NFL.13.Volume[153] <- NA



#test plots; one for ashtma one for control

#JC
ggplot(data = JCData) +
  geom_path(mapping = aes(x = NFL.9.Volume,
                          y = NFL.9.flow),
            color = "green") +
  geom_path(mapping = aes(x = FL.9.Volume,
                          y = FL.9.flow),
            color = "red")  +
  xlab("Volume") +
  ylab("Flow") +
  ggtitle("Raw JC Data for NFL 9 (green) and FL 9 (red)")

#RK
ggplot(data = RKData) +
  geom_path(mapping = aes(x = NFL.9.Volume,
                          y = NFL.9.flow),
            color = "green") +
  geom_path(mapping = aes(x = FL.9.Volume,
                          y = FL.9.flow),
            color = "red")  +
  xlab("Volume") +
  ylab("Flow") +
  ggtitle("Raw RK Data for NFL 9 (green) and FL 9 (red)")



#source resampler
source('resampleDataFrame_use_x_Min.R',echo = TRUE)

#resample 
Resampled_JCData <- resampleDataFrame_use_x_Min(inputData = JCData,
                                       resampleN = 500)

Resampled_RKData <- resampleDataFrame_use_x_Min(inputData = RKData,
                                                resampleN = 500)



#source infillNAColumns
source('infillNAColumns.R')


#infill controls
Resampled_JCData <- infillNAColumns(inputData = Resampled_JCData)
Resampled_RKData <- infillNAColumns(inputData = Resampled_RKData)


#test plots for resampled infillNAColumns data
ggplot(data = Resampled_JCData) +
  geom_path(mapping = aes(x = NFL.9.Volume,
                          y = NFL.9.flow),
            color = "green") +
  geom_path(mapping = aes(x = FL.9.Volume,
                          y = FL.9.flow),
            color = "red")  +
  xlab("Volume") +
  ylab("Flow") +
  ggtitle("Results of Resample Missing Data Protocol on JC NFL 9 (green) and FL 9 (red)")

ggplot(data = Resampled_RKData) +
  geom_path(mapping = aes(x = NFL.9.Volume,
                          y = NFL.9.flow),
            color = "green") +
  geom_path(mapping = aes(x = FL.9.Volume,
                          y = FL.9.flow),
            color = "red")  +
  xlab("Volume") +
  ylab("Flow") +
  ggtitle("Results of Resample Missing Data Protocol on RK NFL 9 (green) and FL 9 (red)")


# Remove original dataframes
remove(RKData,JCData)

# Manually add labels
# 1 = Flow Limited (FL), 
# 0 = Not Flow Limited (NFL)
Resampled_JCData <- rbind(
  1-as.integer(str_detect(names(Resampled_JCData),"NFL")),
  Resampled_JCData
  )

Resampled_RKData <- rbind(
  1-as.integer(str_detect(names(Resampled_RKData),"NFL")),
  Resampled_RKData
)

# Separate flow and volume columns
Resampled_JCData_Volume_Only <- Resampled_JCData[,seq(1,ncol(Resampled_JCData),by=2)] 
Resampled_JCData_Flow_Only <- Resampled_JCData[,seq(2,ncol(Resampled_JCData),by=2)] 

Resampled_RKData_Volume_Only <- Resampled_RKData[,seq(1,ncol(Resampled_RKData),by=2)] 
Resampled_RKData_Flow_Only <- Resampled_RKData[,seq(2,ncol(Resampled_RKData),by=2)] 

#transpose
Resampled_JCData_Volume_Only <- t(Resampled_JCData_Volume_Only)
Resampled_JCData_Flow_Only <- t(Resampled_JCData_Flow_Only)

Resampled_RKData_Volume_Only <- t(Resampled_RKData_Volume_Only)
Resampled_RKData_Flow_Only <- t(Resampled_RKData_Flow_Only)

# bind two together
Resampled_myData_Volume_Only <- rbind(Resampled_JCData_Volume_Only,Resampled_RKData_Volume_Only)
Resampled_myData_Flow_Only <- rbind(Resampled_JCData_Flow_Only,Resampled_RKData_Flow_Only)

# ABANDONED -- better to pass two CSVs from R to Python
#tensor 
#labeled_Sandbox_Data <- array(Resampled_myData_Volume_Only,
#                              dim = c(dim(Resampled_myData_Volume_Only),2))
#
#labeled_Sandbox_Data[,,2] <- Resampled_myData_Flow_Only


write.table(Resampled_myData_Volume_Only,
          file = "Resampled_myData_Volume_Only.csv",
          row.names=FALSE, 
          col.names=FALSE, 
          sep=",")

write.table(Resampled_myData_Flow_Only,
            file = "Resampled_myData_Flow_Only.csv",
            row.names=FALSE, 
            col.names=FALSE, 
            sep=",")






