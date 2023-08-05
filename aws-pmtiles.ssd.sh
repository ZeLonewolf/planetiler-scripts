#!/bin/bash

# Executed from home directory of default AWS image user
# Requires machine with 100GB ram and >400G SSD such as m5dn.8xlarge.

sudo apt -y install git

git clone https://github.com/ZeLonewolf/planetiler-scripts.git

planetiler-scripts/00_setup_pmtiles.sh
planetiler-scripts/01_mount_drive.sh

cd build

../planetiler-scripts/02_download_planet_s3.sh
../planetiler-scripts/03_render_planet_pmtiles.sh
