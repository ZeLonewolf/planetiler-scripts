#!/usr/bin/env bash

sudo mkdir -p data/sources

sudo aws s3 cp s3://planet-pmtiles/planet.osm.pbf data/sources/

sudo docker run -e JAVA_TOOL_OPTIONS='-Xmx80g' -v "$(pwd)/data":/data \
  ghcr.io/onthegomap/planetiler:latest --download --only-fetch-wikidata
