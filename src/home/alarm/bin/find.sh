#!/bin/sh
find $1 -type f | sort $2 |
grep -vi .DS_Store |
grep -vi .AppleDouble |
grep -vi .LSOverride |
grep -vi desktop.ini |
grep -vi Thumbs.db |
grep -vi ehthumbs.db |
grep -vi Desktop.ini |
grep -vi $RECYCLE.BIN |
grep -v -E "\/\."
