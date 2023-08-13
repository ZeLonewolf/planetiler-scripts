#!/usr/bin/env bash

sudo mkdir -p data/sources

sudo docker run -e JAVA_TOOL_OPTIONS='-Xmx80g' -v "$(pwd)/data":/data \
  ghcr.io/onthegomap/planetiler:latest --download --download-only --only-fetch-wikidata

sudo aws s3 cp s3://planet-pmtiles/planet.osm.pbf data/sources/

# Remove incidental download
sudo rm -f data/sources/monaco.osm.pbf
