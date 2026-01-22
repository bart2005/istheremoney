#!/usr/bin/env bash
# set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
FORMAT="%Y.%m.%d %H:%M:%S"
DATE=`date +"$FORMAT"`
FILE="$DIR"/src/index.html
cd "$DIR"
function update_time() {
  FILES_MD5=".files_md5"
  RGX="$1"
  FILE_TO_UPDATE=$(rg -l "$RGX" src)
  echo "try to update time for file: $FILE_TO_UPDATE"
  MODIFY_DATE=$(stat -c "%Y" "$FILE_TO_UPDATE" | xargs -I[] date -d @[] +"$FORMAT")
  #echo file modify time: $MODIFY_DATE
  LAST_FILE_HASH=$(rg "$FILE_TO_UPDATE" "$FILES_MD5")
  if [[ -z "$LAST_FILE_HASH" ]]; then echo write md5sum;  md5sum "$FILE_TO_UPDATE" | tee -a "$FILES_MD5"; fi
  CURR_FILE_HASH=$(md5sum "$FILE_TO_UPDATE")
  #echo LAST_FILE_HASH: $LAST_FILE_HASH
  #echo CURR_FILE_HASH: $CURR_FILE_HASH
  if [[ "$LAST_FILE_HASH" == "$CURR_FILE_HASH" ]]
  then
    echo file "$FILE_TO_UPDATE was not updated"
  else
    sed "s/$RGX datetime=.*</$RGX datetime='${MODIFY_DATE}'>${MODIFY_DATE}</g" -i "$FILE_TO_UPDATE"
    CURR_FILE_HASH=$(md5sum "$FILE_TO_UPDATE")
    echo updated file hash:$CURR_FILE_HASH
    sed "s|.*$FILE_TO_UPDATE|$CURR_FILE_HASH|g" -i "$FILES_MD5"
  fi
}

echo "update site time to $DATE"
sed "s/id='upd' datetime=.*</id='upd' datetime='${DATE}'>${DATE}</g" -i "$FILE"

update_time "id='update-todo'"
update_time "id='update-plan'"
update_time "id='update-state'"

./sitemap.sh | tee ./src/sitemap.xml
# git commit -a -m "datetime update to ${DATE}"
# git push
