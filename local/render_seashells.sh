#!/usr/bin/env bash

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

sudo touch logs.txt
sudo tail -f logs.txt | sudo nc seashells.io 1337 > /tmp/seashells_render & sleep 10

# Fetch a random joke from the API
JOKE=$(curl -s -H "Accept: application/json" https://icanhazdadjoke.com/ | jq -r '.joke')

# Read the URL from /tmp/seashells_render
URL=$(cat /tmp/seashells_render)

./rss_update.sh "Build Started" "Server output: ${URL}. Here's a joke while you wait: ${JOKE}"

run() {
  TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
  ./render_once.sh

  # Check the exit status of render_once.sh
  if [ $? -eq 0 ]; then
    ./rss_update.sh "Build Complete" "Tiles are up to date as of ${TIMESTAMP}"
  else
    ./rss_update.sh "Build Failed" "Review the build log at ${URL} to find out why."
  fi
}

run 2>&1 | sudo tee -a logs.txt
