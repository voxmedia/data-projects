import csv
import collections
from itertools import izip_longest, ifilter


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
            result_row.append(row[key])
        result.append(result_row)

    headers = [headers]
    result = headers + result
    write(result, filename)


# create a state fips code from census tract code
data = read_as_dict('../exports/lead-risk-score.csv')

st_deciles = list()
for row in data:
    att = dict()
    att['stfips'] = row['id'][0:2]
    att['decile'] = row['decile']
    st_deciles.append(att)

# group decile scores by state fips code
st_deciles_grp = collections.defaultdict(list)

for st in st_deciles:
    st_deciles_grp[st['stfips']].append(st['decile'])

# get frequency for each decile score by state fips code
deciles_by_state = list()
for k, v in st_deciles_grp.items():
    att = dict()
    # all tracts in a state
    att['d_sum'] = len(v)
    counter = collections.Counter(v)
    # convert counter object to dict
    counter_dict = dict(counter.items())
    # split dict by key into a list of dicts
    chunks = [counter_dict.iteritems()]
    split = (dict(ifilter(None, v)) for v in izip_longest(*chunks))
    split_list = list(split)
    # sort our list of dicts
    sorted_split = sorted(split_list)
    # split up our dicts into one dict per state
    for row in sorted_split:
        key = ''.join(row.keys())
        value = ''.join(str(v) for v in row.values())
        # omit blank keys
        if key != '':
            att[key] = value
    att['fips'] = k
    deciles_by_state.append(att)

# print deciles_by_state

# get state name for corresponding st fips code by joining on fips code
fips = read_as_dict('fips.csv')

d = collections.defaultdict(dict)
for l in (deciles_by_state, fips):
    for elem in l:
        d[elem['fips']].update(elem)
deciles_by_state_joined = d.values()

# print deciles_by_state_joined

deciles_by_state_pct10 = list()
for row in deciles_by_state_joined:
    att = dict()
    att['fips'] = row['fips']
    att['state'] = row['state']
    try:
        att['1.0'] = row['1.0']
    except KeyError:
        att['1.0'] = ''
    att['2.0'] = row['2.0']
    att['3.0'] = row['3.0']
    att['4.0'] = row['4.0']
    att['5.0'] = row['5.0']
    att['6.0'] = row['6.0']
    att['7.0'] = row['7.0']
    att['8.0'] = row['8.0']
    try:
        att['9.0'] = row['9.0']
    except KeyError:
        att['9.0'] = ''
    try:
        att['10.0'] = row['10.0']
    except KeyError:
        att['10.0'] = ''
    att['d_sum'] = row['d_sum']
    try:
        att['pct10'] = float(row['10.0']) / float(row['d_sum']) * 100
    except KeyError:
        att['pct10'] = ''
    try:
        att['pct1'] = float(row['1.0']) / float(row['d_sum']) * 100
    except KeyError:
        att['pct1'] = ''
    deciles_by_state_pct10.append(att)

# write to csv
print '''1. Write to exports "state-lead-risk.csv" and group decile risks by state
and determine percentage of tracts with a risk of 10 and 1.'''
headers = ['fips', 'state', '1.0', '2.0', '3.0', '4.0', '5.0', '6.0', '7.0', '8.0', '9.0', '10.0', 'd_sum', 'pct10', 'pct1']
flatten_dict(deciles_by_state_pct10, headers, 'exports/state-lead-risk.csv')
