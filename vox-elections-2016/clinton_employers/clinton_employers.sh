#!/bin/bash

echo "Creating a database..."

mysql -u root -e "CREATE DATABASE clinton_employers;"

echo "Loading data into the table..."

mysql clinton_employers -u root -e "CREATE TABLE individual_contributions(
    cmte_id VARCHAR(255),
    amndt_ind VARCHAR(255),
    rpt_tp VARCHAR(255),
    transaction_pgi VARCHAR(255),
    image_num VARCHAR(255),
    transaction_tp VARCHAR(255),
    entity_tp VARCHAR(255),
    name VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    zip_code VARCHAR(255),
    employer VARCHAR(255),
    occupation VARCHAR(255),
    transaction_dt VARCHAR(255),
    transaction_amt DECIMAL(10,2),
    other_id VARCHAR(255),
    tran_id VARCHAR(255),
    file_num VARCHAR(255),
    memo_cd VARCHAR(255),
    memo_text VARCHAR(255),
    sub_id VARCHAR(255)
);"

# I manually cleaned up `itcont.txt` to get it to load into 
# the table correctly. 
# If you want to download `itcont.txt` directly from the FEC,
# you'll get errors for each row that'll look like:
#
#   ERROR 1261 (01000) at line 1: Row 119146 doesn't contain 
#   data for all columns
#
# or
#
#   ERROR 1366 (HY000) at line 1: Incorrect decimal value: '' 
#   for column 'TRANSACTION_AMT' at row 119146
#
#
# Go into the row (there were less than a handful) and look 
# for an annoying backslash that shouldn't be there. Delete 
# that backslash.

mysql clinton_employers -u root -e "LOAD DATA INFILE '`pwd`/itcont_cleaned.txt' INTO TABLE individual_contributions 
    FIELDS TERMINATED BY '|' 
    LINES TERMINATED BY '\n' 
    IGNORE 1 LINES;"


# Clinton's codes for transaction_tp
# 11 Tribal Contribution
# 15 Contribution
# 15C Contribution from Candidate
# 15E Earmarked Contribution
# 22Y Contribution Refund to Individual

echo "Creating a table of contributions..."

# Filter table by committee (Hillary for America), entity type (individual, 
# not candidate), and transaction type (contribution, not a refund). Then, 
# create a new table, grouping the refunds # by name and zip, since some 
# folks gave multiple times.

mysql clinton_employers -u root -e "
    CREATE TEMPORARY TABLE clinton_contribs
    SELECT  
        *
    FROM individual_contributions
    WHERE cmte_id = 'C00575795' AND
        entity_tp = 'IND' AND
        transaction_tp != '22Y';

    CREATE TABLE clinton_contribs_grouped
    SELECT  
        name,
        city,
        state,
        left(zip_code, 5) AS zip_code_5,
        employer,
        occupation,
        sum(transaction_amt) AS contrib_amts
    FROM clinton_contribs
    GROUP BY name, zip_code_5;"

echo "Creating a table of refunds..."

# Filter table by committee (Hillary for America), entity type (individual, 
# not candidate), and transaction type (refund). Then, 
# create a new table, grouping the refunds # by name and zip, since some 
# folks got multiple refunds.

mysql clinton_employers -u root -e "
    CREATE TEMPORARY TABLE clinton_refunds
    SELECT  
        *
    FROM individual_contributions
    WHERE cmte_id = 'C00575795' AND
        entity_tp = 'IND' AND 
        transaction_tp = '22Y';

    CREATE TABLE clinton_refunds_grouped
    SELECT 
        name,
        left(zip_code, 5) AS zip_code_5,
        sum(transaction_amt) AS refund_amts
    FROM clinton_refunds
    GROUP BY name, zip_code_5;"

echo "Joining the tables..."

# Left join contribs and refunds because it doesn't matter if 
# donor refunds don't match up with donor contributions. Clinton's 
# refunds data did not include occupations or employers, so we can't 
# subtract the refunds from employers unless the donors were also
# contributors.

mysql clinton_employers -u root -e "
    CREATE TABLE clinton_individual_contributions
    SELECT
        contribs.name AS name,
        contribs.city AS city,
        contribs.state AS state,
        contribs.zip_code_5 AS zip_code,
        contribs.employer AS employer,
        contribs.occupation AS occupation,
        contribs.contrib_amts AS contrib_amts,
        IFNULL(refunds.refund_amts,0) AS refund_amts,
        (contribs.contrib_amts - IFNULL(refunds.refund_amts,0)) AS total_contribution
    FROM clinton_contribs_grouped contribs
    LEFT JOIN clinton_refunds_grouped refunds ON
        contribs.name = refunds.name AND
        contribs.zip_code_5 = refunds.zip_code_5
    ;"

echo "Creating the table to start your cleanup work..."

# Group total contributions by employer, excluding 
# retirees and students.

mysql clinton_employers -u root -e "
    CREATE TABLE clinton_employers_grouped
    SELECT
        employer,
        SUM(total_contribution) AS contribution
    FROM clinton_individual_contributions
    WHERE 
        employer !='' AND
        employer !='N/A' AND
        employer !='NOT EMPLOYED' AND 
        employer !='SELF-EMPLOYED' AND
        employer !='SELF EMPLOYED' AND
        employer !='SELF- EMPLOYED' AND
        employer NOT LIKE '%RETIRED%' AND
        occupation NOT LIKE '%STUDENT%' AND
        occupation NOT LIKE '%RETIRED%' AND
        occupation NOT LIKE '%RETIREE%' 
    GROUP BY employer;"

echo "Exporting a csv to clean up..."

mysql clinton_employers -u root -e "
    SELECT 
        *
    INTO OUTFILE '`pwd`/clinton_employers_ready_to_clean.csv' 
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"'
    LINES TERMINATED BY '\n'
    FROM clinton_employers_grouped
;"

echo "Created clinton_employers_ready_to_clean.csv. Ready for manual cleanup."