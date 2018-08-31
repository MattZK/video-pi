#!/bin/sh

set -e

sudo apt-get install checkinstall
sudo apt-get install libjpeg8-dev libpng12-dev
git clone --depth=1 https://github.com/HaarigerHarald/omxiv
cd omxiv
make ilclient
make
checkinstall -D make install
