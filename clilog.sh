#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Provide Log File Path as Arugment. Example: /home/abowman/logs/20240403.txt"
  exit 1
fi

log_file=$1

echo "CTRL+C to Quit"
echo "Choose an Option"
echo "1) Run"
echo "2) Search & Pounce"
read -p "Selection: " method

if [ $method = "1" ]; then
  echo "-----"
  read -p "Frequency (MHz): " frequency

  while true; do
    echo "-----"
    read -p "Call: " call
    curl -sL https://api.hamdb.org/$call/json/clilog
    echo ""
    echo "-----"
    read -p "Name: " name
    read -p "State: " state
    time=$(date -u '+%H%M')
    echo "$frequency $time $call <$name $state>" >> $log_file
    echo "QSO Logged: $frequency $time $call <$name $state>"
  done

elif [ $method = "2" ]; then
  while true; do
    echo "-----"
    read -p "Frequency (MHz): " frequency
    read -p "Call: " call
    curl -sL https://api.hamdb.org/$call/json/clilog
    echo ""
    echo "-----"
    read -p "Name: " name
    read -p "State: " state
    time=$(date -u '+%H%M')
    echo "$frequency $time $call <$name $state>" >> $log_file
    echo "QSO Logged: $frequency $time $call <$name $state>"
  done

else
  echo "Try Again..."
fi
