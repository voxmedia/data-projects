# National Survey of Family Growth

A hacky way to reproduce the data in various weird formats.

`source download.sh` - download the databases
`source cut.sh` - extract the relevant data
`ruby convert.rb` - recode raw values and convert into CSVs
`analysis/divorce_education.py` - [agate](https://github.com/wireservice/agate) analysis of CSVs


### Why did you mix Ruby and Python

Forgive me for my sins. I tend to write in Ruby first because Vox Media's interactives rig is more easily set up for it, in case I ever need to hook up the analysis with the rig (like live data that needs to be transformed on the spot). 


### Authors

I (Soo Oh) extracted the data out of the NSFG databases. Sarah Kliff analyzed the extracted data in Google Sheets, and I made the process reproducible.


## License

The [datasets](//github.com/voxmedia/data-projects/tree/master/vox-nsfg/data) are in the public domain. Otherwise, the workflow scripts that clean up and extract the datasets are licensed as follows:

Copyright (c) 2015, Vox Media, Inc. All rights reserved.

BSD license

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


## Contact

If this helped you at all, send us [an email](mailto:editorialapps@voxmedia.com) or link back to this page!

Email [soo@vox.com](mailto:soo@vox.com) and [sarah.kliff@vox.com](mailto:sarah.kliff@vox.com) if you have questions about the dataset.