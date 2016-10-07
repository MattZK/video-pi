#!/bin/bash

/usr/bin/mplayer -loop 0 -fs -zoom -shuffle -playlist <($HOME/bin/find.sh "$1")
