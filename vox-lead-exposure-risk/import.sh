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
cd filtered
for f in *.shp
  do ogr2ogr -append -f PostgreSQL -t_srs EPSG:3857 PG:"dbname=censustracts2015" $f -nlt MULTIPOLYGON25D -nln censustracts -progress
  echo $i
done
