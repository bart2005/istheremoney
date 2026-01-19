#!/usr/bin/env bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DATE=`date +"%Y-%m-%d %H:%M:%S"`
FILE="$DIR"/src/index.html
sed "s/id='upd' datetime='2026.01.19 12:54:47'>.*</id='upd' datetime='${DATE}'>${DATE}</g" -i "$FILE"
git commit -a -m "datetime update to ${DATE}"
git push
