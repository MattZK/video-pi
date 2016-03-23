#!/bin/sh

# cd

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

# Install make

if [[ ! -f /usr/bin/make ]]; then
    pacman -S make --noconfirm
fi

# Run make

make
