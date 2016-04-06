#!/bin/bash
source globals.sh
echo '-----------------------------------------'
echo 'CREATE SPATIALLY ENABLED POSTGIS DATABASE'
echo '-----------------------------------------'
dropdb --if-exists $PROJECT_NAME
createdb $PROJECT_NAME
psql $PROJECT_NAME -c "CREATE EXTENSION postgis;"

echo '--------------------------------------------'
echo 'INSERT SHAPEFILES INTO ONE TABLE IN DATABASE'
echo '--------------------------------------------'
cd downloads
for f in *.shp
  do ogr2ogr -append -f PostgreSQL -t_srs EPSG:3857 PG:"dbname=censusfaces2010" $f -nlt MULTIPOLYGON25D -nln censusblocks -progress
  echo $i
done
