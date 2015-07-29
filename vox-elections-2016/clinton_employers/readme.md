# Hillary Clinton's donors by employer

How to reproduce the data for [Hillary Clinton gets less Wall Street money than you think](//www.vox.com/2015/7/29/9040091/hillary-clinton-wall-street) (for the FEC filing date of July 15, 2015).



### Requirements

MySQL, command line skills, and strength for manual data cleaning.



### Instructions

#### Preface

I've provided the relevant data in this repo folder, but if you want to grab the originals, read on. Otherwise, skip over to [running the script](#run-the-script).

I've provided a copy of __Clinton's itemized contribution list__ at [`itemized.csv`](itemized.csv). To download that directly from the FEC, you'll need to go to the [committee details on the FEC site](//www.fec.gov/fecviewer/CandidateCommitteeDetail.do?candidateCommitteeId=P00003392&tabIndex=1), click on `Itemized Individual Contributions`, then click on `CSV` under `Export Options`. Here's the [data dictionary](//www.fec.gov/finance/disclosure/metadata/metadata_individual_contributions.shtml).

I've also included a very minimally cleaned up version of __FEC master individual contribution data__ called [`itcont_cleaned.txt`](itcont_cleaned.txt) in this project folder. (I removed some annoying characters that prevented importing the file into a MySQL table). The original data is available [at the FEC](//www.fec.gov/finance/disclosure/ftpdet.shtml#a2015_2016). Specifically, you'll want to download ([`indiv16.zip`](ftp://ftp.fec.gov/FEC/2016/indiv16.zip)), which contains itemized contributions by individuals for donations of $200 or more. It's a large file. The zip file contains a file called `itcont.txt`, which is a pipe-separated file that doesn't have a header row. You can grab the [header row](//www.fec.gov/finance/disclosure/metadata/indiv_header_file.csv), but it's comma-separated (-_-), so I've reproduced it below:

```
CMTE_ID|AMNDT_IND|RPT_TP|TRANSACTION_PGI|IMAGE_NUM|TRANSACTION_TP|ENTITY_TP|NAME|CITY|STATE|ZIP_CODE|EMPLOYER|OCCUPATION|TRANSACTION_DT|TRANSACTION_AMT|OTHER_ID|TRAN_ID|FILE_NUM|MEMO_CD|MEMO_TEXT|SUB_ID
```
This zip file contains contributions for all candidates, and wasn't available until four days after the filing deadline. Here's the [data dictionary](//www.fec.gov/finance/disclosure/metadata/DataDictionaryContributionsbyIndividuals.shtml) on Individual Contributions.

##### Why do I need both the master data and the itemized data?

Some of the refunds and contributions don't really match up without looking at both sets together.


#### Run the script

Pull this repo, and run [`run.sh`](run.sh) from the command line:

```bash
$ ./run.sh
```
There are comments in the scripts if you want to know what happens here. More comments TK.

The end result is a SQL table that groups up employers in descending order of the amount donated. 


#### Manual data cleanup

We (Jon Allen and Soo Oh) provided a list of manually cleaned employers in [`employer_clean.csv`](employer_clean.csv) — it's automatically merged into the data tables within [`clean.sh`](clean.sh). So [I kind of lied](#requirements) when I said you were going to do some manual cleanup work. But if you want to check our work, then yes, you will need the strength and fortitude to go through the employer names manually.

[Here's some great reading on cleaning up employer names.](//www.quora.com/What-are-good-ways-to-clean-up-a-large-collection-of-user-entered-company-names)


## Contribute

This project is shared as-is. Bugs, issues, and pull requests may not be readily addressed.



## License

FEC data is in the public domain. Otherwise, the data workflow scripts in this folder to clean up and merge the data are licensed as follows:

Copyright (c) 2015, Vox Media, Inc. All rights reserved.

BSD license

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



## Contact

If you do use any of the materials here, we'd appreciate [an email](mailto:editorialapps@voxmedia.com) or a link back, but it's not required.

Contact [soo@vox.com](mailto:soo@vox.com) if you have questions about how to use this repo. 

Contact [jon.allen@vox.com](jon.allen@vox.com) or [soo@vox.com](mailto:soo@vox.com) for questions about the story.
