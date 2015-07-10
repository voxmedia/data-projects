#!/usr/bin/env python

import os
import sys

if len(sys.argv) < 2:
    sys.exit('Usage: %s data.json' % sys.argv[0])

if not os.path.exists(sys.argv[1]):
    sys.exit('ERROR: File %s was not found!' % sys.argv[1])

from datetime import datetime
from elasticsearch import Elasticsearch
import json

es = Elasticsearch()


def handle_file(fp):
    for line in fp:
        comment = json.loads(line)
        created = datetime.utcfromtimestamp(int(comment['created_utc']))
        retreived = datetime.utcfromtimestamp(int(comment['retrieved_on']))
        del comment['created_utc']
        del comment['retrieved_on']
        comment['created_utc'] = created
        comment['retrieved_on'] = retreived
        es.index(
            index='reddit', doc_type='comment',
            id=comment['id'], parent=comment['parent_id'],
            body=comment)


def main():
    # es.indices.delete(index='reddit', ignore=[400, 404])
    es.indices.create(index='reddit', body={
        "mappings": {"comment": {"_parent": {"type": "comment"}}}
    }, ignore=400)

    filename = sys.argv[1]

    if filename.endswith('.json'):
        with open(filename) as fp:
            handle_file(fp)
    elif filename.endswith('.bz2'):
        from bz2 import BZ2File
        with BZ2File(filename) as fp:
            handle_file(fp)

if __name__ == '__main__':
    main()
