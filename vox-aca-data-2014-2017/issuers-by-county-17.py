from python_lib_util import csvtools as c
from operator import itemgetter
import collections

# STEP ONE: Read in needed data as a list of dicts
data = c.read_as_dict('filtered-csvs/2016-issuers-filtered.csv')

issuers_2017 = list()

# STEP TWO: Remove issuers reported as leaving in 2017
for row in data:
    # AL changes
    if row['s'] == 'AL' and row['i'] == 'Humana Insurance Company':
        continue
    if row['s'] == 'AL' and row['i'] == 'UnitedHealthcare of Alabama, Inc.':
        continue
    # AK changes
    if row['s'] == 'AK' and row['i'] == 'Moda Health Plan, Inc.':
        continue
    # AZ changes
    if row['s'] == 'AZ' and row['i'] == 'All Savers Insurance Company':
        continue
    if row['s'] == 'AZ' and row['i'] == 'Health Net of Arizona, Inc.':
        continue
    if row['s'] == 'AZ' and row['c'] == 'Maricopa' and row['i'] == 'Blue Cross and Blue Shield of Arizona, Inc.':
        continue
    if row['s'] == 'AZ' and row['c'] == 'Pinal' and row['i'] == 'Blue Cross and Blue Shield of Arizona, Inc.':
        continue
    # AR changes
    if row['s'] == 'AR' and row['i'] == 'UnitedHealthcare of Arkansas, Inc.':
        continue
    # FL changes
    if row['s'] == 'FL' and row['i'] == 'UnitedHealthcare of Florida, Inc.':
        continue
    # GA changes
    if row['s'] == 'GA' and row['i'] == 'UnitedHealthcare of Georgia, Inc.':
        continue
    # IL changes
    if row['s'] == 'IL' and row['i'] == 'UnitedHealthcare of the Midwest, Inc.':
        continue
    # IN changes
    if row['s'] == 'IN' and row['i'] == 'All Savers Insurance Company':
        continue
    # IA changes
    if row['s'] == 'IA' and row['i'] == 'UnitedHealthcare of the Midlands, Inc.':
        continue
    # KS changes
    if row['s'] == 'KS' and row['i'] == 'UnitedHealthcare of the Midwest, Inc.':
        continue
    # LA changes
    if row['s'] == 'LA' and row['i'] == 'UnitedHealthcare of Louisiana, Inc.':
        continue
    # MI changes
    if row['s'] == 'MI' and row['i'] == 'UnitedHealthcare Community Plan, Inc.':
        continue
    if row['s'] == 'MI' and row['i'] == 'Humana Medical Plan of Michigan, Inc.':
        continue
    # MO changes
    if row['s'] == 'MO' and row['i'] == 'All Savers Insurance Company':
        continue
    # MS changes
    if row['s'] == 'MS' and row['i'] == 'UnitedHealthcare of Mississippi, Inc.':
        continue
    # NE changes
    if row['s'] == 'NE' and row['i'] == 'UnitedHealthcare of the Midlands, Inc.':
        continue
    # NJ changes
    if row['s'] == 'NJ' and row['i'] == 'Oxford Health Plans (NJ), Inc.':
        continue
    if row['s'] == 'NJ' and row['i'] == 'Oscar Insurance Corporation of New Jersey':
        continue
    # NM changes
    if row['s'] == 'NM' and row['i'] == 'Presbyterian Health Plan, Inc.':
        continue
    # NC changes
    if row['s'] == 'NC' and row['i'] == 'UnitedHealthcare of North Carolina, Inc':
        continue
    # OH changes
    if row['s'] == 'OH' and row['i'] == 'UnitedHealthcare of Ohio, Inc.':
        continue
    if row['s'] == 'OH' and row['i'] == 'All Savers Insurance Company':
        continue
    # OK changes
    if row['s'] == 'OK' and row['i'] == 'UnitedHealthcare of Oklahoma, Inc.':
        continue
    # OR changes
    if row['s'] == 'OR' and row['i'] == 'LifeWise Health Plan of Oregon':
        continue
    # PA changes
    if row['s'] == 'PA' and row['i'] == 'UnitedHealthcare of Pennsylvania, Inc.':
        continue
    # SC changes
    if row['s'] == 'SC' and row['i'] == 'UnitedHealthcare Insurance Company':
        continue
    # TN changes
    if row['s'] == 'TN' and row['i'] == 'UnitedHealthcare Insurance Company':
        continue
    # TX changes
    if row['s'] == 'TX' and row['i'] == 'All Savers Insurance Company':
        continue
    if row['s'] == 'TX' and  row ['c'] != 'Bexar' and row['i'] == 'Oscar Insurance Company of Texas':
        continue
    # WI changes
    if row['s'] == 'WI' and row['i'] == 'All Savers Insurance Company':
        continue

    # Aetna changes: 11 of 15 states exiting
    if row['s'] == 'AZ' and row['i'] == 'Aetna Health Inc. (a PA corp.)':
        continue
    if row['s'] == 'FL' and row['i'] == 'Aetna Health Inc. (a FL corp.)':
        continue
    if row['s'] == 'GA' and row['i'] == 'Aetna Health Inc. (a GA corp.)':
        continue
    if row['s'] == 'IL' and row['i'] == 'Aetna Health Inc. (a PA corp.)':
        continue
    if row['s'] == 'NC' and row['i'] == 'Aetna Health Inc. (a PA corp.)':
        continue
    if row['s'] == 'OH' and row['i'] == 'Aetna Life Insurance Company':
        continue
    if row['s'] == 'PA' and row['i'] == 'Aetna Health Inc. (a PA corp.)':
        continue
    if row['s'] == 'SC' and row['i'] == 'Aetna Health Inc. (a PA corp.)':
        continue
    if row['s'] == 'TX' and row['i'] == 'Aetna Life Insurance Company':
        continue
    # Aetna operates as Coventry in NE and MO
    if row['s'] == 'NE' and row['i'] == 'Coventry Health Care of Nebraska Inc.':
        continue
    if row['s'] == 'MO' and row['i'] == 'Coventry Health & Life Insurance Co.':
        continue
    if row['s'] == 'MO' and row['i'] == 'Coventry Health & Life':
        continue
    # if Aetna pulling out and Coventry also operates in state, Coventry is pulling out
    if row['s'] == 'FL' and row['i'] == 'Coventry Health Care of Florida, Inc.':
        continue
    if row['s'] == 'IL' and row['i'] == 'Coventry Health Care of Illinois, Inc.':
        continue
    if row['s'] == 'IL' and row['i'] == 'Coventry Health & Life Co.':
        continue
    else:
        issuers_2017.append(row)

# STEP THREE: Add issuers reported as entering 2017
new_issuers = list()
IA_cross = ["Sioux", "O'Brien", "Plymouth", "Woodbury", "Monona",  "Floyd", "Chickasaw", "Mitchell", "Howard", "Franklin", "Butler", "Bremer", "Fayette", "Hamilton", "Hardin", "Grundy", "Black Hawk", "Buchanan", "Jackson", "Clinton", "Boone", "Audubon", "Dallas", "Polk", "Jasper", "Poweshiek", "Adair", "Madison", "Warren", "Marion", "Monroe", "Ringgold", "Decatur", "Wayne", "Appanoose", "Davis"]
IA = ["Linn", 'Des Moines', "Scott", "Johnson"]
for row in issuers_2017:
    # this does not account for duplicates
    if row['s'] == 'KS':
        entry = {'i': 'Medica', 'c': row['c'], 's': row['s'], 'id': row['id']}
        new_issuers.append(entry)
    if row['c'] == 'Richmond city':
        entry = {'i': 'Cigna', 'c': row['c'], 's': row['s'], 'id': row['id']}
        new_issuers.append(entry)
    if row['c'] == 'Wake':
        entry = {'i': 'Cigna', 'c': row['c'], 's': row['s'], 'id': row['id']}
        new_issuers.append(entry)
    else:
        for row in IA_cross:
            entry = {'i': 'Wellmark Value Health Plan', 'c': row, 's': 'IA', 'id': row + ', IA'}
            new_issuers.append(entry)
        for row in IA:
            entry = {'i': 'Wellmark Synergy Health, Inc.', 'c': row, 's': 'IA', 'id': row + ', IA'}
            new_issuers.append(entry)

# remove duplicates
unique_new_issuers = [dict(t) for t in set([tuple(d.items()) for d in new_issuers])]

# STEP FOUR: Add new issuers list to trimmed issuers_2017 list and sort by state and county
issuers_2017.extend(unique_new_issuers)

state = collections.defaultdict(list)

for d in issuers_2017:
    state[d['s']].append(d)

state_list = state.values()

sorted_issuers_2017 = list()
# a list of list of dicts
for row in state_list:
    # a list of dicts
    sorted_issuers = sorted(row, key=itemgetter('c'))
    sorted_issuers_2017.append(sorted_issuers)

# list of list of dicts
flattened = [val for sublist in sorted_issuers_2017 for val in sublist]
sorted_issuers_2017_list = sorted(flattened, key=itemgetter('s'))

# find the number of counties w/ only one insurance provider
# first group by county and tally count of insurers
data_grp = collections.defaultdict(list)

for row in sorted_issuers_2017_list:
    data_grp[row['id']].append(row['i'])

issuers_count = list()
for k,v in data_grp.items():
    att = dict()
    att['Number of Issuers'] = len(v)
    att['Issuers'] = v
    att['County'] = k
    issuers_count.append(att)

# print issuers_count

# STEP FIVE: Write to file
c.write_dict(sorted_issuers_2017_list, 'filtered-csvs/2017-issuers-filtered.csv')
c.write_dict(issuers_count, 'filtered-csvs/2017-count.csv')
