#!/usr/bin/env bash

sudo docker run --memory=10g -e JAVA_TOOL_OPTIONS='-Xmx10g -Xms10g -XX:OnOutOfMemoryError="kill -9 %p"' -v "$(pwd)/data":/data \
  ghcr.io/onthegomap/planetiler:latest --area=planet --bounds=world --download --download-threads=10 --download-chunk-size-mb=1000 \
  --only-download

sudo pyosmium-up-to-date -vvvv --size 10000 data/sources/planet.osm.pbf
