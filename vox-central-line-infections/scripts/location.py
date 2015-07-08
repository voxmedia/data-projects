#!/bin/python

import csv
import re

# open up `hospitals_temp.csv` and write to `hospitals_info.csv`
with open('hospitals_temp.csv', 'rb') as infile, open('hospitals_info.csv', 'wb') as outfile:

    reader = csv.reader(infile)

    # skip header in `hospitals_temp.csv`
    next(reader, None)

    writer = csv.writer(outfile, delimiter=',', quoting=csv.QUOTE_MINIMAL)

    # here's a better header
    writer.writerow(['Provider ID', 'Hospital Name', 'Address', 'City', 'State', 'ZIP Code', 'lat', 'lng'])

    for row in reader:
        provider_id = row[0]
        name = row[1]
        street = row[2]
        city = row[3]
        state = row[4]
        zip_code = row[5]
        location = row[6]

        # `match` looks for a latitude and longitude. Considering 
        # the geography of the U.S. (and most of its territories), 
        # the first number will always be positive (north), while 
        # the second number will always be negative (west) (except 
        # for some islands in Alaska that don't have hospitals).
        match = re.search( r'\d*\.\d*, .\d*\.\d*', location )

        if match:
            # if we get a match, then split the match by the comma, and write a row in the new csv
            point_string = match.group()
            point_array = [n.strip() for n in point_string.split(',')]
            writer.writerow([provider_id,name,street,city,state,zip_code,point_array[0],point_array[1]])
        else:
            # all the csvs will match, so this case will never happen
            writer.writerow([provider_id,name,street,city,state,zip_code,'NA','NA'])
