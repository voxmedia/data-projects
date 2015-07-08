#!/bin/bash

if [ ! -d "downloads" ]; then
    # Make a new directory and unzip the data into it
    mkdir downloads
fi

echo '- Downloading HAI data...'
# https://data.medicare.gov/Hospital-Compare/Healthcare-Associated-Infections-Hospital/77hc-ibv8
# https://data.medicare.gov/api/views/77hc-ibv8/rows.csv?accessType=DOWNLOAD
curl -# -o downloads/hai.csv https://data.medicare.gov/api/views/77hc-ibv8/rows.csv?accessType=DOWNLOAD

echo '- Downloading General Hospital Information data...'
# https://data.medicare.gov/Hospital-Compare/Hospital-General-Information/xubh-q36u
# https://data.medicare.gov/api/views/xubh-q36u/rows.csv?accessType=DOWNLOAD
curl -# -o downloads/hospital_general.csv https://data.medicare.gov/api/views/xubh-q36u/rows.csv?accessType=DOWNLOAD

