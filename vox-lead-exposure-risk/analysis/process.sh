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

echo '-------------------------------------'
echo '** CREATE DATABASE AND IMPORT DATA **'
echo '-------------------------------------'
./import.sh

echo '-----------------------'
echo '** EXPORT BLOCKS CSV **'
echo '-----------------------'
./export.sh

echo '---------------------------------------------------------------'
echo '** GROUP BLOCKS BY TRACTS, CLASSIFY AS URBAN, RURAL OR MIXED **'
echo '---------------------------------------------------------------'
python classify-tracts.py

echo '------------------------------------------'
echo '** ANALYZE LEAD EXPOSURE RISK OF TRACTS **'
echo '------------------------------------------'
python analyze-tracts.py

echo '------------------------------------------'
echo '** ANALYZE LEAD EXPOSURE RISK OF STATES **'
echo '------------------------------------------'
python analyze-states.py

echo '----------------------'
echo '** PROCESS FINISHED **'
echo '----------------------'
