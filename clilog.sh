#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Provide Log File Path as Arugment. Example: 20240403.txt"
  exit 1
fi

log_file=$1
continue="N"

## Functions
menu() {
  if ! [ -f $log_file ]; then
   echo "NOTICE: Log File Not Yet Initiated!"
  fi

  echo ""
  echo "----- MENU -----"
  echo "Choose an Option"
  echo "0) Initiate Log"
  echo "1) Run"
  echo "2) Search & Pounce"
  echo "3) View Log"
  echo "4) Export ADIF File"
  echo "5) Change Band/Mode"
  echo "9) Exit"
  echo "---------------"
  read -p "Selection: " method
}

lookup_call(){
  echo "For Main Menu, Enter EXIT"
  echo ""
  
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
menu

if [ $method = "1" ]; then

  if ! [ -f $log_file ]; then
    exec bash "$0" $log_file
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
    exec bash "$0" $log_file
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
  ./FLEcli load $log_file
  exec bash "$0" $log_file

elif [ $method = "0" ]; then

  if [ -f $log_file ]; then
    echo ""
    echo "ERROR - Log Already Initiated..."
    exec bash "$0" $log_file
  fi

  clear
  echo "----- Initiating Log -----"
  read -p "My Call: " my_call
  read -p "My Grid: " my_grid
  read -p "My POTA (blank for none): " my_pota
  read -p "Mode: " mode
  read -p "Band (Format: 20M): " band
  date=$(date -u +'%Y-%m-%d')

  echo "# Header"          >> $log_file
  echo "mycall $my_call"   >> $log_file
  echo "mygrid $my_grid"   >> $log_file
  echo "operator $my_call" >> $log_file

  if ! [ $my_pota = "" ]; then
    echo "mypota $my_pota"   >> $log_file
  fi

  echo ""                  >> $log_file
  echo "# Log"             >> $log_file
  echo "date $date"        >> $log_file
  echo "$band $mode"       >> $log_file

  exec bash "$0" $log_file

elif [ $method = "4" ]; then
  ./FLEcli adif -i --overwrite $log_file $log_file".adi" 

  echo "File exported: $log_file'.adi' - Exiting..."
  exit 0

elif [ $method = "5" ]; then
  echo "----- Change Band/Mode -----"
  read -p "Band (Format: 20M): " band
  read -p "Mode: " mode
  echo ""            >> $log_file
  echo "$band $mode" >> $log_file
  exec bash "$0" $log_file

elif [ $method = "9" ]; then
  echo "Exiting..."
  exit 0

else
  clear
  echo "Invalid Selection..."
  exec bash "$0" $log_file
fi
