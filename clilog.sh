#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Provide Log File Path as Arugment. Example: 20240403.txt"
  exit 1
fi

log_file=$1
continue="N"

## Functions
menu() {
  echo ""
  echo "----- MENU -----"
  echo "Choose an Option"
  echo "0) Initiate Log"
  echo "1) Contest - Run"
  echo "2) Contest - Search & Pounce"
  echo "3) View Log"
  echo "---------------"
  echo ""
  read -p "Selection: " method
}

lookup_call(){
  echo "Enter 'EXIT' to Return to Main Menu"

  read -p "Call: " call

  if [ ${call^^} = "EXIT" ]; then
    exec bash "$0" $log_file
  else
    curl -sL https://api.hamdb.org/$call/json/clilog
    echo ""
    read -p "Continue? (Y or N) " continue
  fi
}


## Begin Script
clear
menu

if [ $method = "1" ]; then

  if ! [ -f $log_file ]; then
    echo ""
    echo "ERROR - Log Not Initiated..."
    menu
  fi

  clear
  echo "----- RUN -----"
  read -p "Frequency (MHz): " frequency

  while true; do
    echo ""
    echo "-- QSO --"

    continue="N"

    while ! [ ${continue^^} = "Y" ]; do
      lookup_call
    done

    read -p "Name: " name
    read -p "State: " state
    read -p "Identifier: " identifier

    time=$(date -u '+%H%M')

    echo "$frequency $time $call <$name $state $identifier>" >> $log_file
    echo "QSO Logged: $frequency $time $call @$name <$name $state $identifier>"
  done

elif [ $method = "2" ]; then

  if ! [ -f $log_file ]; then
    echo ""
    echo "ERROR - Log Not Initiated..."
    menu
  fi

  clear
  echo "----- Search & Pounce -----"

  while true; do
    echo ""
    echo "-- QSO --"

    continue="N"

    while ! [ ${continue^^} = "Y" ]; do
      lookup_call
    done

    read -p "Frequency (MHz): " frequency
    read -p "Name: " name
    read -p "State: " state
    read -p "Identifier: " identifier

    time=$(date -u '+%H%M')

    echo "$frequency $time $call <$name $state $identifier>" >> $log_file
    echo "QSO Logged: $frequency $time $call @$name <$name $state $identifier>"
  done

elif [ $method = "3" ]; then
  clear
  echo "----- Log Entries -----"
  cat $log_file
  menu

elif [ $method = "0" ]; then

  if [ -f $log_file ]; then
    echo ""
    echo "ERROR - Log Already Initiated..."
    menu
  fi

  clear
  echo "----- Initiating Log -----"
  read -p "My Call: " my_call
  read -p "My Grid: " my_grid
  read -p "Mode: " mode
  date=$(date -u +'%Y-%m-%d')
  echo "# Header"          >> $log_file
  echo "mycall $my_call"   >> $log_file
  echo "mygrid $my_grid"   >> $log_file
  echo "operator $my_call" >> $log_file
  echo ""                  >> $log_file
  echo "# Log"             >> $log_file
  echo "date $date"        >> $log_file
  echo "$mode"             >> $log_file
  echo "Log Initiated:"
  cat $log_file

  menu  
else
  echo "Try Again..."
  menu
fi
