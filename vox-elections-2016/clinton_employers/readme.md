# Hillary Clinton's donors by employer

FEC filing date: July 15, 2015

How to (sort of) reproduce the data for [story headline TK](//vox.com)

### Requirements

MySQL, command line skills, and strength for manual data cleaning.


### Instructions

#### Preface

I've included a very minimally cleaned up version of the FEC data called [`itcont_cleaned.txt`](itcont_cleaned.txt)in this project folder. (I removed some annoying characters that prevented importing the file into a MySQL table). The original data is available [at the FEC](//www.fec.gov/finance/disclosure/ftpdet.shtml#a2015_2016). Specifically, you'll want to download ([`indiv16.zip`](ftp://ftp.fec.gov/FEC/2016/indiv16.zip)), which contains itemized contributions by individuals for donations of $200 or more. It's a large file. The zip file contains a file called `itcont.txt`, which is a pipe-separated file that doesn't have a header row. You can grab the [header row](//www.fec.gov/finance/disclosure/metadata/indiv_header_file.csv), but it's comma-separated (-_-), so I've reproduced it below:

```
CMTE_ID|AMNDT_IND|RPT_TP|TRANSACTION_PGI|IMAGE_NUM|TRANSACTION_TP|ENTITY_TP|NAME|CITY|STATE|ZIP_CODE|EMPLOYER|OCCUPATION|TRANSACTION_DT|TRANSACTION_AMT|OTHER_ID|TRAN_ID|FILE_NUM|MEMO_CD|MEMO_TEXT|SUB_ID
```

This zip file contains contributions for all candidates, and wasn't available until four days after the filing deadline. Here's the [data dictionary](http://www.fec.gov/finance/disclosure/metadata/DataDictionaryContributionsbyIndividuals.shtml) on Individual Contributions.

You could download the bulk file of each candidate's FEC report on filing day ([here's Clinton's](//www.fec.gov/fecviewer/downloadNICFile.jsp?filingType=electronic&candidateCommitteeId=C00575795&imageNum=201507159000204718&candidateCommitteeName=&reportYear=2015&documentFiled=July%20Quarterly&amended=New&filedOn=07/15/2015&url=docquery.fec.gov/cgi-bin/dcdev/forms/DL/1015585/&imageNumber=201507159000204718)) and sort that out yourself if you like (I hear good things about [Fech](//github.com/NYTimes/Fech)). You could also grab Individual Contributions for a single candidate, but there's no permalink for that; you'll have to navigate around committee pages.


#### Run the script

Pull this repo, and run [`clinton_employers.sh`](clinton_employers.sh) from the command line:

```bash
$ ./clinton_employers.sh
```

There are comments in [`clinton_employers.sh`](clinton_employers.sh) if you want to know what happens here.


#### Manual data cleanup

Now you're ready for the manual cleaning. If you're comfortable with MySQL, you can dispose of the csv that was exported (`clinton_employers_ready_to_clean.csv`), and update the table with something like this:

```mysql
ALTER TABLE clinton_employers_grouped
ADD employer_cleaning VARCHAR(255);

UPDATE clinton_employers_grouped 
SET employer_cleaning = employer;

UPDATE clinton_employers_grouped 
SET employer_cleaning = REPLACE(employer_cleaning, 'LLP', ' ');
```

Other keywords you may want to replace: `PLLC`, `INC`, `LLC`, `THE`, `AND COMPANY`, `CO`, `GROUP`, `AND`, `ET AL`, `CO`, `CORPORATE`, `CORPORATION`, `CORP.` and any punctuation (`'`, `,`, `&`, `.`). Be careful of leading and trailing spaces, so `COCA COLA` doesn't get sliced to `CA LA`. [Here are some more suggestions for company name cleanup.](//www.quora.com/What-are-good-ways-to-clean-up-a-large-collection-of-user-entered-company-names) 

I ended up doing what I could in MySQL, then exporting a file to upload to Google Drive so I could share my findings with reporter Jon Allen. We grouped federal departments and agencies as `State Department` or `Federal Government (not State)`. We also did some legwork on identifying donors who listed `Federal government` (or a variant), separating those who worked in the State Department.

Then we ran a pivot table with the information. It's not pretty, but we are confident that the donations over $50,000 are accurate. You can see [our work here](//docs.google.com/spreadsheets/d/167IDgrm5pJR80cKMGygrLMTsdPKwH0VUf36yUMQL6Sk/edit#gid=0).

