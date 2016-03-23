#!/bin/bash

/usr/bin/mplayer -loop 0 -fs -zoom -playlist <(find "$1" -type f | sort)
