#!/bin/sh

mkdir -p /data/sources
mkdir -p /data/tmp

docker run -e JAVA_TOOL_OPTIONS='-Xmx2g' -v "$(pwd)/data":/data \
  -u $(id -u ${USER}):$(id -g ${USER}) \
  ghcr.io/onthegomap/planetiler:latest \
  --download --download-only --only-fetch-wikidata

rm -rf data/sources/monaco.osm.pbf

