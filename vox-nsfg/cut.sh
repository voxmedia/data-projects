#!/bin/bash

echo '- Extracting data into extract folder...'

if [ ! -d "extract" ]; then
    # Make a new directory called 'analysis'
    mkdir extract
fi

# ================================================================
#
# 2011 - 2013 DATA
#
# ================================================================

# --------------------------------
#     FEMALE
# --------------------------------
# data/2011_2013_female.dat
# ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NSFG/sas/2011_2013_FemRespSetup.sas
# --------------------------------


# MARSTAT  - 21
# "AB-1 R'S MARITAL STATUS"
  # 1 = "MARRIED TO A PERSON OF THE OPPOSITE SEX"
  # 2 = "NOT MARRIED BUT LIVING TOGETHER WITH A PARTNER OF THE OPPOSITE SEX"
  # 3 = "WIDOWED"
  # 4 = "DIVORCED OR ANNULLED"
  # 5 = "SEPARATED, BECAUSE YOU AND YOUR SPOUSE ARE NOT GETTING ALONG"
  # 6 = "NEVER BEEN MARRIED"
  # 9 = "DON'T KNOW" 
# RELCURR  - 3493-3494
# "IC-5/IC-6 RELIGION R IS NOW"
  # 1 = "NO RELIGION"
  # 2 = "CATHOLIC"
  # 3 = "BAPTIST/SOUTHERN BAPTIST"
  # 4 = "METHODIST, LUTHERAN, PRESBYTERIAN, EPISCOPAL"
  # 5 = "FUNDAMENTALIST PROTESTANT"
  # 6 = "OTHER PROTESTANT DENOMINATION"
  # 7 = "PROTESTANT - NO SPECIFIC DENOMINATION"
  # 8 = "OTHER RELIGION"
  # 9 = "REFUSED"
  # 10 = "DON'T KNOW" 
# RELDLIFE - 3500
# "IC-9 HOW IMPORTANT IS RELIGION IN R'S DAILY LIFE"
  # 1 = "VERY IMPORTANT"
  # 2 = "SOMEWHAT IMPORTANT"
  # 3 = "NOT IMPORTANT"
  # 7 = "NOT ASCERTAINED"
  # 8 = "REFUSED" 
# STAYTOG  - 3528
# "IH-2 DIVORCE BEST SOLUTION WHEN CANNOT WORK OUT MARRIAGE PROBLEMS"
  # 1 = "STRONGLY AGREE"
  # 2 = "AGREE"
  # 3 = "DISAGREE"
  # 4 = "STRONGLY DISAGREE"
  # 5 = "IF R INSISTS: NEITHER AGREE NOR DISAGREE"
  # 8 = "REFUSED"
  # 9 = "DON'T KNOW"
# AGER = "R'S AGE AT INTERVIEW (RECODE)" - 3751-3752
  # 15 = "15 YEARS"
  # 16 = "16 YEARS"
  # 17 = "17 YEARS"
  # 18 = "18 YEARS"
  # 19 = "19 YEARS"
  # 20 = "20 YEARS"
  # 21 = "21 YEARS"
  # 22 = "22 YEARS"
  # 23 = "23 YEARS"
  # 24 = "24 YEARS"
  # 25 = "25 YEARS"
  # 26 = "26 YEARS"
  # 27 = "27 YEARS"
  # 28 = "28 YEARS"
  # 29 = "29 YEARS"
  # 30 = "30 YEARS"
  # 31 = "31 YEARS"
  # 32 = "32 YEARS"
  # 33 = "33 YEARS"
  # 34 = "34 YEARS"
  # 35 = "35 YEARS"
  # 36 = "36 YEARS"
  # 37 = "37 YEARS"
  # 38 = "38 YEARS"
  # 39 = "39 YEARS"
  # 40 = "40 YEARS"
  # 41 = "41 YEARS"
  # 42 = "42 YEARS"
  # 43 = "43 YEARS"
  # 44-45 = "44 YEARS" ;
# HIEDUC   - 3757-3758
# "HIGHEST COMPLETED YEAR OF SCHOOL OR HIGHEST DEGREE RECEIVED (RECODE)"
  # 5 = "9TH GRADE OR LESS"
  # 6 = "10TH GRADE"
  # 7 = "11TH GRADE"
  # 8 = "12TH GRADE, NO DIPLOMA (NOR GED)"
  # 9 = "HIGH SCHOOL GRADUATE (DIPLOMA OR GED)"
  # 10 = "SOME COLLEGE BUT NO DEGREE"
  # 11 = "ASSOCIATE DEGREE IN COLLEGE/UNIVERSITY"
  # 12 = "BACHELOR'S DEGREE"
  # 13 = "MASTER'S DEGREE"
  # 14 = "DOCTORATE DEGREE"
  # 15 = "PROFESSIONAL DEGREE" 


cut -c21,3493,3494,3500,3528,3751,3752,3757,3758 data/2011_2013_female.dat > extract/2011_2013_female_raw.txt

# --------------------------------
#      MALE
# --------------------------------
# data/2011_2013_male.dat
# ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NSFG/sas/2011_2013_MaleSetup.sas
# --------------------------------

# MARSTAT  - 21
# "AB-1 R'S MARITAL STATUS"
  # 1 = "Married to a person of the opposite sex"
  # 2 = "Not married but living together with a partner of the opposite sex"
  # 3 = "Widowed"
  # 4 = "Divorced or annulled"
  # 5 = "Separated, because you and your spouse are not getting along"
  # 6 = "Never been married" 
# RELCURR  - 3923-3924
# "JB-5/JB-6 RELIGION R IS NOW"
  # 1 = "None"
  # 2 = "Catholic"
  # 3 = "Baptist/Southern Baptist"
  # 4 = "Methodist, Lutheran, Presbyterian, Episcopal"
  # 5 = "Fundamentalist Protestant"
  # 6 = "Other Protestant denomination"
  # 7 = "Protestant - No specific denomination"
  # 8 = "Other religion"
  # 9 = "Refused"
  # 10 = "Don't know" 
# RELDLIFE - 3930
# "JB-9 HOW IMPORTANT IS RELIGION IN R'S DAILY LIFE"
  # 1 = "Very important"
  # 2 = "Somewhat important"
  # 3 = "Not important"
  # 8 = "Refused" 
# STAYTOG  - 3960
# "JG-2 DIVORCE IS BEST SOLUTION WHEN A COUPLE CANNOT WORK OUT MARRIAGE PROBLEMS"
  # 1 = "STRONGLY AGREE"
  # 2 = "AGREE"
  # 3 = "DISAGREE"
  # 4 = "STRONGLY DISAGREE"
  # 5 = "IF R INSISTS: NEITHER AGREE NOR DISAGREE"
  # 8 = "REFUSED"
  # 9 = "DON'T KNOW"
# AGER - 4227-4228
# HIEDUC   - 4233-4234
# "HIGHEST COMPLETED YEAR OF SCHOOL OR HIGHEST DEGREE RECEIVED (RECODE)"
  # 5 = "9TH GRADE OR LESS"
  # 6 = "10TH GRADE"
  # 7 = "11TH GRADE"
  # 8 = "12TH GRADE, NO DIPLOMA (NOR GED)"
  # 9 = "HIGH SCHOOL GRADUATE (DIPLOMA OR GED)"
  # 10 = "SOME COLLEGE BUT NO DEGREE"
  # 11 = "ASSOCIATE DEGREE IN COLLEGE/UNIVERSITY"
  # 12 = "BACHELOR'S DEGREE"
  # 13 = "MASTER'S DEGREE"
  # 14 = "DOCTORATE DEGREE"
  # 15 = "PROFESSIONAL DEGREE" 

cut -c21,3923,3924,3930,3960,4227,4228,4233,4234 data/2011_2013_male.dat > extract/2011_2013_male_raw.txt

# ================================================================
#
# 2006 - 2010 DATA
#
# ================================================================

# --------------------------------
#     FEMALE
# --------------------------------
# data/2006_2010_female.dat
# ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NSFG/sas/2006_2010_FemRespSetup.sas
# --------------------------------

# MARSTAT  - 21
# "AB-1 R's marital status"
  # 1 = 'Married'  
  # 2 = 'Not married but living together with a partner of the opposite sex'  
  # 3 = 'Widowed'  
  # 4 = 'Divorced'  
  # 5 = 'Separated, because you and your spouse are not getting along'  
  # 6 = 'Never been married'  
  # 8 = 'Refused'  
  # 9 = 'Don''t know'
# RELCURR  - 4728-4729
# "IC-5/IC-6 Religion R is now"
  # 1 = 'No religion'  
  # 2 = 'Catholic'  
  # 3 = 'Baptist/Southern Baptist'  
  # 4 = 'Methodist, Lutheran, Presbyterian, Episcopal'  
  # 5 = 'Fundamentalist Protestant'  
  # 6 = 'Other Protestant denomination'  
  # 7 = 'Protestant - No specific denomination'  
  # 8 = 'Other religion'  
  # 9 = 'Refused'  
  # 10 = 'Don''t know'
# RELDLIFE - 4735
# "IC-9 How important is religion in R's daily life"
  # 1 = 'Very important'  
  # 2 = 'Somewhat important'  
  # 3 = 'Not important'  
  # 8 = 'Refused'  
  # 9 = 'Don''t know'
# STAYTOG  - 4792
# "IH-2 Divorce best solution when cannot work out marriage problems"
  # 1 = 'Strongly agree'  
  # 2 = 'Agree'  
  # 3 = 'Disagree'  
  # 4 = 'Strongly disagree'  
  # 5 = 'If R insists: Neither agree nor disagree'  
  # 8 = 'Refused'  
  # 9 = 'Don''t know'
# AGER - 4853-4854 
# HIEDUC   - 4859-4860
# "Highest completed year of school or highest degree received (RECODE)"
  # 5 = '9TH GRADE OR LESS'  
  # 6 = '10TH GRADE'  
  # 7 = '11TH GRADE'  
  # 8 = '12TH GRADE, NO DIPLOMA (NOR GED)'  
  # 9 = 'HIGH SCHOOL GRADUATE (DIPLOMA OR GED)'  
  # 10 = 'SOME COLLEGE BUT NO DEGREE'  
  # 11 = 'ASSOCIATE DEGREE IN COLLEGE/UNIVERSITY'  
  # 12 = 'BACHELOR''S DEGREE'  
  # 13 = 'MASTER''S DEGREE'  
  # 14 = 'DOCTORATE DEGREE'  
  # 15 = 'PROFESSIONAL DEGREE'

cut -c21,4728,4729,4735,4792,4853,4854,4859,4860 data/2006_2010_female.dat > extract/2006_2010_female_raw.txt

# --------------------------------
#      MALE
# --------------------------------
# data/2006_2010_male.dat
# ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NSFG/sas/2006_2010_MaleSetup.sas
# --------------------------------

# MARSTAT  - 22
# "AB-1 R's marital status"
  # 1 = 'Married'  
  # 2 = 'Not married but living together with a partner of the opposite sex'  
  # 3 = 'Widowed'  
  # 4 = 'Divorced'  
  # 5 = 'Separated, because you and your spouse are not getting along'  
  # 6 = 'Never been married'  
  # 8 = 'Refused'  
  # 9 = 'Don''t know' 
# RELCURR  - 3891-3892
# "JB-5/JB-6 Religion R is now"
  # 1 = 'No religion'  
  # 2 = 'Catholic'  
  # 3 = 'Baptist/Southern Baptist'  
  # 4 = 'Methodist, Lutheran, Presbyterian, Episcopal'  
  # 5 = 'Fundamentalist Protestant'  
  # 6 = 'Other Protestant denomination'  
  # 7 = 'Protestant - No specific denomination'  
  # 8 = 'Other religion'  
  # 9 = 'Refused'  
  # 10 = 'Don''t know' 
# RELDLIFE - 3898
# "JB-9 How important is religion in R's daily life"
  # 1 = 'Very important'  
  # 2 = 'Somewhat important'  
  # 3 = 'Not important'  
  # 8 = 'Refused'  
  # 9 = 'Don''t know'
# STAYTOG  - 3942
# "JG-2 Divorce best solution when cannot work out marriage problems"
  # 1 = 'Strongly agree'  
  # 2 = 'Agree'  
  # 3 = 'Disagree'  
  # 4 = 'Strongly disagree'  
  # 5 = 'If R insists: Neither agree nor disagree'  
  # 8 = 'Refused'  
  # 9 = 'Don''t know'
# AGER - 4007-4008
# HIEDUC   - 4013-4014
# "Highest completed year of school or highest degree received  (RECODE)"
  # 5 = '9TH GRADE OR LESS'  
  # 6 = '10TH GRADE'  
  # 7 = '11TH GRADE'  
  # 8 = '12TH GRADE, NO DIPLOMA (NOR GED)'  
  # 9 = 'HIGH SCHOOL GRADUATE (DIPLOMA OR GED)'  
  # 10 = 'SOME COLLEGE BUT NO DEGREE'  
  # 11 = 'ASSOCIATE DEGREE IN COLLEGE/UNIVERSITY'  
  # 12 = 'BACHELOR''S DEGREE'  
  # 13 = 'MASTER''S DEGREE'  
  # 14 = 'DOCTORATE DEGREE'  
  # 15 = 'PROFESSIONAL DEGREE'

cut -c22,3891,3892,3898,3942,4007,4008,4013,4014 data/2006_2010_male.dat > extract/2006_2010_male_raw.txt


# ================================================================
#
# 2002 DATA
#
# ================================================================

# --------------------------------
#     FEMALE
# --------------------------------
# 
# ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NSFG/sas/2002FemRespInput.sas
# ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NSFG/sas/2002FemRespValueLabel.sas
# ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NSFG/sas/2002FemRespVarLabel.sas
# --------------------------------

# MARSTAT  - 28
# AB-1  R S MARITAL STATUS"
  # 1 = "MARRIED"
  # 2 = "NOT MARRIED BUT LIVING TOGETHER WITH A PARTNER OF THE OPPOSITE SEX"
  # 3 = "WIDOWED"
  # 4 = "DIVORCED"
  # 5 = "SEPARATED, BECAUSE YOU AND YOUR SPOUSE ARE NOT GETTING ALONG"
  # 6 = "NEVER BEEN MARRIED"
# RELCURR  - 3653-3654
# "IC-4 R'S CURRENT RELIGION"
  # 1 = "NO RELIGION"
  # 2 = "CATHOLIC"
  # 3 = "BAPTIST/SOUTHERN BAPTIST"
  # 4 = "METHODIST, LUTHERAN, PRESBYTERIAN, EPISCOPAL, CHURCH OF CHRIST"
  # 5 = "FUNDAMENTALIST PROTESTANT"
  # 6 = "OTHER PROTESTANT DENOMINATION"
  # 7 = "PROTESTANT-NO SPECIFIC DENOMINATION"
  # 8 = "OTHER NON-CHRISTIAN RELIGION"
# RELDLIFE - 3656
# "IC-7 HOW IMPORTANT RELIGION IS IN R'S DAILY LIFE"
  # 1 = "VERY IMPORTANT"
  # 2 = "SOMEWHAT IMPORTANT"
  # 3 = "NOT IMPORTANT"
# STAYTOG  - 3710
# "IH-2 DIVORCE BEST SOLUTION WHEN CAN T WORK OUT MARRIAGE PROBLEMS"
  # 1 = "STRONGLY AGREE"
  # 2 = "AGREE"
  # 3 = "DISAGREE"
  # 4 = "STRONGLY DISAGREE"
  # 5 = "IF R INSISTS: NEITHER AGREE NOR DISAGREE"
# AGER  3749-3750
# HIEDUC   - 3754-3755
# "HIGHEST COMPLETED YEAR OF SCHOOL OR HIGHEST DEGREE RECEIVED"
  # 5 = "9TH GRADE OR LESS"
  # 6 = "10TH GRADE"
  # 7 = "11TH GRADE"
  # 8 = "12TH GRADE, NO DIPLOMA (NOR GED)"
  # 9 = "HIGH SCHOOL GRADUATE (DIPLOMA OR GED)"
  # 10 = "SOME COLLEGE BUT NO DEGREE"
  # 11 = "ASSOCIATE DEGREE IN COLLEGE/UNIVERSITY"
  # 12 = "BACHELOR'S DEGREE"
  # 13 = "MASTER'S DEGREE"
  # 14 = "DOCTORATE DEGREE"
  # 15 = "PROFESSIONAL DEGREE"
  
cut -c28,3653,3654,3656,3710,3749,3750,3754,3755 data/2002_female.dat > extract/2002_female_raw.txt

# --------------------------------
#      MALE
# --------------------------------
# data/2002_male.dat
# ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NSFG/sas/2002MaleInput.sas
# ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NSFG/sas/2002MaleValueLabel.sas
# ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NSFG/sas/2002MaleVarLabel.sas
# --------------------------------

# MARSTAT  - 26
# "AB-1 R S MARITAL STATUS"
  # 1 = "MARRIED"
  # 2 = "NOT MARRIED BUT LIVING TOGETHER WITH A PARTNER OF THE OPPOSITE SEX"
  # 3 = "WIDOWED"
  # 4 = "DIVORCED"
  # 5 = "SEPARATED, BECAUSE YOU AND YOUR SPOUSE ARE NOT GETTING ALONG"
  # 6 = "NEVER BEEN MARRIED"
# RELCURR  - 2541-2542
# "JB-4 R'S CURRENT RELIGION"
  # 1 = "NO RELIGION"
  # 2 = "CATHOLIC"
  # 3 = "BAPTIST/SOUTHERN BAPTIST"
  # 4 = "METHODIST, LUTHERAN, PRESBYTERIAN, EPISCOPAL, CHURCH OF CHRIST"
  # 5 = "FUNDAMENTALIST PROTESTANT"
  # 6 = "OTHER PROTESTANT DENOMINATION"
  # 7 = "PROTESTANT-NO SPECIFIC DENOMINATION"
  # 8 = "OTHER NON-CHRISTIAN RELIGION"
# RELDLIFE - 2544
# "JB-7 HOW IMPORTANT IS RELIGION IN R'S DAILY LIFE"
  # 1 = "VERY IMPORTANT"
  # 2 = "SOMEWHAT IMPORTANT"
  # 3 = "NOT IMPORTANT"
# STAYTOG  - 2583
# "JG-2 DIVORCE BEST SOLUTION WHEN CAN T WORK OUT MARRIAGE PROBLEMS"
  # 1 = "STRONGLY AGREE"
  # 2 = "AGREE"
  # 3 = "DISAGREE"
  # 4 = "STRONGLY DISAGREE"
  # 5 = "IF R INSISTS: NEITHER AGREE NOR DISAGREE"
# AGER - 2622-2623
# HIEDUC - 2627-2628
# "HIGHEST COMPLETED YEAR OF SCHOOL OR HIGHEST DEGREE RECEIVED"
 # 5 = "9TH GRADE OR LESS"
 # 6 = "10TH GRADE"
 # 7 = "11TH GRADE"
 # 8 = "12TH GRADE, NO DIPLOMA (NOR GED)"
 # 9 = "HIGH SCHOOL GRADUATE (DIPLOMA OR GED)"
 # 10 = "SOME COLLEGE BUT NO DEGREE"
 # 11 = "ASSOCIATE DEGREE IN COLLEGE/UNIVERSITY"
 # 12 = "BACHELOR'S DEGREE"
 # 13 = "MASTER'S DEGREE"
 # 14 = "DOCTORATE DEGREE"
 # 15 = "PROFESSIONAL DEGREE"

cut -c26,2541,2542,2544,2583,2622,2623,2627,2628 data/2002_male.dat > extract/2002_male_raw.txt

