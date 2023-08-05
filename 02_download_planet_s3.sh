#!/usr/bin/env bash

sudo mkdir -p data/sources

sudo docker run -e JAVA_TOOL_OPTIONS='-Xmx80g' -v "$(pwd)/data":/data \
  ghcr.io/onthegomap/planetiler:latest --osm-url=https://planet-pmtiles.s3.us-east-2.amazonaws.com/planet.osd.pbf \
  --download --download-threads=20 --download-chunk-size-mb=500 --only-fetch-wikidata
