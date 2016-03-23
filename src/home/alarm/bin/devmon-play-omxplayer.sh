#!/bin/sh

DIR="$( cd "$( dirname "$0" )" && pwd )"

mkdir -p "$HOME/.log/"

/usr/bin/devmon --exec-on-drive "killall omxplayer.bin; $DIR/play-dir-omxplayer.sh \"%d\""\
                --exec-on-unmount "killall omxplayer.bin"\
                --exec-on-remove "killall omxplayer.bin"\
                --always-exec &> "$HOME/.log/devmon.log"
