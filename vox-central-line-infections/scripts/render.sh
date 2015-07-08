#!/bin/bash

# Make the render directory.
if [ ! -d "render" ]; then
    mkdir render
fi

echo 'Creating first json layer with hospital points...'

# Create a new csv `points.csv` with a header row
echo 'i,lat,lng,o,d' > points.csv

# In the state column, reverse grep for territories,
# cut out the following columns: 
#  1: provider_id
#  7: lat
#  8: lng
# 12: observed
# 13: days
# skip the header,
# shorten "Not Available",
# and send it all to `points.csv`.
csvgrep -c 'state' -r 'GU|MP|PR|VI' -i hospitals_clabsi.csv | csvcut -c 1,7,8,12,13 | tail -n +2 | sed -E 's/Not Available/NA/g' >> points.csv

# Let's create the first json file.
csvjson points.csv > render/hospitals.json

# Un-comment the two lines below if you want to create separate json files for
# hospitals in the data that reported central line infections and those that didn't.
# csvgrep -c 'o' -r 'NA' -i points.csv | csvjson > render/hospitals_info.json
# csvgrep -c 'o' -r 'NA' points.csv | csvjson > render/hospitals_na.json

echo 'Creating individual hospital json...'
# Create the `render/hospitals` folder.
if [ ! -d "render/hospitals" ]; then
    mkdir render/hospitals
fi

# `render.py` creates over 4k json files (for each hospital)
python render.py

# Clean up points.csv
rm points.csv

echo 'Rendering files for web complete. Check `render` directory.'
