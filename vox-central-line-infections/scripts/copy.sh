#!/bin/bash

if [ ! -d "downloads" ]; then
    # Make a new directory and unzip the data into it
    mkdir downloads
fi

echo '- Copying hospital data...'
cp -r ../downloads ./