#!/usr/bin/env bash

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

sudo touch logs.txt
sudo tail -f logs.txt | sudo nc seashells.io 1337 > /tmp/seashells & sleep 10

run() {
  set -x
  sudo docker run -e JAVA_TOOL_OPTIONS='-Xmx30g' -v "$(pwd)/data":/data \
    ghcr.io/onthegomap/planetiler:latest --area=planet --bounds=world \
    --mbtiles=/data/new-planet.mbtiles \
    --transportation_name_size_for_shield \
    --transportation_name_limit_merge \
    --storage=mmap --nodemap-type=array --building_merge_z13=false
  sudo time cp /data/new-planet.mbtiles /mnt/efs/new-planet.mbtiles
}

run | sudo tee -a logs.txt
