#!/bin/bash

/usr/bin/mpv --loop=inf --fs --playlist <(find "$1" -type f | sort)
