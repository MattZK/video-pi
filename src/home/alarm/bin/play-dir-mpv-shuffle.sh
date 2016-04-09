#!/bin/bash

/usr/bin/mpv --loop=inf --fs --shuffle --playlist <(find "$1" -type f | sort)
