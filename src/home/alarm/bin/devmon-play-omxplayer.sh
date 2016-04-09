#!/bin/sh

mkdir -p "$HOME/.log/"

/usr/bin/devmon --exec-on-drive "killall omxplayer.bin; $HOME/bin/play-dir-omxplayer.sh \"%d\""\
                --exec-on-unmount "killall omxplayer.bin"\
                --exec-on-remove "killall omxplayer.bin"\
                --always-exec &> "$HOME/.log/devmon.log"
