#!/bin/sh
curl -L "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=antimicro" > PKGBUILD.orig
cp -f PKGBUILD.orig PKGBUILD
patch < PKGBUILD.patch
