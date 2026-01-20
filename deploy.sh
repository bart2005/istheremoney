#!/usr/bin/env bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
FORMAT="%Y.%m.%d %H:%M:%S"
DATE=`date +"$FORMAT"`
FILE="$DIR"/src/index.html

function update_time() {
  rgx="$1"
  file_to_update=$(rg -l "$rgx" src)
  echo "$file_to_update"
  modify_date=$(stat -c "%Y" "$file_to_update" | xargs -I[] date -d @[] +"$FORMAT")
  echo $modify_date
  sed "s/$rgx datetime=.*</$rgx datetime='${modify_date}'>${modify_date}</g" -i "$file_to_update"
}

echo "update time to $DATE"
sed "s/id='upd' datetime=.*</id='upd' datetime='${DATE}'>${DATE}</g" -i "$FILE"

update_time "id='update-todo'"
update_time "id='update-plan'"
update_time "id='update-state'"
# git commit -a -m "datetime update to ${DATE}"
# git push
