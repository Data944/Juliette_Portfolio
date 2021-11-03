## set up my environment
install.packages("tidyverse")
library(tidyverse)
install.packages("dplyr")
library(dplyr)

##  load and merge files
library(data.table)
setwd("C:/Users/julie/OneDrive/Documents/trip/Cyclist")
files <- list.files(pattern = ".csv")
data <- lapply(files, fread, sep= ",")
trip_data <- rbindlist(data)

## view data
view(trip_data)
head(trip_data)
str(trip_data3)

## clean data

### remove N/A columns and empty columns
trip_data2 <- filter(trip_data, start_station_id != "NA" & end_station_id!="NA")
trip_data3 <-  filter(trip_data, start_station_name != "" & end_station_name!= "")

### check for  duplicates
ride_id <- trip_data3 %>%
  count(ride_id) %>%
  filter(n > 1) # no duplicates found

## 3. transform data
###  find time difference in sec between ended_at and started_at columns
trip_data3$ride_length <- difftime(
  trip_data3$ended_at, 
  trip_data3$started_at,
  units = "mins"
) 

##create column for day of the week, month, year
trip_data3$day_of_week <- format(trip_data3$started_at,
                                "%A")
trip_data3$month <- format(trip_data3$started_at, "%m")
trip_data3$year <- format(trip_data3$started_at, "%y")
view(trip_data3)

# need to change string types for day of week, month and year
trip_data3 <- mutate(trip_data3,  day_of_week = as.character(day_of_week),
                                  month = as.numeric(month),
                                  year = as.numeric(year))
# view data
str(trip_data3)


## select variables to work with
trip_variables <- trip_data3 %>%
  select(rideable_type, start_station_name, end_station_name, member_casual, ride_length, day_of_week, year, month)
 
