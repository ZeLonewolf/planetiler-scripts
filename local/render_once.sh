#!/usr/bin/env bash

# Assumption: planet.osm.pbf is pre-positioned in data/sources

set -x

echo 'Start Render'
date -u '+%Y-%m-%d %H:%M:%S'

pyosmium-up-to-date -vvvv --size 10000 data/sources/planet.osm.pbf

./fetch_data_sources.sh
./render.sh

# Limit to 10MB/s with trickle (optional)
# Bandwidth is limited if saturating your network is a problem.
trickle -s -u 10240 aws s3 cp data/planet.pmtiles s3://planet-pmtiles/

rm -rf data/planet.pmtiles

echo 'Render Complete'
date -u '+%Y-%m-%d %H:%M:%S'
