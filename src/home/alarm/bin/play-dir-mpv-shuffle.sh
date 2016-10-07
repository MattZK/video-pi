#!/bin/bash

/usr/bin/mpv --loop=inf --fs --shuffle --playlist <($HOME/bin/find.sh "$1")
