#!/bin/sh

mkdir -p "$HOME/.log/"

/usr/bin/devmon --exec-on-drive "killall mplayer; $HOME/bin/play-dir-mplayer.sh \"%d\""\
                --exec-on-unmount "killall mplayer"\
                --exec-on-remove "killall mplayer"\
                --always-exec &> "$HOME/.log/devmon.log"
