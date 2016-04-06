# !/bin/bash
echo '--------------------------'
echo 'CREATE DOWNLOADS DIRECTORY'
echo '--------------------------'
# If directory does not already exist, create.
if [ ! -d 'downloads' ]; then
    mkdir downloads
fi

echo '----------------------------------------'
echo 'DOWNLOAD LIST OF 2010 CENSUS URBAN AREAS'
echo '----------------------------------------'
cd downloads
curl -O www2.census.gov/geo/docs/reference/ua/ua_list_all.xls
cd ..

echo '--------------------------------------'
echo 'CONVERT CENSUS URBAN AREAS XLS TO CSV.'
echo '--------------------------------------'
in2csv downloads/ua_list_all.xls > ua.csv

echo '----------------------------------------------------------------------------'
echo 'CONNECT TO CENSUS FTP AND DOWNLOAD 2010 CENSUS BLOCK RELATIONSHIP SHAPEFILES'
echo '----------------------------------------------------------------------------'
ftp -in ftp://ftp2.census.gov/geo/tiger/TIGER2010/FACES/ << SCRIPTEND
lcd downloads
mget *
SCRIPTEND

echo '-------------------------------------------------'
echo 'DELETE US TERRITORY ZIPFILES AND UNZIP SHAPEFILES'
echo '-------------------------------------------------'
cd downloads

rm tl_2010_78*
rm tl_2010_72*
rm tl_2010_69*
rm tl_2010_66*
rm tl_2010_60*

unzip \*.zip
