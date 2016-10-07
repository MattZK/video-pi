#!/bin/sh
curl -L "https://git.archlinux.org/svntogit/community.git/plain/trunk/PKGBUILD?h=packages/mpv" > PKGBUILD.orig
cp -f PKGBUILD.orig PKGBUILD
patch < PKGBUILD.patch
