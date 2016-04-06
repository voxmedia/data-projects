import csv
import json

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


# this opens and reads a json file
def j_read(filename):
    with open(filename) as f:
        d = json.load(f)
    return d


# this writes output as json.
def write(data, filename):
    with open(filename, 'w') as f:
        json.dump(data, f, encoding='latin1')

# Join our lead risk csv data to our geojson data on the census tract id
lead_risk_score = read_as_dict('exports/lead-risk-score.csv')

geojson = j_read('exports/tracts.json')
features = geojson['features']

joined_data = list()
for tract in features:
    att = dict()
    att['id'] = tract['properties']['geoid']
    for row in lead_risk_score:
        if att['id'] == row['id']:
            att['n'] = row['name']
            att['d'] = safe_float(row['decile'])
            # att['ls'] = safe_float(row['leadriskscore_raw'])
            # att['wp'] = safe_float(row['weighted_poverty'])
            # att['wh'] = safe_float(row['weighted_housing'])
            # att['pz'] = safe_float(row['poverty_z'])
            # att['hz'] = safe_float(row['housing_z'])
            att['p'] = safe_float(row['poverty_risk'])
            att['h'] = safe_float(row['housing_risk'])
            # att['s'] = safe_float(row['sum_housing_risk'])
            # att['nn'] = safe_float(row['age00_10'])
            # att['en'] = safe_float(row['age80_99'])
            # att['se'] = safe_float(row['age60_79'])
            # att['fs'] = safe_float(row['age40_59'])
            # att['o'] = safe_float(row['age_39'])
            # att['t'] = safe_float(row['total'])
            # append our att dict to our geojson properties
            tract['properties'] = att
            joined_data.append(tract)

# print joined_data

new_geojson = {
    "type": "FeatureCollection",
    "features": joined_data
}

write(new_geojson, 'exports/tracts-data.json')
