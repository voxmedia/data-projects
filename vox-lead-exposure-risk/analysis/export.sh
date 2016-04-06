#!/bin/bash
source globals.sh
echo '------------------------'
echo 'CREATE EXPORTS DIRECTORY'
echo '------------------------'
# If downloads directory does not already exist, create.
if [ ! -d 'exports' ]; then
    mkdir exports
fi

cd exports

echo '------------------------'
echo 'EXPORT CSV FROM DATABASE'
echo '------------------------'
# If csv already exists, delete.
if [ 'blocks.csv' ]; then
    rm blocks.csv
fi

psql $PROJECT_NAME -c "COPY (
  SELECT STATEFP10, COUNTYFP10, TRACTCE10, UACE10
  FROM censusblocks
  ) to '`pwd`/blocks.csv' WITH CSV HEADER";
