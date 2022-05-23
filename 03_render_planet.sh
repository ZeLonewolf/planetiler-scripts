#!/usr/bin/env bash

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

sudo touch logs.txt
sudo tail -f logs.txt | sudo nc seashells.io 1337 > /tmp/seashells & sleep 10

sudo docker run -e JAVA_TOOL_OPTIONS='-Xmx115g' -v "$(pwd)/data":/data -v /mnt/efs:/output \
ghcr.io/onthegomap/planetiler:latest --area=planet --bounds=world \
  --mbtiles=/output/new-planet.mbtiles \
  --transportation_name_size_for_shield \ 
  --transportation_name_limit_merge \
  --storage=ram --mmap-temp --nodemap-type=array --building_merge_z13=false | sudo tee -a logs.txt
  
