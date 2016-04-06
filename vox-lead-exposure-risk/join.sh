# !/bin/bash
echo '-------------------------------------------------------------'
echo 'RUN PYTHON SCRIPT TO JOIN GEOJSON FILE TO LEAD RISK SCORE CSV'
echo '-------------------------------------------------------------'
# If json already exists, delete.
cd exports
if [ 'tracts-data.json' ]; then
    rm tracts-data.json
fi

cd ..
python join-lead-risk-geojson.py
