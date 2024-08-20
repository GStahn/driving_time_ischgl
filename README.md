# Driving Time Calculation to Ischgl from German Districts

This repository contains scripts and datasets for calculating the median driving time by car from various German districts (NUTS-3) to Ischgl, Austria. The calculations are based on data from August 2020.

## Files and Variables

### Important Notes
- The code is specifically tested for the territory status of all districts as of August 2020. Any changes to district boundaries or road networks before or after this period are not included in the calculations.
- Due to potential changes in driving conditions, the median duration may differ if the calculations are executed on different days.

### Scripts
- **Compute_dtime_ischgl.R**: This R script calculates the median driving time to Ischgl from each German district (centroid). 

### Datasets
- **final_dataset_timestamp.rda**: This is the final dataset produced by `Compute_dtime_ischgl.R`. It includes the following variables:
  - `ID_K`: Community Identification Number (Kreisschlüssel)
  - `lon`: Longitude of the district's centroid
  - `lat`: Latitude of the district's centroid
  - `duration`: Median driving time by car (in minutes)
  - `duration_h`: Median driving time by car (in hours)
  - `timestamp`: The date when the data was generated

- **final_dataset_timestamp.xlsx**: An Excel export of the `final_dataset_timestamp.rda` dataset.

## Prerequisites

If you wish to compute the driving times yourself, you will need to download the underlying shapefiles. The links to the necessary shapefiles are provided below:

- [Shapefile for German districts (VG250)](https://daten.gdz.bkg.bund.de/produkte/vg/vg250_ebenen_0101/2020/) (Last accessed on 08/20/2024)
- [Shapefile for Austrian municipalities](https://www.data.gv.at/katalog/de/dataset/stat_gliederung-osterreichs-in-gemeinden14f53#resources) -> OGDEXT_GEM_1_STATISTIK_AUSTRIA_20200101 (Last accessed on 08/20/2024)

## Usage

To use the script, ensure that you have R installed and the required libraries. 


