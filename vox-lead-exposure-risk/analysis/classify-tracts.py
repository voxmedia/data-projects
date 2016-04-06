import csv
import collections


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
            try:
                result_row.append(row[key])
            except KeyError:
                continue
        result.append(result_row)

    headers = [headers]
    result = headers + result
    write(result, filename)


# create a census tract code from state fips, county fips & tractce
# with corresponding uace code
blocks = list()
data = read_as_dict('exports/blocks.csv')
for row in data:
    att = dict()
    att['id'] = row['statefp10'] + row['countyfp10'] + row['tractce10']
    att['u'] = row['uace10']
    blocks.append(att)

# print blocks

# group blocks by census tracts
tracts_grp = collections.defaultdict(list)

for block in blocks:
    tracts_grp[block['id']].append(block['u'])

# for each census tract grouping, return unique uace values
# write to file
tracts_classified = list()

for k, v in tracts_grp.items():
    att = dict()
    # return unique values in each list
    uniques = set(v)
    uniques_list = list(uniques)
    # classify as rural
    if len(uniques_list) == 1 and '' in uniques_list:
        att['c'] = 'r'
    # classify as urban
    elif '' not in uniques_list:
        att['c'] = 'u'
    # classify as mixed
    else:
        att['c'] = 'm'
    att['id'] = k
    att['l'] = uniques_list
    tracts_classified.append(att)

# write to csv
headers = ['id', 'c', 'l']
flatten_dict(tracts_classified, headers, 'exports/tracts-classification.csv')
