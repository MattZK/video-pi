#!/bin/sh

mkdir -p "$HOME/.log/"

/usr/bin/devmon --exec-on-drive "killall mpv; $HOME/bin/play-dir-mpv.sh \"%d\""\
                --exec-on-unmount "killall mpv"\
                --exec-on-remove "killall mpv"\
                --always-exec &> "$HOME/.log/devmon.log"\
