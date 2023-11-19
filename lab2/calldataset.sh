#!/bin/sh

givename() {
  for i in $(seq -w 1 1000); do
    if [ ! -f "/shared_volume/file_$i" ]; then
      echo "file_$i"
      return
    fi
  done
}

exec 9>/shared_volume/lock_file
flock -n 9 || exit 1

filename=$(givename)
if [ -z "$filename" ]; then
  echo "All filenames are already taken."
  exit 1
fi

container_id=$(uname -n)
file_counter=1


echo "$container_id - $file_counter" > "/shared_volume/$filename"

sleep 1


rm "/shared_volume/$filename"


flock -u 9
exec 9>&-