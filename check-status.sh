#!/bin/bash

token=""
id_file="containers-id.list"
username=""

# read file with containers id that will be checked for running status
# obs: bash only
while read line ; do
  if [ "`docker ps -q -f id=$line`" == "" ] ; then
    # Get docker container name
    name=`docker ps -a --format "{{.Names}}" -f id=$line`
    image=`docker ps -a --format "{{.Image}}" -f id=$line`
    status=`docker ps -a --format "{{.Status}}" -f id=$line`
    # get logs with stdout and stderr
    logs=`docker logs $line 2>&1 | tail -n 1000`

    # format text, logs are to be send as a '.log' file annexed to the message
    text=":warning: CONTAINER **\`$name\`** WITH IMAGE \`$image\` STOPPED WITH STATUS \`$status\`."
    # create tmp file with logs
    echo "$logs" > /tmp/$name.log
    curl -X POST -H "Content-Type: multipart/form-data" \
    -F "payload_json={\"username\": \"Docker\",\"embeds\":[{\"description\": \"$text\", \"title\":\"Docker Status Error\", \"color\":16711680}]}" \
    -F "file=@/tmp/$name.log" \
    "$token"
    text=""
  fi
done < $id_file
