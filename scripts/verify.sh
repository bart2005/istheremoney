#!/usr/bin/env bash
# set -e
TRG="$1"
echo verify files by path:$TRG
# vnu.sh "$TRG/index.html"
fd -tf "html$" "$TRG" | while read f
  do
    echo "$f"
    vnu.sh "$f"
    
done 


