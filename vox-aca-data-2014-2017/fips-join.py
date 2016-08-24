from python_lib_util import csvtools as c

# STEP ONE: Generate a list of fips codes, by combining stfips and ctyfips.
# Also, include full county name + name w/o county + state in new lists
data = c.read_as_dict('fips-join/fips.csv')
aca_2014 = c.read_as_dict('filtered-csvs/2014-issuers-filtered.csv')
aca_2015 = c.read_as_dict('filtered-csvs/2015-issuers-filtered.csv')
aca_2016 = c.read_as_dict('filtered-csvs/2016-issuers-filtered.csv')
aca_2017 = c.read_as_dict('filtered-csvs/2017-issuers-filtered.csv')

fips_codes = list()
# what about OBrien
for row in data:
    att = dict()
    att['f'] = row['stfips'] + row['ctyfips']
    att['c'] = row['name']
    att['s'] = row['state']
    c0 = row['name'].split(' ')
    # range is from 2 - 5
    if 'city' == c0[1]:
        att['c0'] = " ".join(c0[:2])
    if 'city' != c0[1] and len(c0) == 2:
        att['c0'] = c0[0]
    if len(c0) == 3 and 'city' == c0[2]:
        att['c0'] = " ".join(c0)
    if len(c0) == 3 and 'city' != c0[2]:
        att['c0'] = " ".join(c0[:2])
    if len(c0) == 4:
        att['c0'] = " ".join(c0[:3])
        # print att['c0']
    if len(c0) == 5:
        att['c0'] = " ".join(c0[:4])
        # print att['c0']
    att['id'] = att['c0'] + ', ' + att['s']
    fips_codes.append(att)

# print fips_codes

# STEP TWO: Join fips data to ACA data on id field
# there are going to be more fips codes than ACA counties
joined_data = list()
for fips in fips_codes:
    for cty in aca_2017:
        if fips['id'] == cty['id']:
            entry = {'i': cty['i'], 'c': fips['c'], 's': fips['s'], 'f': fips['f'], 'id': fips['id']}
            joined_data.append(entry)

# print joined_data

# identify where the join was unsuccessful
joined = list()
for row in joined_data:
    joined.append(row['id'])

orig = list()
for row in aca_2017:
    orig.append(row['id'])

unmatched = list()
for row in orig:
    if row not in joined:
        unmatched.append(row)

unmatched_unique = list(set(unmatched))
for row in unmatched_unique:
    print row

print len(joined), len(orig)

# STEP THREE: Write to file
c.write_dict(joined_data, 'fips-join/2017-joined.csv')
