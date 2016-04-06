# !/bin/bash
echo '-------------------------------'
echo 'CONVERT GEOJSON TO VECTOR TILES'
echo '-------------------------------'
cd exports
# If mbtiles already exist, delete.
if [ 'tracts.mbtiles' ]; then
    rm tracts.mbtiles
fi

tippecanoe -o tracts.mbtiles tracts-data.json
