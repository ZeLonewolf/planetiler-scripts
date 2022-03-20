#!/usr/bin/env bash

sudo mkfs.xfs /dev/nvme1n1
mkdir /home/ubuntu/build
sudo mount -t xfs /dev/nvme1n1 /home/ubuntu/build
cd /home/ubuntu/build
