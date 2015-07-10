#!/bin/bash
export HOSTNAME=`hostname`
elasticsearch -Des.config=`pwd`/elasticsearch.yml
