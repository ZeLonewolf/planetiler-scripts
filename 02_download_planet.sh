#!/usr/bin/env bash

sudo docker run --memory=100g -e JAVA_TOOL_OPTIONS='-Xmx80g' -v "$(pwd)/data":/data \
  ghcr.io/onthegomap/planetiler:latest --area=planet --bounds=world --download --download-threads=10 --download-chunk-size-mb=1000 \
  --only-download --fetch-wikidata

sudo pyosmium-up-to-date -vvvv --size 10000 data/sources/planet.osm.pbf
