#!/bin/python

import csv
import re

with open('itemized.csv', 'rb') as infile, open('itemized_cleaned.csv', 'wb') as outfile:
    reader = csv.reader(infile)

    # skip some rows in `itemized.csv`
    for i in range(0,8):
        next(reader, None)

    writer = csv.writer(outfile, delimiter=',')

    # here's a better header
    writer.writerow([ 'name', 'employer', 'occupation', 'description', 'city', 'state', 'zip', 'date', 'amt', 'memo_cd', 'quarter', 'year', 'image_num', 'transaction_code', 'other_id', 'candidate_id', 'transaction_pgi'])

    for row in reader:
        name = row[0]
        employer = row [1]
        occupation  = row[2]
        description = row[3]
        city = row[4]
        state = row[5]
        zip = row[6]
        date = row[7]
        amt = row[8]
        memo_cd = row[9]
        quarter = row[10]
        year = row[11]
        image_num = row[12]
        transaction_code = row[13]
        other_id = row[14]
        candidate_id = row[15]
        transaction_pgi = row[16]

        # Clean up amount
        amt = amt.replace("$", "")
        amt = amt.replace(",", "")
        amt = amt.replace("(", "")
        amt = amt.replace(")", "")

        writer.writerow([ name, employer, occupation, description, city, state, zip, date, amt, memo_cd, quarter, year, image_num, transaction_code, other_id, candidate_id, transaction_pgi])

