# !/bin/bash
echo '--------------------------'
echo 'CREATE DOWNLOADS DIRECTORY'
echo '--------------------------'
# If directory does not already exist, create.
if [ ! -d 'downloads' ]; then
    mkdir downloads
fi

echo '---------------------------------------------------------------'
echo 'CONNECT TO CENSUS FTP AND DOWNLOAD 2015 CENSUS TRACT SHAPEFILES'
echo '---------------------------------------------------------------'
ftp -in ftp://ftp2.census.gov/geo/tiger/TIGER2015/TRACT/ << SCRIPTEND
lcd downloads
mget *
SCRIPTEND
