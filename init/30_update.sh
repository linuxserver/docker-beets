#!/bin/bash

# opt out for autoupdates
[ "$ADVANCED_DISABLEUPDATES" ] && exit 0

pip install -U pyacoustid
pip install -U pylast
pip install -U flask
pip install -U pillow
pip install -U beets
