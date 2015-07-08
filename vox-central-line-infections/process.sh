#!/bin/bash
timestamp=$(date "+%Y-%m-%d--%H-%M-%S")
process_dir=$(echo $timestamp)

# Copy scripts into a process folder
cp -r scripts "$process_dir"

# cd into process folder and run the scripts
cd "$process_dir"
./run.sh