#!/usr/bin/env bash
DATE=`date +"%Y-%m-%d %H:%M:%S"`
cat src/index.html| sed "s/id='upd' datetime='2026.01.19 12:54:47'>.*</id='upd' datetime='${DATE}'>${DATE}</g"
git commit -a -m "datetime update to ${DATE}"
# git push
