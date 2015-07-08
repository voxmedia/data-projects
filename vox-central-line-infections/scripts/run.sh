#!/bin/bash

# Un-comment download.sh and comment out copy.sh 
# if you prefer to download the data from data.gov.
# The download script might break things if the 
# links change.

# ./download.sh
./copy.sh

# Assemble all the data into a csv
./build.sh

# Uncomment render.sh if you want a whole mess 
# of json files to build a web app.
./render.sh