from difflib import SequenceMatcher
import csv
import re
import heapq


# this opens and reads a csv data as a list
def read(filename):
    data = []
    with open(filename, 'rU') as f:
        f = csv.reader(f)
        for row in f:
            data.append(row)

    return data


# this opens and reads a csv data as a list
def read_tsv(filename):
    data = []
    with open(filename, 'rU') as f:
        f = csv.reader(f, delimiter='\t')
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


# this opens and reads csv data as a dict
def read_as_dict_tsv(filename):
    csv = read_tsv(filename)
    headers = csv.pop(0)
    data = list()
    for row in csv:
        d = dict()
        for index, header in enumerate(headers):
            d[header] = row[index]
        data.append(d)
    return data


# smarter way to take a list of dicts and write to csv
def write_dict(data, filename):
    with open(filename, 'wb') as f:
        keys = data[0].keys()
        dict_writer = csv.DictWriter(f, keys)
        dict_writer.writeheader()
        dict_writer.writerows(data)


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


# this writes output as a csv
def write(data, filename):
    with open(filename, 'wb') as f:
        writer = csv.writer(f)
        writer.writerows(data)


# this will sort a dict of list of dictionaries based on a key value.
def sort_from_dict(d, i):
    dic = {}
    for r in d:
        if r[i] in dic:
            dic[r[i]].append(r)
        else:
            dic[r[i]] = [r]
    return dic


# this tries to convert a str into an int and throws an error if not possible.
def safe_int(s):
    n = 0
    try:
        n = int(s)
    except:
        if s != '':
            print "Cannot turn %s into int" % s
    return n


# this tries to convert a str into a float and throws an error if not possible.
def safe_float(s):
    n = 0
    try:
        n = float(s)
    except:
        if s != '':
            print "Cannot turn %s into float" % s
    return n


# this function tries to converts all s to rounded int w/ no decimal places
# the except error is included to ensure empty strings are processed.
def round_numbers(s):
    try:
        return int(round(float(s)))
    except ValueError:
        return s


# this function anticipates s that should be floats
# and converts all s to rounded int w/ no decimal places
# the except error is included to ensure empty strings are processed.
def round_pcts(s):
    try:
        return int(round(float(s) * 100))
    except ValueError:
        return s


# this looks at a str and only returns digits.
def numbers_only(s):
    return re.sub(r'[^\d\.]', '', s)


# this function removes both leading and trailing white spaces.
# use when data is in a list format
def rm_trails(s):
    return s.strip()


# remove leading and trailing whitespace in a dict.
def remove(d):
    return {k.strip(): remove(v)
            if isinstance(v, dict)
            else v.strip()
            for k, v in d.iteritems()}


### HAVE YET TO TRY THESE FUNCTIONS ####
def sequence_match(a, b):
    s = SequenceMatcher(lambda x: x == ' ', a, b)
    return round(s.ratio(), 3)


def pluck(data, columns):
    h = data[0]
    indices = []
    for c in columns:
        if c in h:
            indices.append(h.index(c))
        else:
            print "ERROR: '%s' is not to be found in this data" % c

    plucked = []
    for r in data:
        row = []
        for i in indices:
            row.append(r[i])
        plucked.append(row)
    # the header is still present, so remove it and replace with new column header
    plucked.pop(0)
    return [columns] + plucked


def found_bounded_word(needle, haystack):
    result = re.findall('\\b' + needle + '\\b', haystack, flags = re.IGNORECASE)
    if result:
        return True
    else:
        return False


def find_in(needle, haystack, i):
    for hay in haystack:
        if hay[i] == needle:
            return hay
    return -1


def join(a, a_i, b, b_i):
    for row in a:
        found = find_in(row[a_i], b, b_i)
        if found != -1:
            row += found
    return a
