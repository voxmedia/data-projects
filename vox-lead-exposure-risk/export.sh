#!/bin/bash
echo '------------------------'
echo 'CREATE EXPORTS DIRECTORY'
echo '------------------------'
# If downloads directory does not already exist, create.
if [ ! -d 'exports' ]; then
    mkdir exports
fi

cd exports

echo '----------------------------'
echo 'EXPORT GEOJSON FROM DATABASE'
echo '----------------------------'
# If json already exists, delete.
if [ 'tracts.json' ]; then
    rm tracts.json
fi

ogr2ogr -f GeoJSON \
  -t_srs EPSG:4326 -s_srs EPSG:3857 \
  tracts.json \
  "PG:dbname=censustracts2015" \
  -sql "SELECT GEOID, wkb_geometry FROM censustracts";
