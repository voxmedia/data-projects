# !/bin/bash
echo '-------------------------'
echo 'CREATE FILTERED DIRECTORY'
echo '-------------------------'
# If directory does not already exist, create.
if [ ! -d 'filtered' ]; then
    mkdir filtered
fi

echo '-------------------------------------------------'
echo 'DELETE US TERRITORY ZIPFILES AND UNZIP SHAPEFILES'
echo '-------------------------------------------------'
cd downloads

rm tl_2015_60_tract.zip
rm tl_2015_66_tract.zip
rm tl_2015_69_tract.zip
rm tl_2015_72_tract.zip
rm tl_2015_78_tract.zip

unzip \*.zip

echo '-----------------------------------------------------------------------------'
echo 'REMOVE WATER CENSUS TRACTS (E.G., GREAT LAKES) AND MOVE TO FILTERED DIRECTORY'
echo '-----------------------------------------------------------------------------'
# https://www.census.gov/geo/reference/gtc/gtc_ct.html
# Census tracts with tractce codes of 9900 are census tracts delineated specifically to cover large bodies of water.
# This is different from Census 2000 when water-only census tracts were assigned codes of all zeroes (000000).
# 000000 is no longer used as a census tract code for the 2010 Census.
basename -s.shp *.shp | xargs -n1 -I % ogr2ogr %-filtered.shp %.shp -sql "SELECT * FROM '%' WHERE 'TRACTCE' <> '990000'"

# Move filtered shapefiles to filtered folder
mv *tract-filtered* ../filtered
