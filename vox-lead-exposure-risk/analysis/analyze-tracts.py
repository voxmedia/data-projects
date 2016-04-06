import csv
import collections
import re


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


# this tries to convert a str into a float and throws an error if not possible.
def safe_float(s):
    n = 0
    try:
        n = float(s)
    except:
        if s != '':
            print "Cannot turn %s into float" % s
    return n


# this writes output as a csv
def write(data, filename):
    with open(filename, 'wb') as f:
        writer = csv.writer(f)
        writer.writerows(data)


# this flattens our data from a list of dicts and writes output as csv
def flatten_dict(data, headers, filename):
    result = list()
    for row in data:
        result_row = list ()
        for key in headers:
            try:
                result_row.append(row[key])
            except KeyError:
                continue
        result.append(result_row)

    headers = [headers]
    result = headers + result
    write(result, filename)


# join lead exposure data to classified tracts
lead_data = read_as_dict('../exports/lead-risk-score.csv')
tracts_data = read_as_dict ('exports/tracts-classification.csv')

d = collections.defaultdict(dict)
for l in (lead_data, tracts_data):
    for elem in l:
        d[elem['id']].update(elem)
joined_data = d.values()


# Analysis Qs
# 1
all_tracts = list()
for row in joined_data:
    try:
        if row['decile']:
            all_tracts.append(row)
    except KeyError:
        continue

all_tracts_len = len(all_tracts)
print '1. We have data for {} tracts.'.format(all_tracts_len)

# 2
print '2. How many tracts have a decile of 10? And of those, how many are urban? How many are rural?'
counter_tracts = list()
counter_urban_tracts = list()
counter_rural_tracts = list()

for row in joined_data:
    try:
        if safe_float(row['decile']) == 10.0:
            counter_tracts.append(row)
        if safe_float(row['decile']) == 10.0 and row['c'] == 'u':
            counter_urban_tracts.append(row)
        if safe_float(row['decile']) == 10.0 and row['c'] == 'r':
            counter_rural_tracts.append(row)
    except KeyError:
        continue

tracts_10 = len(counter_tracts)
tracts_10_urban = len(counter_urban_tracts)
tracts_10_rural = len(counter_rural_tracts)
pct_urban = round(float(tracts_10_urban) / float(tracts_10) * 100, 0)
pct_rural = round(float(tracts_10_rural) / float(tracts_10) * 100, 0)

print '2A: {} have a decile of 10. {} pct or {} are urban tracts. Only {} are rural tracts, or {} pct.'.format(tracts_10, pct_urban, tracts_10_urban, tracts_10_rural, pct_rural)

# 3
print '''3: Write to exports "tracts-high-risk-metro.csv", which contains the percentage
of census tracts in a metro area with a respective decile score of 10 or 1.'''

ua_list = read_as_dict('ua.csv')

# slim down atts from joined data
slimmed_joined = list()
for row in joined_data:
    att = dict()
    try:
        att['id'] = row['id']
        att['n'] = row['name']
        att['d'] = row['decile']
        att['c'] = row['c']
        number = re.compile('\d+(?:\.\d+)?')
        uace = number.findall(row['l'])
        if len(uace) == 0:
            att['uace'] = 'r'
        elif len(uace) == 1:
            att['uace'] = uace[0]
        elif len(uace) == 2:
            att['uace'] = uace[0]
            att['u2'] = uace[1]
        else:
            att['uace'] = uace[0]
            att['u2'] = uace[1]
            att['u3'] = uace[2]
        slimmed_joined.append(att)
    except KeyError:
        continue

# append metro name to tracts
metro_names = list()
for row in slimmed_joined:
    att = dict()
    for metro in ua_list:
        try:
            if row['uace'] == metro['UACE'] or row['u2'] == metro['UACE'] or row['u3'] == metro['UACE']:
                att['metro'] = metro['NAME']
                att['d'] = row['d']
                att['n'] = row['n']
                att['p'] = metro['POP']
                metro_names.append(att)
        except KeyError:
            continue

# group data by metro
metro_grp = collections.defaultdict(list)
for metro in metro_names:
    metro_grp[metro['metro']].append(metro)

# calculate percentage of tracts for an urban area with a decile score of 10
metro_deciles = list()
for k,v in metro_grp.items():
    att = dict()
    deciles = list()
    for item in v:
        att['p'] = item['p']
        deciles.append(safe_float(item['d']))
    att['k'] = k
    att['d'] = deciles
    metro_deciles.append(att)

high_risk_tracts_metro = list()
for row in metro_deciles:
    att = dict()
    list_length = len(row['d'])
    # count frequency of deciles in list
    counter = collections.Counter(row['d'])
    counter_dict = dict(counter.items())
    try:
        # don't include metro areas w/ less than 10 tracts and populations > 100,000
        if list_length >= 10 and int(row['p']) >= 100000:
            att['d10'] = counter_dict[10.0]
            att['dnum'] = list_length
            att['pct'] = float(att['d10']) / float(list_length) * 100
            att['k'] = row['k']
            att['p'] = row['p']
            high_risk_tracts_metro.append(att)
    except KeyError:
        continue

# 4
all_tracts_st = list()
for row in slimmed_joined:
    att = dict()
    name = row['n']
    split = name.split(',')
    if len(split) == 3:
        att['n'] = name
        att['st'] = split[2]
        att['d'] = row['d']
        att['c'] = row['c']
        all_tracts_st.append(att)
    else:
        continue

# determine number of rural tracts with a risk of 6 or more
rural_tracts = list()
rural_tracts_risk = list()

for row in all_tracts_st:
    if row['c'] == 'r':
        rural_tracts.append(row)
    if row['c'] == 'r' and safe_float(row['d']) >= 6.0:
        rural_tracts_risk.append(row)

all_rural_tracts = len(rural_tracts)
rural_high_risk = len(rural_tracts_risk)
pct_rural_tracts = round(float(rural_high_risk) / float(all_rural_tracts) * 100, 0)
print '4. There are {} rural tracts. {} have a risk score of 6 or greater, or {} pct.'.format(all_rural_tracts, rural_high_risk, pct_rural_tracts)

# 4.5 group rural by state and determine percentage of tracts that are rural
print '''4.5 Write to exports "state-rural-pct.csv" and group rural census tracts by state and determine percentage of tracts that are rural
and percentage of rural tracts that have a lead exposure risk of 6 or greater.'''

# group all_tracts_st by state
st_grp = collections.defaultdict(list)
for st in all_tracts_st:
    st_grp[st['st']].append(st)

state_rural_pct = list()
for k,v in st_grp.items():
    att = dict()
    tracts = len(v)
    rural_count = list()
    rural_risk = list()
    for item in v:
        if item['c'] == 'r':
            rural_count.append('r')
        if item['c'] == 'r' and safe_float(item['d']) >= 6.0:
            rural_risk.append(item['d'])
        rural = len(rural_count)
        rural_risk_count = len(rural_risk)
        att['pct_rural'] = float(rural) / float(tracts) * 100
        try:
            att['pct_rural_risk'] = float(rural_risk_count)/ float(rural) * 100
        except ZeroDivisionError:
            continue
        att['st'] = item['st']
        att['r'] = rural
        att['t'] = tracts
    state_rural_pct.append(att)

# write to csv
headers = ['k', 'd10', 'dnum', 'pct', 'p']
flatten_dict(high_risk_tracts_metro, headers, 'exports/tracts-high-risk-metro.csv')

headers = ['st', 'pct_rural', 'r', 't', 'pct_rural_risk']
flatten_dict(state_rural_pct, headers, 'exports/state-rural-pct.csv')
