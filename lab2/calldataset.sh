#!/bin/sh -e

containerid=$(uname -n)

givename() {
  for i in $(seq -w 1 1000); do
    if [ ! -f "/shared_volume/file_$i" ]; then
      echo "file_$i"
      return
    fi
  done
}

createfile() {
  exec 9>/shared_volume/lock_file
  flock -n 9

  filename=$(givename)
  echo "$containerid - $filename" > "/shared_volume/$filename"

  flock -u 9
  exec 9>&-
}

deletefile() {
  file=$(<"/shared_volume/$filename")
  rm -f "/shared_volume/$filename"
  echo "$containerid : $file"
}

while true; do
  createfile
  sleep 1
  deletefile
done
