#!/bin/python

import csv
import json
# clicking on point
# single .json file per provider_id
# generate json from file formatted:
# provider_id, hospital_name, address, city, state, zip_code, phone_number, clabsi_cases, clabsi_days, clabsi_sir 


infile = open('hospitals_clabsi.csv', 'r')
csvreader = csv.reader(infile)
next(csvreader, None)  # skip the headers

for row in csvreader:
    provider_id = row[0]
    outfile = open('render/hospitals/' + provider_id + '.json', 'wb')
    json.dump(row, outfile)
    outfile.close()
infile.close()

