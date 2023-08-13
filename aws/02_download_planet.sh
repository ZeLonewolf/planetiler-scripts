#!/usr/bin/env bash

mkdir -p data/sources
sudo cp /mnt/efs/wikidata_names.json data/sources/ 

sudo docker run -e JAVA_TOOL_OPTIONS='-Xmx80g' -v "$(pwd)/data":/data \
  ghcr.io/onthegomap/planetiler:latest --area=planet --bounds=world --download --download-threads=20 --download-chunk-size-mb=500 \
  --only-fetch-wikidata

sudo cp data/sources/wikidata_names.json /mnt/efs/

sudo pyosmium-up-to-date -vvvv --size 10000 data/sources/planet.osm.pbf
