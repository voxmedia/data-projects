from python_lib_util import csvtools as c
import collections
from itertools import izip_longest, ifilter


# STEP ONE: Read in needed data as a list of dicts
data = c.read_as_dict('fips-join/2017-joined.csv')

# list of dicts, group by fips id
data_grp = collections.defaultdict(list)

for row in data:
    data_grp[row['f']].append(row['i'])

# get count of issuers by fips code
issuers_by_county = list()
for k, v in data_grp.items():
    att = dict()
    # all issuers in a county
    att['ict'] = len(v)
    counter = collections.Counter(v)
    # convert counter object to dict
    counter_dict = dict(counter.items())
    # split dict by key into a list of dicts
    chunks = [counter_dict.iteritems()]
    split = (dict(ifilter(None, v)) for v in izip_longest(*chunks))
    split_list = list(split)
    # sort our list of dicts
    sorted_split = sorted(split_list)
    # split up our dicts into one dict per county
    for row in sorted_split:
        key = ''.join(row.keys())
        value = ''.join(str(v) for v in row.values())
    att['f'] = k
    issuers_by_county.append(att)

# print issuers_by_county

# STEP TWO: Write to file
c.write_dict(issuers_by_county, '2017-issuers-grouped.csv')
