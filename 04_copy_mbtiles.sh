#!/usr/bin/env bash

rm -rf /mnt/efs/output.mbtiles
rsync --progress data/output.mbtiles /mnt/efs/planet.mbtiles
