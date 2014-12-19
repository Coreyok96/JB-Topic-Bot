#!/bin/bash

. bot.properties
input=".bot.cfg"
echo "Starting session: $(date "+[%y:%m:%d %T]")">$log 
echo "NICK $nick" > $input 
echo "USER $user" >> $input

tail -f $input | telnet $server 6667 | while read res
do
  # log the session
  echo "$(date "+[%y:%m:%d %T]")$res" >> $log
  # do things when you see output
  case "$res" in
    # respond to ping requests from the server
    PING*)
      echo "$res" | sed "s/I/O/" >> $input 
    ;;
    # for pings on nick/user
    *"005"*)
	  echo "PRIVMSG NickServ :IDENTIFY $password" >> $input
      echo "JOIN #$channel" >> $input
	  sleep 3
	  while true; do
	    inotifywait -r -e close_write,create ./announcement && TOPIC=$(cat ./announcement/announcement.txt) && echo "TOPIC #$channel :$TOPIC" >> $input
	    done
    ;;
    *)
    ;;
  esac
  
	
done
