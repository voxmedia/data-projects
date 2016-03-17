#!/bin/bash

echo '- Downloading files into data folder...'

if [ ! -d "data" ]; then
    # Make a new directory called 'data'
    mkdir data
fi

# Download the files we need and rename them
curl -# -o data/2002_female.dat ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NSFG/2002FemResp.dat
curl -# -o data/2002_male.dat ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NSFG/2002Male.dat
curl -# -o data/2006_2010_female.dat ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NSFG/2006_2010_FemResp.dat
curl -# -o data/2006_2010_male.dat ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NSFG/2006_2010_Male.dat
curl -# -o data/2011_2013_female.dat ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NSFG/2011_2013_FemRespData.dat
curl -# -o data/2011_2013_male.dat ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NSFG/2011_2013_MaleData.dat
