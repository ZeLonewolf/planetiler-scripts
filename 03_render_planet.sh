#!/usr/bin/env bash

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

touch logs.txt
tail -f logs.txt | nc seashells.io 1337 > /tmp/seashells & sleep 10

sudo docker run --memory=120g -e JAVA_TOOL_OPTIONS='-Xmx100g -Xms100g -XX:OnOutOfMemoryError="kill -9 %p"' -v "$(pwd)/data":/data \
ghcr.io/onthegomap/planetiler:latest --area=planet --bounds=world --download --download-threads=10 --download-chunk-size-mb=1000 \
--nodemap-type=sparsearray --nodemap-storage=ram --building_merge_z13=false --fetch-wikidata | tee -a logs.txt
