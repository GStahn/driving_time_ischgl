## ---------------------------
##
## Script name: Compute_dtime_ischgl
##
## Purpose of script: Create distance to Ischgl
##
## Author: Gerrit Stahn
##
## Date Created: 2024-08-19
## Last Update: 2024-08-20
##
## Copyright (c) Gerrit Stahn, 2024
## Email: gerrit.stahn@wiwi.uni-halle.de
##

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------

### Install packages (uncomment as required) ###
# install.packages("tidyverse")
# install.packages("sf")
# install.packages("osrm")
## install.packages("writexl")


### Load add-on packages ### 
library(tidyverse)
library(sf)
library(osrm)
library(writexl)


### clean start ###
rm(list = ls())

### set working directory and paths ###
setwd("YOU PATH")


## -----------------------------------------------------------------------------
## Get coordinates 
## -----------------------------------------------------------------------------

### All German districts ###

# Read the shapefile
shp_data <- st_read("./shapefiles/VG250_KRS.shp") %>% 
  st_transform(4326) %>%
  mutate(ID_K=as.numeric(ARS))

# Drop rows where GF == 2 to get all districts as of August 2020
shp_data <- shp_data %>%filter(GF != 2)

# Get coordinates of centroids
shp_data <- shp_data %>%
  mutate(lon=st_coordinates(st_centroid(.))[,1],
         lat=st_coordinates(st_centroid(.))[,2])

### Ischgl ###
austria <- st_read("./shapefiles/STATISTIK_AUSTRIA_GEM_20200101Polygon.shp") %>%
  st_transform(4326) %>% 
  mutate(lon=st_coordinates(st_centroid(.))[,1],
         lat=st_coordinates(st_centroid(.))[,2])


## -----------------------------------------------------------------------------
## Get driving time
## -----------------------------------------------------------------------------

lon_lat_gdistricts <- shp_data %>%select(ID_K, lon, lat) %>%
  st_drop_geometry() %>% 
  as_data_frame()

lon_lat_ischgl<- austria %>%
  st_drop_geometry() %>%
  filter(name=="Ischgl") %>%
  select(lon, lat) %>%
  as_data_frame()

# Split computation in four parts due to limitations of the osrm demo server
dtime1 <- osrmTable(src=lon_lat_gdistricts[1:100, c("lon", "lat")],
                   dst=lon_lat_ischgl[1, c("lon", "lat")],
                   osrm.profile = "car")

dtime2 <- osrmTable(src=lon_lat_gdistricts[101:200, c("lon", "lat")],
                    dst=lon_lat_ischgl[1, c("lon", "lat")],
                    osrm.profile = "car")

dtime3 <- osrmTable(src=lon_lat_gdistricts[201:300, c("lon", "lat")],
                    dst=lon_lat_ischgl[1, c("lon", "lat")],
                    osrm.profile = "car")

dtime4 <- osrmTable(src=lon_lat_gdistricts[301:401, c("lon", "lat")],
                    dst=lon_lat_ischgl[1, c("lon", "lat")],
                    osrm.profile = "car")

duration <- dtime1[["durations"]]
duration <- append(duration, dtime2[["durations"]])
duration <- append(duration, dtime3[["durations"]])
duration <- append(duration, dtime4[["durations"]])

# Combine everything for final dataset 
final_dataset <- lon_lat_gdistricts %>% add_column(duration) %>%
  mutate(duration_h = duration/60) %>% # duration in hours 
  mutate(timestamp= Sys.Date())

# Save and export 
save(final_dataset, file = paste0("./final_dataset_", Sys.Date(), ".rda"))
write_xlsx(final_dataset, path= paste0("./final_dataset_", Sys.Date(), ".xlsx"))

## -----------------------------------------------------------------------------
