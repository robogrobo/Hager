#!/bin/sh

# getting impuls count from hager ec352 via arduino/network
# forward  it to google spreadsheet for processing
# run as background process
#
# author: dominik grob

PORT=4919
FIELD1='entry.1.single'
FORMKEY=''

while true
do
  impuls=$(nc -l $PORT)
  curl -s -d $FIELD1'='$impuls 'https://docs.google.com/spreadsheet/formResponse?formkey='$FORMKEY > /dev/null 2>&1
done
