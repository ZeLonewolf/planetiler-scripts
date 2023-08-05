!#/bin/sh
sudo pyosmium-get-changes -vvvv --size 10000 -O planet.osm.pbf -o planetdiff.osc
sudo osmosis --read-pbf planet.osm.pbf --read-xml-change file="planetdiff.osc" --apply-change --write-pbf planet-updated.osm.pbf
sudo rm -rf planet.osm.pbf
sudo mv planet-updated.osm.pbf planet.osm.pbf
