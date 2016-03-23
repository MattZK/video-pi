#!/bin/sh

CMD="/usr/bin/omxplayer -b"

IFS=$'\n'
while true; do
    for f in `find "$1" -type f | sort`
    do
        eval "$CMD \"$f\""
        # if [ $? -ne 0 ]; then
        #     exit $?
        # fi
    done
done
