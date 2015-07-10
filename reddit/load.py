#!/usr/bin/env python

import os
import sys

if len(sys.argv) < 2:
    sys.exit('Usage: %s data.json.bz2' % sys.argv[0])

if not os.path.exists(sys.argv[1]):
    sys.exit('ERROR: File %s was not found!' % sys.argv[1])

from datetime import datetime
from elasticsearch import Elasticsearch, helpers
import json

es = Elasticsearch()


def actions(filename):
    with open_file(filename) as fp:
        for line in fp:
            yield make_action(line)


def make_action(json_string):
    doc = parse_comment(json_string)
    return {
        '_index': 'reddit',
        '_type': 'comment',
        '_id': doc['id'],
        '_parent': doc['parent_id'],
        '_source': doc
    }


def parse_comment(json_string):
    comment = json.loads(json_string)

    created = datetime.utcfromtimestamp(int(comment['created_utc']))
    retreived = datetime.utcfromtimestamp(int(comment['retrieved_on']))
    del comment['created_utc']
    del comment['retrieved_on']
    comment['created_utc'] = created
    comment['retrieved_on'] = retreived

    return comment


def open_file(filename):
    if filename.endswith('.json'):
        return open(filename)
    elif filename.endswith('.bz2'):
        from bz2 import BZ2File
        return BZ2File(filename)


def simple_load(filename):
    with open_file(filename) as fp:
        for line in fp:
            comment = parse_comment(line)
            es.index(
                index='reddit', doc_type='comment',
                id=comment['id'], parent=comment['parent_id'],
                body=comment)


def bulk_load(filename):
    successes, errors = helpers.bulk(es, actions(filename))
    print "Added %i documents" % successes
    if len(errors) > 0:
        print errors.join("\n")
    else:
        print 'No errors'


def main():
    # es.indices.delete(index='reddit', ignore=[400, 404])
    es.indices.create(index='reddit', body={
        "mappings": {"comment": {"_parent": {"type": "comment"}}}
    }, ignore=400)

    filename = sys.argv[1]

    print """

Starting data import, this will take a long time...

"""
    bulk_load(filename)

if __name__ == '__main__':
    main()
