#!/bin/bash

/usr/bin/mpv --loop=inf --fs --playlist <($HOME/bin/find.sh "$1")
