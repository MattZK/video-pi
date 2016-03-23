#!/bin/sh

DIR="$( cd "$( dirname "$0" )" && pwd )"

mkdir -p "$HOME/.log/"

/usr/bin/devmon --exec-on-drive "killall mplayer; $DIR/play-dir-mplayer.sh \"%d\""\
                --exec-on-unmount "killall mplayer"\
                --exec-on-remove "killall mplayer"\
                --always-exec &> "$HOME/.log/devmon.log"
