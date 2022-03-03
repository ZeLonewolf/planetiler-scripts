#!/usr/bin/env bash

mkfs.xfs /dev/nvme2n1
mkdir /home/ubuntu/build
mount -t xfs /dev/nvme2n1 /home/ubuntu/build
cd /home/ubuntu/build
