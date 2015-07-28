#!/bin/bash

echo "Cleaning up itemized.csv..."

# Amounts are literal strings, convert them to decimals. 

python itemized.py

echo "Loading in data..."

mysql clinton_itemized_employers -u root -e "
    CREATE TABLE itemized(
        name VARCHAR(255),
        employer VARCHAR(255),
        occupation VARCHAR(255),
        description VARCHAR(255),
        city VARCHAR(255),
        state VARCHAR(255),
        zip VARCHAR(255),
        date VARCHAR(255),
        amt DECIMAL(10,2),
        memo_cd VARCHAR(255),
        quarter VARCHAR(255),
        year VARCHAR(255),
        image_num VARCHAR(255),
        transaction_code VARCHAR(255),
        other_id VARCHAR(255),
        candidate_id VARCHAR(255),
        transaction_pgi VARCHAR(255) 
    );

    LOAD DATA INFILE '`pwd`/itemized_cleaned.csv' INTO TABLE itemized 
    FIELDS TERMINATED BY ',' 
        OPTIONALLY ENCLOSED BY '\"'
    LINES TERMINATED BY '\n' 
    IGNORE 1 LINES;"


echo "Minor cleanup on honorifics..."
mysql clinton_itemized_employers -u root -e "
    UPDATE itemized
    SET name = REPLACE(name, ' MS.', '');
    UPDATE itemized
    SET name = REPLACE(name, ' MRS.', '');
    UPDATE itemized
    SET name = REPLACE(name, ' MR.', '');
    UPDATE itemized
    SET name = REPLACE(name, ' DR.', '');
    UPDATE itemized
    SET name = REPLACE(name, ' HON.', '');
    UPDATE itemized
    SET name = REPLACE(name, ' REV.', '');"


echo "Cleaning up the table..."
# Make any "insufficient funds" a negative number. How do I know to do this? Researched it.

mysql clinton_itemized_employers -u root -e "
    UPDATE itemized
    SET amt = amt * -1
    WHERE description LIKE '%insufficient%funds%';"

echo "Making a refunds table..."
# Separate the refunds
mysql clinton_itemized_employers -u root -e "
    CREATE TABLE itemized_refunds
    SELECT
        name, employer, occupation, city, state, zip, amt, description, memo_cd
    FROM itemized
    WHERE
        name != 'ACTBLUE' AND
        name != 'EMILY\'S LIST' AND
        description LIKE '%refund%'; "

echo "Cleaning up the table again..."

# OK, so we only needed the table up there to check who is on the 
# refunds list in master_refunds_grouped AND is in itemized without 
# a matching contribution. There are only 2 names that make a match. 
# So let's just update itemized with the correct numbers and clear out
# the description and throw away those extra refunds that don't match
# up.

mysql clinton_itemized_employers -u root -e "
    UPDATE itemized
    SET amt = -10.00
    WHERE name = 'AMINULLAH, MOHAMMED' AND description != '';

    UPDATE itemized
    SET description = ''
    WHERE name = 'AMINULLAH, MOHAMMED' AND description != '';

    UPDATE itemized
    SET amt = amt * -1
    WHERE name = 'PRITZKER, J.B.' AND description != '';

    UPDATE itemized
    SET description = ''
    WHERE name = 'PRITZKER, J.B.' AND description != ''; "


echo "Creating itemized group table..."

# Create an itemized group table

mysql clinton_itemized_employers -u root -e "
    CREATE TABLE itemized_individual_contributions
    SELECT
        name, employer, occupation, city, state, zip, sum(amt) as total_transaction
    FROM itemized
    WHERE
        name != 'ACTBLUE' AND
        name != 'EMILY\'S LIST' AND
        memo_cd != 'X' AND
        description NOT LIKE '%refund%'
    GROUP BY name, zip; "

echo "Joining tables, part 1..."

mysql clinton_itemized_employers -u root -e "
    CREATE TABLE itemized_master_pass_1
    SELECT
        i.name,
        i.employer,
        i.occupation,
        i.city,
        i.state,
        i.zip,
        i.total_transaction AS itemized_contrib,
        m.contrib_amts AS master_contrib,
        m.refund_amts AS master_refund
    FROM itemized_individual_contributions i
    LEFT JOIN master_individual_contributions m ON 
        i.name = m.name AND
        i.zip = m.zip_code
    UNION ALL
    SELECT
        m.name,
        m.employer,
        m.occupation,
        m.city,
        m.state,
        m.zip_code,
        i.total_transaction AS itemized_contrib,
        m.contrib_amts AS master_contrib,
        m.refund_amts AS master_refund
    FROM itemized_individual_contributions i
    RIGHT JOIN master_individual_contributions m ON 
        i.name = m.name AND
        i.zip = m.zip_code
    WHERE i.name IS NULL AND 
        i.zip IS NULL;"

echo "Joining tables, part 2..."

mysql clinton_itemized_employers -u root -e "
    CREATE TABLE itemized_master_pass_2
    SELECT
        i.name,
        i.city,
        i.zip,
        i.employer,
        i.occupation,
        i.itemized_contrib,
        i.master_contrib,
        i.master_refund,
        n.refund_amts as master_refunds_nm
    FROM itemized_master_pass_1 i
    LEFT JOIN master_refunds_no_match n ON
        i.name = n.refunds_name AND
        i.zip = n.refunds_zip_code
    UNION ALL
    SELECT
        n.refunds_name as name,
        i.city,
        n.refunds_zip_code,
        i.employer,
        i.occupation,
        i.itemized_contrib,
        i.master_contrib,
        i.master_refund,
        n.refund_amts as master_refunds_nm
    FROM itemized_master_pass_1 i
    RIGHT JOIN master_refunds_no_match n ON
        i.name = n.refunds_name AND
        i.zip = n.refunds_zip_code
    WHERE i.name IS NULL AND 
        i.zip IS NULL;"

echo "Cleaning up totals..."

mysql clinton_itemized_employers -u root -e "
    ALTER TABLE itemized_master_pass_2
    ADD total DECIMAL(10,2);

    UPDATE itemized_master_pass_2
    SET total = itemized_contrib
    WHERE itemized_contrib < master_contrib;

    UPDATE itemized_master_pass_2
    SET total = master_contrib - master_refund
    WHERE itemized_contrib = master_contrib;

    UPDATE itemized_master_pass_2
    SET total = itemized_contrib - master_refund
    WHERE itemized_contrib > master_contrib;

    UPDATE itemized_master_pass_2
    SET total = IFNULL(itemized_contrib, 0) - IFNULL(master_refunds_nm, 0)
    WHERE master_contrib IS NULL AND master_refund IS NULL;

    UPDATE itemized_master_pass_2
    SET total = master_contrib - master_refund
    WHERE itemized_contrib IS NULL AND master_refunds_nm IS NULL;"

echo "Creating master list clinton_individual_contributions..."

mysql clinton_itemized_employers -u root -e "
    CREATE TABLE clinton_individual_contributions
    SELECT 
        name,
        city,
        zip,
        employer,
        occupation,
        total
    FROM itemized_master_pass_2
    WHERE total > 0;"


mysql clinton_itemized_employers -u root -e "
    CREATE TABLE clinton_individual_contributions_employers
    SELECT 
        *
    FROM clinton_individual_contributions
    WHERE employer != '' AND
        employer != 'N/A' AND
        employer != 'NOT EMPLOYED' AND 
        employer != 'SELF-EMPLOYED' AND
        employer != 'SELF EMPLOYED' AND
        employer != 'SELF- EMPLOYED' AND
        employer NOT LIKE '%RETIRED%' AND
        occupation NOT LIKE '%RETIRED%' AND
        (occupation NOT LIKE '%STUDENT%' OR
        occupation LIKE '%DEAN%' OR
        occupation LIKE '%AFFAIRS%');

    CREATE TABLE employer_list_pass_1
    SELECT 
        trim(employer) as employer,
        sum(total) as total
    FROM clinton_individual_contributions_employers
    GROUP BY employer
    ORDER BY employer;"

