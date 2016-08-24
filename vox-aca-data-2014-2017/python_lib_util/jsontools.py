import json

# this opens and reads a json file
def read(filename):
    with open(filename) as f:
        d = json.load(f)
    return d

# this writes output as json.
def write(data, filename):
    with open(filename, 'w') as f:
        json.dump(data, f)

# this writes json so it's hierarchial structure is preserved.
def pretty_write(data, filename):
    with open(filename, 'w') as f:
        json.dump(data, f, sort_keys=True,
                indent=4, separators=(',', ': '))

### HAVE NOT USED
def write_all(data_object, loc):
    write_count = 0
    for k in data_object:
        write_count += 1
        write(data_object[k], loc + k + '.json')
    return write_count
