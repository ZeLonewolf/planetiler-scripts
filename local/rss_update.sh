#!/bin/bash

# Check for input parameter (the message to be added)
if [ $# -lt 1 ]; then
    echo "Usage: $0 <message>"
    exit 1
fi

TITLE=$1
MESSAGE=$2
RSS_FILE="rss.xml"
CURRENT_DATE=$(date +"%Y-%m-%dT%H:%M:%SZ")

# Escape HTML special characters in the message
MESSAGE=$(echo "$MESSAGE" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&apos;/g')

# Check if the RSS file exists
if [ ! -f $RSS_FILE ]; then
    # If the RSS file doesn't exist, create a new one
    echo '<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0">
<channel>
    <title>ourmap.us Planet Build</title>
    <link>https://tile.ourmap.us/</link>
    <description>Planet build status</description>
</channel>
</rss>' > $RSS_FILE
fi

# Add the new item entry to the RSS file
xmlstarlet ed --inplace \
    -s "//channel" -t elem -n "item" -v "" \
    -s "//channel/item[last()]" -t elem -n "title" -v "$TITLE" \
    -s "//channel/item[last()]" -t elem -n "pubDate" -v "$CURRENT_DATE" \
    -s "//channel/item[last()]" -t elem -n "description" -v "$MESSAGE" \
    $RSS_FILE

echo "New entry added to $RSS_FILE"
aws s3 cp rss.xml s3://tileserver-static/
