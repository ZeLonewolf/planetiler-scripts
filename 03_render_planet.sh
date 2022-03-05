#!/usr/bin/env bash

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

touch logs.txt
tail -f logs.txt | nc seashells.io 1337 > /tmp/seashells & sleep 10

sudo docker run -e JAVA_TOOL_OPTIONS='-Xmx100g' -v "$(pwd)/data":/data -v /mnt/efs:/output \
ghcr.io/onthegomap/planetiler:latest --area=planet --bounds=world \
  --mbtiles=/output/new-planet.mbtiles \
  --nodemap-type=sparsearray --nodemap-storage=ram --building_merge_z13=false | tee -a logs.txt
