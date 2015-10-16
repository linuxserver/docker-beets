#!/bin/bash

[[ ! -f /config/beets.sh ]] && cp /defaults/beets.sh /config/beets.sh
[[ ! -f /config/config.yaml ]] && cp /defaults/config.yaml /config/config.yaml

chown -R abc:abc /config

