#!/bin/sh

# getting impuls count from hager ec352 via arduino/network
# forward  it to google spreadsheet for processing
# run as background process
#
# author: dominik grob

PORT=4919
FIELD1='entry.1.single'
FORMKEY=''
LOG_FILE=/Users/honzo/Documents/bot/hager.log

while true
do
  impuls=$(nc -l -d $PORT)
  log_date=$(date)

  if [ ! -z $impuls ]
  then
    curl -s -d $FIELD1'='$impuls 'https://docs.google.com/spreadsheet/formResponse?formkey='$FORMKEY > /dev/null 2>&1
    echo $log_date" "$impuls >> $LOG_FILE
  else
    echo $log_date" no value received" >> $LOG_FILE
  fi
done
