#!/bin/bash

# Create a new database
mysql -u root -e "CREATE DATABASE clinton_itemized_employers;"

echo "Loading master file of individual contributions..."

# I manually cleaned up `itcont.txt` to get it to load into 
# the table correctly. 
# If you want to download `itcont.txt` directly from the FEC,
# you'll get errors for each row that'll look like:
#   ERROR 1261 (01000) at line 1: Row 119146 doesn't contain 
#   data for all columns
# or
#   ERROR 1366 (HY000) at line 1: Incorrect decimal value: '' 
#   for column 'TRANSACTION_AMT' at row 119146
# Go into the row (there were less than a handful) and look 
# for an annoying backslash that shouldn't be there. Delete 
# that backslash.

mysql clinton_itemized_employers -u root -e "
    CREATE TABLE master_contributions(
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
    );

    LOAD DATA INFILE '`pwd`/itcont_cleaned.txt' INTO TABLE master_contributions 
    FIELDS TERMINATED BY '|' 
    LINES TERMINATED BY '\n' 
    IGNORE 1 LINES;"


echo "Minor cleanup on honorifics..."
mysql clinton_itemized_employers -u root -e "
    UPDATE master_contributions
    SET name = REPLACE(name, ' MS.', '');
    UPDATE master_contributions
    SET name = REPLACE(name, ' MRS.', '');
    UPDATE master_contributions
    SET name = REPLACE(name, ' MR.', '');
    UPDATE master_contributions
    SET name = REPLACE(name, ' DR.', '');
    UPDATE master_contributions
    SET name = REPLACE(name, ' HON.', '');
    UPDATE master_contributions
    SET name = REPLACE(name, ' REV.', '');"

echo "Creating a table of contributions..."

# Filter table by committee (Hillary for America), entity type (individual, 
# not candidate), and transaction type (contribution, not a refund). Then, 
# create a new table, grouping the refunds # by name and zip, since some 
# folks gave multiple times.

# Clinton's codes for transaction_tp
# 11 Tribal Contribution
# 15 Contribution
# 15C Contribution from Candidate
# 15E Earmarked Contribution
# 22Y Contribution Refund to Individual

mysql clinton_itemized_employers -u root -e "
    CREATE TEMPORARY TABLE master_contribs
    SELECT  
        *
    FROM master_contributions
    WHERE cmte_id = 'C00575795' AND
        entity_tp = 'IND' AND
        transaction_tp != '22Y' AND
        memo_cd != 'X';

    CREATE TABLE master_contribs_grouped
    SELECT  
        name,
        city,
        state,
        left(zip_code, 5) AS zip,
        employer,
        occupation,
        sum(transaction_amt) AS contrib_amts
    FROM master_contribs
    GROUP BY name, zip;"

echo "Creating a table of refunds..."

# Filter table by committee (Hillary for America), entity type (individual, 
# not candidate), and transaction type (refund). Then, 
# create a new table, grouping the refunds # by name and zip, since some 
# folks got multiple refunds.

mysql clinton_itemized_employers -u root -e "
    CREATE TEMPORARY TABLE master_refunds
    SELECT  
        *
    FROM master_contributions
    WHERE cmte_id = 'C00575795' AND
        entity_tp = 'IND' AND 
        transaction_tp = '22Y' AND
        memo_cd != 'X';

    CREATE TABLE master_refunds_grouped
    SELECT 
        name,
        left(zip_code, 5) AS zip,
        sum(transaction_amt) AS refund_amts
    FROM master_refunds
    GROUP BY name, zip;"


echo "Creating clinton_individual_contributions for matched refunds..."

# Left join contribs and refunds because it doesn't matter if 
# donor refunds don't match up with donor contributions. Clinton's 
# refunds data did not include occupations or employers, so we can't 
# subtract the refunds from employers unless the donors were also
# contributors.

mysql clinton_itemized_employers -u root -e "
    CREATE TABLE master_individual_contributions
    SELECT
        contribs.name AS name,
        contribs.city AS city,
        contribs.state AS state,
        contribs.zip AS zip_code,
        contribs.employer AS employer,
        contribs.occupation AS occupation,
        contribs.contrib_amts AS contrib_amts,
        IFNULL(refunds.refund_amts,0) AS refund_amts,
        (contribs.contrib_amts - IFNULL(refunds.refund_amts,0)) AS total_contribution
    FROM master_contribs_grouped contribs
    LEFT JOIN master_refunds_grouped refunds ON
        contribs.name = refunds.name AND
        contribs.zip = refunds.zip
    ;"

echo "Creating table for refunds that didn't match up..."

# We can still try to match up those unmatched refunds with Clinton's own dataset.

mysql clinton_itemized_employers -u root -e "
    CREATE TABLE master_refunds_no_match
    SELECT
        refunds.name AS refunds_name,
        refunds.zip AS refunds_zip_code,
        IFNULL(refunds.refund_amts,0) AS refund_amts
    FROM master_contribs_grouped contribs
    RIGHT JOIN master_refunds_grouped refunds ON
        contribs.name = refunds.name AND
        contribs.zip = refunds.zip
    WHERE contribs.name IS NULL
;"