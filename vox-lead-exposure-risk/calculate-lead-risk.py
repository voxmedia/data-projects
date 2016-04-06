# Estimating Lead Risk by Census Track for the USA using methods developed by WA-DOH
# Data sources: ACS 5-year estimates from tables: B25034 & S1701
# Original calculations performed by Rad Cunningham in TODO (github hyperlink)
# Converted from a STATA script to a python script by Sarah Frostenson


import csv
import numpy as np
import pandas as pd


# this opens and reads a csv data as a list
def read(filename):
    data = []
    with open(filename, 'rU') as f:
        f = csv.reader(f)
        for row in f:
            data.append(row)

    return data


# this opens and reads csv data as a dict
def read_as_dict(filename):
    csv = read(filename)
    headers = csv.pop(0)
    data = list()
    for row in csv:
        d = dict()
        for index, header in enumerate(headers):
            d[header] = row[index]
        data.append(d)
    return data


# this function joins two lists of dicts on a key
# and creates a new list of dicts with values
# from both lists of dicts
def merge_lists_of_dicts(l1, l2, key):
    merged = {}
    for item in l1+l2:
        if item[key] in merged:
            merged[item[key]].update(item)
        else:
            merged[item[key]] = item
    return [val for (_, val) in merged.items()]


### STEP ONE ###
# first, calculate the % of houses at risk by age category in each census tract
housing = read_as_dict('b25034-age-of-housing/housing.csv')
housing_risk = list()

for row in housing:
    att = dict()
    # exclude census tracts with no data and Puerto Rico
    if int(row['HD01_VD01']) == 0 or "Puerto Rico" in row['GEO.display-label']:
        continue
    else:
        att['id'] = row['GEO.id2']
        name = row['GEO.display-label'].split(',')
        att['name'] = name[1].strip() + ',' + name[2]
        # create age of housing categories that correspond to lead risk by housing in Jacobs et al 2002
        att['age_39'] = int(row['HD01_VD10']) * 0.68
        att['age40_59'] = (int(row['HD01_VD09']) + int(row['HD01_VD08'])) * 0.43
        att['age60_79'] = (int(row['HD01_VD07']) + int(row['HD01_VD06'])) * 0.08
        att['age80_99'] = (int(row['HD01_VD05']) + int(row['HD01_VD04'])) * 0.03
        att['age00_10'] = (int(row['HD01_VD03']) + int(row['HD01_VD02'])) * 0
        att['total'] = int(row['HD01_VD01'])
        # add together the housing categories at risk for each tract
        att['sum_housing_risk'] = att['age_39'] + att['age40_59'] + att['age60_79'] + att['age80_99'] + att['age00_10']
        # divide the # of houses at risk for each tract by the total number of houses in a tract
        att['housing_risk'] = att['sum_housing_risk'] / att['total'] * 100

    housing_risk.append(att)
# print housing_risk


### STEP TWO ###
# next, calculate the % of houses living in poverty
poverty = read_as_dict('s1701-poverty-status/poverty.csv')
poverty_risk = list()

for row in poverty:
    att = dict()
    # exclude census tracts with no data and Puerto Rico
    if int(row['HC01_EST_VC01']) == 0 or "Puerto Rico" in row['GEO.display-label']:
        continue
    else:
        att['id'] = row['GEO.id2']
        att['name'] = row['GEO.display-label']
        att['poverty_risk'] = float(row['HC01_EST_VC49']) / float(row['HC01_EST_VC01']) * 100

    poverty_risk.append(att)
# print poverty_risk


### STEP THREE ###
# combine two lists of dicts into one list of dicts, joined on census tract id
combined_risk = merge_lists_of_dicts(housing_risk, poverty_risk, 'id')
# print combined_risk


### STEP FOUR ###
# calculate z-scores for lead risk variables in order to standardize them
# pandas: http://stackoverflow.com/questions/23451244/how-to-zscore-normalize-pandas-column-with-nans
# stata: http://www.ats.ucla.edu/stat/stata/faq/standardize.htm

# generate housing and poverty z-scores using pandas
df = pd.DataFrame(combined_risk, columns= ['id', 'name', 'poverty_risk', 'housing_risk', 'sum_housing_risk', 'total', 'age_39', 'age40_59', 'age60_79',  'age80_99', 'age00_10'])
df['poverty_z'] = (df['poverty_risk'] - df['poverty_risk'].mean())/df['poverty_risk'].std(ddof=0)
df['housing_z'] = (df['housing_risk'] - df['housing_risk'].mean())/df['housing_risk'].std(ddof=0)

# ## STEP FIVE ###
# calculate lead risk from housing and poverty using weights poverty 0.42, housing 0.58
df['weighted_housing'] = df['housing_z'] * 0.58
df['weighted_poverty'] = df['poverty_z'] * 0.42

# add together weighted_housing + weighted_poverty values
df['leadriskscore_raw'] = df['weighted_housing'] + df['weighted_poverty']

# using pandas, generate decile for each lead risk score
# http://stackoverflow.com/questions/26496356/how-to-create-a-decile-and-quintile-columns-to-rank-another-variable-based-on-si
# the labels argument generates deciles from 1-10, stepping by 1, as opposed to 0-9.
df['decile'] = pd.qcut(df['leadriskscore_raw'], 10, labels=np.arange(1, 11, 1))

# write to csv
df.to_csv('exports/lead-risk-score.csv')
