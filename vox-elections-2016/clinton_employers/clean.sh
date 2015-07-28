#!/bin/bash

echo "Loading clean employer list..."

mysql clinton_itemized_employers -u root -e "
    CREATE TABLE employer_names(
        employer VARCHAR(255),
        cleaned VARCHAR(255)
    );
    LOAD DATA INFILE '`pwd`/employer_clean.csv' INTO TABLE employer_names 
    FIELDS TERMINATED BY ',' 
        OPTIONALLY ENCLOSED BY '\"'
    LINES TERMINATED BY '\n' 
    IGNORE 1 LINES;"

echo "Joining employer names..."

mysql clinton_itemized_employers -u root -e "
    CREATE TABLE employer_list_pass_2
    SELECT
        original.employer as original,
        clean.cleaned as cleaned,
        original.total
    FROM employer_list_pass_1 original
    LEFT JOIN employer_names clean ON
        original.employer = clean.employer;

    UPDATE employer_list_pass_2
    SET cleaned = TRIM(cleaned);"

echo "Grouping employers by cleaned name..."

# This is your grand table that shows you top donors by employer!
mysql clinton_itemized_employers -u root -e "
    CREATE TABLE employer_grouped
    SELECT
        cleaned as employer,
        sum(total) as employer_total
    FROM employer_list_pass_2
    GROUP BY cleaned
    ORDER BY employer_total DESC;"

        

