#!/bin/sh

CMD="/usr/bin/omxplayer -b"

IFS=$'\n'
while true; do
    for f in `$HOME/bin/find.sh "$1" --random-sort`
    do
        eval "$CMD \"$f\""
        # if [ $? -ne 0 ]; then
        #     exit $?
        # fi
    done
done
