#!/usr/bin/env bash
# set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo verify site from sitemap.xml links
cat "$DIR/../src/sitemap.xml" | rg loc | rg -o '>.*<' | sed 's/[><]//g' | \
 while read l; do echo "$l"; vnu.sh "$l"; done

