#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters; Must pass exactly one parameter, the TCELL API KEY"
fi

TCELL_API_KEY=$1
SRC_APP=samplemigrationstage-li5am
DEST_APP=samplemigrationprod-59tdb

response=$(curl -H "Authorization: Bearer $TCELL_API_KEY" --write-out %{http_code} --silent  -o stage.config.json --url https://api.tcell.io/customer/api/v1/apps/$SRC_APP/configs/latest)

if [[ "$response" -ne 200 ]] ; then
  echo "bad response $response"
  exit 1
fi

update_response=$(curl -d @stage.config.json --write-out %{http_code} --silent --output /dev/null -H "Authorization: Bearer $TCELL_API_KEY" -X POST -H "Content-Type: application/json" https://api.tcell.io/customer/api/v1/apps/$DEST_APP/configs)
if [[ "$update_response" -ne 200 ]] ; then
  echo "bad response to update config $update_response"
  exit 1
fi
