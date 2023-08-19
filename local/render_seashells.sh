#!/usr/bin/env bash

# Define the lock file
LOCKFILE="/tmp/planet-render.lock"

# Check if lock file exists
if [ -e "${LOCKFILE}" ]; then
  echo "A rendering process is already running."
  exit 1
else
  # Create a lock file
  touch "${LOCKFILE}"

  # Ensure the lock file is removed when we exit and when we receive signals
  trap "rm -f ${LOCKFILE}; trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT
fi

sudo touch logs.txt
sudo tail -f logs.txt | sudo nc seashells.io 1337 > /tmp/seashells_render & sleep 10

# Get the size of the file in bytes
OSM_PLANET_SIZE=$(stat -c%s "data/sources/planet.osm.pbf")

# Print the size with comma separators
OSM_PLANET_SIZE=$(printf "%'d" $OSM_PLANET_SIZE)

# Get the directory of the current script
DIR="$(dirname "$0")"

"$DIR/rss_update.sh" "Build Started." "The OSM planet file is ${OSM_PLANET_SIZE} bytes."

run() {
  TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
  START_TIME=$(date +%s)
  "$DIR/render_once.sh"

  # Check the exit status of render_once.sh
  if [ $? -eq 0 ]; then
    # Record the end time
    END_TIME=$(date +%s)

    # Calculate the time difference
    TIME_DIFF=$((END_TIME - START_TIME))

    # Convert the time difference to hours and minutes
    HOURS=$((TIME_DIFF / 3600))
    MINUTES=$(((TIME_DIFF / 60) % 60))

    # Format hours and minutes with singular or plural as appropriate
    HOUR_TEXT="hours"
    MINUTE_TEXT="minutes"
    if [ "$HOURS" -eq 1 ]; then
      HOUR_TEXT="hour"
    fi
    if [ "$MINUTES" -eq 1 ]; then
       MINUTE_TEXT="minute"
    fi

    # Get the size of the file in bytes
    PMTILES_PLANET_SIZE=$(stat -c%s "data/planet.pmtiles")

    # Print the size with comma separators
    PMTILES_PLANET_SIZE=$(printf "%'d" $PMTILES_PLANET_SIZE)

    "$DIR/rss_update.sh" "Build Complete" "Tiles are up to date as of ${TIMESTAMP}Z. Render took ${HOURS} ${HOUR_TEXT} and ${MINUTES} ${MINUTE_TEXT}. The planet PMTiles file is ${PMTILES_PLANET_SIZE} bytes"
  else
    "$DIR/rss_update.sh" "Build Failed" "Review the build log to find out why."
  fi
}

run 2>&1 | sudo tee -a logs.txt
