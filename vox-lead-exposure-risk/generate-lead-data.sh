# !/bin/bash
echo '---------------------------------------------'
echo 'UNZIP ACS 14 5 YR AGE OF HOUSING CENSUS FILES'
echo '---------------------------------------------'
cd b25034-age-of-housing
unzip \*.zip

echo '------------------------------------------------------'
echo 'REMOVE SECOND HEADER ROW FROM HOUSING CSV FOR ANALYSIS'
echo '------------------------------------------------------'
sed '2d' ACS_14_5YR_B25034_with_ann.csv > housing.csv

echo '--------------------------------------'
echo 'UNZIP ACS 14 5 YR POVERTY CENSUS FILES'
echo '--------------------------------------'
cd ..
cd s1701-poverty-status
unzip \*.zip

echo '------------------------------------------------------'
echo 'REMOVE SECOND HEADER ROW FROM POVERTY CSV FOR ANALYSIS'
echo '------------------------------------------------------'
sed '2d' ACS_14_5YR_S1701_with_ann.csv > poverty.csv

echo '--------------------------------------------------------------'
echo 'RUN PYTHON SCRIPT TO CALCULATE LEAD RISK SCORE BY CENSUS TRACT'
echo '--------------------------------------------------------------'
cd ..
python calculate-lead-risk.py
