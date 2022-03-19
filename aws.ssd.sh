#!/bin/bash

# Executed from home directory of default AWS image user
# Requires machine with 100GB ram and >400G SSD such as m5dn.8xlarge.

sudo apt -y install nfs-common git
sudo mkdir /mnt/efs

# Mount EFS share where mbtiles will be stored
# fs ID needs to change if using different EFS mount
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-04aa7452c3c7a4ac2.efs.us-east-2.amazonaws.com:/ /mnt/efs

git clone https://github.com/ZeLonewolf/planetiler-scripts.git

planetiler-scripts/00_setup.sh
planetiler-scripts/01_mount_drive.sh

cd build

../planetiler-scripts/02_download_planet.sh
../planetiler-scripts/03_render_planet.sh
../planetiler-scripts/04_copy_mbtiles.sh
