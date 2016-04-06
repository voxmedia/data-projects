#!/bin/bash
source globals.sh
source `which virtualenvwrapper.sh`

echo '-------------------'
echo 'CREATING VITRUALENV'
echo '-------------------'
mkvirtualenv $PROJECT_NAME

echo '-----------------------'
echo 'INSTALLING REQUIREMENTS'
echo '-----------------------'
pip install -r requirements.txt

echo '---------------------'
echo 'ACTIVATING VIRTUALENV'
echo '---------------------'
workon $PROJECT_NAME

echo '-------------------'
echo '** DOWNLOAD DATA **'
echo '-------------------'
./download.sh

echo '---------------------------'
echo '** FILTER SHAPEFILE DATA **'
echo '---------------------------'
./filter-shp.sh

echo '-------------------------------------'
echo '** CREATE DATABASE AND IMPORT DATA **'
echo '-------------------------------------'
./import.sh

echo '--------------------'
echo '** EXPORT GEOJSON **'
echo '--------------------'
./export.sh

echo '-----------------------------------'
echo '** GENERATE LEAD RISK SCORE DATA **'
echo '-----------------------------------'
./generate-lead-data.sh

echo '------------------------------------------'
echo '** JOIN LEAD RISK SCORE DATA TO GEOJSON **'
echo '------------------------------------------'
./join.sh

echo '---------------------------'
echo '** GENERATE VECTOR TILES **'
echo '---------------------------'
./vectorize.sh

echo '----------------------'
echo '** PROCESS FINISHED **'
echo '----------------------'
