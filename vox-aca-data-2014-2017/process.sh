#!/bin/bash

echo '-------------------------'
echo 'CREATE RAW-CSVS DIRECTORY'
echo '-------------------------'
# If directory does not already exist, create.
if [ ! -d 'raw-csvs' ]; then
    mkdir raw-csvs
fi

echo '------------------'
echo 'CONVERT XLS to CSV'
echo '------------------'

in2csv raw-xls/ID_Individual_Market_Medical_8_11_14.xlsx > raw-csvs/ID-14.csv
in2csv raw-xls/NM_Individual_Market_Medical_8_11_14.xlsx > raw-csvs/NM-14.csv

in2csv raw-xls/PY2015_OR-Med-Indi-Land-08-13-2015.xlsx > raw-csvs/OR.csv
in2csv raw-xls/PY2015_NV-Med-Indi-Land-08-13-2015.xlsx > raw-csvs/NV.csv
in2csv raw-xls/PY2015_NM-Med-Indi-Land-08-13-2015.xlsx > raw-csvs/NM.csv

in2csv raw-xls/Individual_Market_Medical_8_11_14.xlsx > raw-csvs/2014.csv
in2csv raw-xls/PY2015_Med-Indi-Land-08-13-2015.xlsx > raw-csvs/2015.csv
in2csv raw-xls/Individual_Market_Medical_07_29_2016.xlsx > raw-csvs/2016.csv

echo '--------------------------------------------'
echo 'REMOVE HEADERS FROM ID AND NM FILES FOR 2014'
echo '--------------------------------------------'
sed 1d raw-csvs/ID-14.csv > raw-csvs/ID-14noheader.csv
sed 1d raw-csvs/NM-14.csv > raw-csvs/NM-14noheader.csv

echo '------------------------------------------------'
echo 'REMOVE HEADERS FROM OR, NV AND NM FILES FOR 2015'
echo '------------------------------------------------'
sed 1d raw-csvs/OR.csv > raw-csvs/ORnoheader.csv
sed 1d raw-csvs/NV.csv > raw-csvs/NVnoheader.csv
sed 1d raw-csvs/NM.csv > raw-csvs/NMnoheader.csv

echo '------------------------------------'
echo 'COMBINE OR, NV AND NM WITH 2015 DATA'
echo '------------------------------------'
cat raw-csvs/2015.csv raw-csvs/ORnoheader.csv raw-csvs/NVnoheader.csv raw-csvs/NMnoheader.csv > raw-csvs/2015-combined.csv

echo '------------------------------------'
echo 'COMBINE ID AND NM WITH 2014 DATA'
echo '------------------------------------'
cat raw-csvs/2014.csv raw-csvs/ID-14noheader.csv raw-csvs/NM-14noheader.csv > raw-csvs/2014-combined.csv

echo '-----------------------------------------------------------'
echo 'RUN PYTHON SCRIPTS TO GROUP ISSUERS BY COUNTY FOR EACH YEAR'
echo '-----------------------------------------------------------'
python issuers-by-county-14.py
python issuers-by-county-15.py
python issuers-by-county-16.py
python issuers-by-county-17.py

echo '------------------------------------------------------------------------------'
echo 'TO GENERATE GEOGRAPHIC DATA, SCRIPTS MUST BE RUN MANUALLY OR USE FILES IN REPO'
echo '------------------------------------------------------------------------------'
