#!/usr/bin/env bash

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

touch logs.txt
tail -f logs.txt | nc seashells.io 1337 > /tmp/seashells & sleep 10

sudo docker run --memory=120g -e JAVA_TOOL_OPTIONS='-Xmx90g' -v "$(pwd)/data":/data \
ghcr.io/onthegomap/planetiler:latest --area=planet --bounds=world \
  --mbtiles=/mnt/efs/new-planet.mbtiles \
  --nodemap-type=sparsearray --nodemap-storage=ram --building_merge_z13=false | tee -a logs.txt
