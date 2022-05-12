#!/usr/bin/env bash

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

sudo touch logs.txt
sudo tail -f logs.txt | sudo nc seashells.io 1337 > /tmp/seashells & sleep 10

sudo docker run -e JAVA_TOOL_OPTIONS='-Xmx100g' -v "$(pwd)/data":/data -v /mnt/efs:/output \
ghcr.io/onthegomap/planetiler:latest --area=planet --bounds=world \
  --mbtiles=/output/new-planet.mbtiles \
  --mmap-temp --nodemap-type=sparsearray --nodemap-storage=ram --building_merge_z13=false | sudo tee -a logs.txt
