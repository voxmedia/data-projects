# Lead Exposure Risk data

## About the project
This project does two things. It generates a vector national census tract tile set joined to lead exposure risk data. It can also run a series of scripts in the `analysis` directory to classify census tracts as urban or rural and what its corresponding lead exposure risk is.

The [methodology](https://assets.documentcloud.org/documents/2644455/Expert-Panel-Childhood-Lead-Screening-Guidelines.pdf) for calculating census tract level lead risk scores was developed by the [Washington State Department of Health](https://fortress.wa.gov/doh/wtn/WTNIBL/) in order to identify which geographic populations have a greater risk of lead poisoning. The model combines Census housing and poverty data to calculate a lead risk score for each census tract and then maps the scores as deciles from 1 to 10, where 1 is the lowest risk and 10 is the highest risk.

Vox.com worked with one of the chief epidemiologists responsible for developing the Washington State Department of Health's methodology, Rad Cunningham, to replicate the methodology nationally. This is our [story](http://www.vox.com/a/lead-exposure-risk-map). We hope you tell your own.

## Technical requirements
You must have the following dependencies installed in order to run this project in its entirety.

* Python 2.7
* virtualenv
* virtualenvwrapper
* Homebrew and `brew install tippecanoe`(https://github.com/mapbox/tippecanoe)
* PostgreSQL/PostGIS

## Generate the national census tract vector tiles with lead exposure risk data
**NB**: The only step of this process that is not automated is the download of the two 2014 5 YR ACS files needed in order to calculate the lead exposure risk scores. Both of the original files as downloaded from American FactFinder are included in this repo, but should you want to download your own copy, visit [American FactFinder](http://factfinder.census.gov/faces/nav/jsf/pages/index.xhtml) and query for the following two tables:
  - Age of housing: B25034
  - Poverty: S1701​

To run all of the bash scripts and generate a national census tract vector tile set of lead exposure risk data, run:

    ./process.sh

Or if you prefer, each step can be run individually. For this particular project, one might prefer to run steps individually, as the script in its entirety takes a little over a hour to run.

To download the census tract shapefile data from the Census FTP:

    ./download.sh

To filter the shapefile data before importing to a PostgreSQL/PostGIS database:

    ./filter-shp.sh

To import the shapefile data into a PostgreSQL/PostGIS database:

    ./import.sh

To export geojson from a PostgreSQL/PostGIS database:

    ./export.sh

To generate the lead risk score csv data:

    ./generate-lead-data.sh

To join the geojson file and lead risk score csv data:

    ./join-lead-risk-geojson.sh

To convert the joined geojson file into vector tiles:

    ./vectorize.sh

## Determining whether a census tract is urban and other analysis
**NB**: The U.S. Census Bureau defines urban and rural at the [block level](https://ask.census.gov/faq.php?id=5000&faqId=6403). Therefore, geographic areas, including cities, towns and census tracts, may be urban, rural, or a mixture of urban and rural. The only step of this process that is not automated is the download of the state FIPS codes.

To run all of the bash scripts and generate the analysis files, cd into `analysis` and run:

    ./process.sh

Or if you prefer, each step can be run individually. For this particular project, one might prefer to run steps individually, as the script in its entirety takes several hours to run (significantly longer than the first series of scripts included in this repo).

To download the census tract shapefile data from the Census FTP:

    ./download.sh

To import the shapefile data into a PostgreSQL/PostGIS database:

    ./import.sh

To export a csv with UACE10 codes from a PostgreSQL/PostGIS database:

    ./export.sh

To group the census blocks by tracts and classify as urban, rural or mixed:

    python classify-tracts.py

To join the classified tracts data to the lead risk score data and run analysis at a tract level:

    python analyze-tracts.py

To group census tracts' lead risk scores by state and run analysis at the state level:

    python analyze-states.py

## License
```
Copyright (c) 2015, Vox Media, Inc. All rights reserved.

BSD license

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list
of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this
list of conditions and the following disclaimer in the documentation and/or other
materials provided with the distribution.

Neither the name of the copyright holder nor the names of its contributors may be
used to endorse or promote products derived from this software without specific
prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.SING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```

## Contact

If you do use the lead exposure risk dataset, we'd appreciate [an email](mailto:editorialapps@voxmedia.com) or a link back, but it's not required.

Email [sarah.frostenson@vox.com](mailto:sarah.frostenson@vox.com) if you have questions about the dataset.
