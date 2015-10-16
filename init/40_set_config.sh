#!/bin/bash

# Check if beets.sh exists. If not, copy in
if [ -f /config/beets.sh ]; then
  echo "Using existing config file."
else
  echo "Creating beets.sh from template."
  cp -v /defaults/beets.sh /config/beets.sh
  chown abc:abc /config/beets.sh
  chmod +x /config/beets.sh
fi


# Check if config.yaml exists. If not, copy in
if [ -f /config/config.yaml ]; then
  echo "Using existing config file."
else
  echo "Creating config.yaml from template."
  cp /defaults/config.yaml /config/config.yaml
  chown abc:abc /config/config.yaml
fi

