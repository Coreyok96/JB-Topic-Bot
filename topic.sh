#!/bin/bash

input=".bot.cfg"

while true; do
	inotifywait -r -e close_write,create ./announcement && TOPIC=$(cat ./announcement/announcement.txt) && echo "TOPIC #$channel :$TOPIC" >> $input
done