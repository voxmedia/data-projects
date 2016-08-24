# Healthcare.gov Affordable Care Act data

## About the project
This project uses ACA data from Healthcare.gov to count the number of plans available in a given county. To generate 2017 plan information, we rely on news reports and interviews with health insurance plans to show where companies plan to sell coverage in 2017 (all of this is outlined in `issuers-by-county-17.py`).

All of the data is `ObamacareParticipationByYear` folder.

What's included in each file:
<ol>
  <li>agg-county-state-plan-count: Pivot table with state and county counts of the number of insurers present for each year</li>
  <li>issuers: list of all issuers in a given county</li>
  <li>detailed-county-state-plan-coun: a more detailed version of the pivot table, showing you which insurers are present in each county</li>
</ol>

This is our [story](http://www.vox.com/a/obamacare-competition-2017). We hope you use this data to tell your own.

# Data Sources
- (2014): https://www.healthcare.gov/health-plan-information/
- (2015): https://www.healthcare.gov/health-plan-information-2015/
- (2016): https://www.healthcare.gov/health-plan-information-2016/

# Data Notes for generating 2017 data
AETNA
- Aetna is reported to operate in 15 states, but 2016 Healthcare.gov data only lists 12 states because KY has its own state-based exchange and because Aetna operates as Coventry in MO and NE.
- There are 3 states where both Coventry and Aetna operate: FL, IL and VA. In both FL and IL as Aetna is exiting, Coventry is leaving as well.

UHC
- If UHC was reported as leaving a state and UHC is not listed as a current issuer, All Savers is typically the operating company, like in Arizona. These states include IN, MO, TX and WI.
- In the case of NJ, however neither UHC or All Savers is present. Instead, the issuer is Oxford Health Plans.
- And in a state like OH, both UHC and All Savers are leaving.

BCBS
- Article that states which two counties BCBS is leaving in AZ:
http://www.azcentral.com/story/news/local/arizona/2016/08/16/aetna-drops-obamacare-health-insurance-coverage-pinal-county-arizona/88834618/

OSCAR
- Withdrawing from the Dallas-Fort Worth, TX market and all of NJ.
- http://blog.hioscar.com/post/149370349611/changes-to-our-2017-map

OFF EXCHANGE
States where Humana is said to be leaving a state, but Humana is not listed in 2016 Healthcare.gov data as a current provider (determined as off-exchange):
- KS
- NV
- VA
- NC
- WI
- NC: Celtic Insurance Company leaving (off exchange)

States for which new insurance companies are entering the exchange:
- IA: Wellmark BCBS is entering in specific counties
- KS: Entering Medica statewide
- NC: Cigna expanding into Raleigh, but won’t specify counties (we just show Wake County)
- VA: Cigna is expanding into "NOVA and Richmond" but won’t specify counties (we just show Richmond)
- TN: Cigna may expand but won't specify where and Humana won't comment on expansion in TN
- WY: Canopy is not entering
- NV: Canopy is not entering
- NM: BCBS no final decision made

## Tech specs
The original ACA files exceed Github's 100MB upload limit, but I've included the scripts I used to generate the data so if you download the data from ACA you should be able to replicate my work. I did not automate the `fips-join.py` or `tally-issuers.py` by year, but the rest of the scripts can be executed running, `process.sh`, which will join ACA excel files when necessary (i.e. in 2014 there are multiple files), convert to csv and then group insurers by county.

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

If you do use this dataset, we'd appreciate [an email](mailto:sarah.frostenson@vox.com) or a link back, but it's not required.

Email [sarah.frostenson@vox.com](mailto:sarah.frostenson@vox.com) if you have questions about the dataset.
