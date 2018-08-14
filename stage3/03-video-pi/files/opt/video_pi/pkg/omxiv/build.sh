#!/bin/bash

set -euo pipefail
set -x

sudo apt-get install libjpeg8-dev libpng12-dev
cd "$(mktemp -d)"
git clone https://github.com/HaarigerHarald/omxiv
cd omxiv
make ilclient
make
sudo make install
