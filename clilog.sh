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
  echo "----- CLI Log by W4ARB -----"
  if ! [ -f $log_file ]; then
    echo "NOTICE: Log File Not Yet Initiated!"
  else
    echo "Current Log File: " $log_file
  fi

  echo ""
  echo "----- MENU -----"
  echo "Choose an Option"
  echo "0) Initiate Log"
  echo "1) Run"
  echo "2) Search & Pounce"
  echo "3) View Log"
  echo "4) Change Band/Mode"
  echo "5) Export ADIF File"
  echo "6) Upload ADIF to QRZ"
  echo "EXIT) Exit"
  echo "---------------"
  read -p "Selection: " method

  if [ ${method^^} = "EXIT" ]; then
    echo "Exiting..."
    exit 0
  fi
}

lookup_call(){
  echo "Enter EXIT to Cancel Entry"
  read -p "Call: " call

  if [ ${call^^} = "EXIT" ]; then
    exec bash "$0" $log_file
  else
    curl -sL https://api.hamdb.org/$call/json/clilog | jq '["Call:", "First Name:", "Last Name:", "City:", "State:", "Country:"], [.hamdb.callsign.call, .hamdb.callsign.fname, .hamdb.callsign.name, .hamdb.callsign.addr2, .hamdb.callsign.state, .hamdb.callsign.country] | @csv' | sed 's/\\//g' | sed 's/"//g' | column -t -s, -o"    "
    echo ""
  fi
}

## Begin Script
menu

# Run
if [ $method = "1" ]; then
  if ! [ -f $log_file ]; then
    exec bash "$0" $log_file
  fi

  echo ""
  echo "----- RUN -----"
  read -p "Frequency (MHz): " frequency

  while true; do
    echo ""
    echo "-- QSO --"

    lookup_call

    read -p "Comments: " comments
    if [ ${comments^^} = "EXIT" ]; then
      continue
    fi

    time=$(date -u '+%H%M')

    echo "$frequency $time $call <$comments>" >> $log_file
    ./FLEcli load $log_file
  done

# Search & Pounce
elif [ $method = "2" ]; then
  if ! [ -f $log_file ]; then
    exec bash "$0" $log_file
  fi

  echo ""
  echo "----- Search & Pounce -----"

  while true; do
    echo ""
    echo "-- QSO --"

    lookup_call

    read -p "Frequency (MHz): " frequency
    if [ ${frequency^^} = "EXIT" ]; then
      continue
    fi

    read -p "Comments: " comments
    if [ ${comments^^} = "EXIT" ]; then
      continue
    fi

    time=$(date -u '+%H%M')

    echo "$frequency $time $call <$comments>" >> $log_file
    ./FLEcli load $log_file
  done

# View Log
elif [ $method = "3" ]; then
  echo ""
  echo "----- Log Entries -----"
  ./FLEcli load $log_file
  exec bash "$0" $log_file

# Initiate Log File
elif [ $method = "0" ]; then
  if [ -f $log_file ]; then
    echo ""
    echo "ERROR - Log Already Initiated..."
    exec bash "$0" $log_file
  fi

  echo ""
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

  if [[ -n "$my_pota" ]]; then
    echo "mypota $my_pota"   >> $log_file
  fi

  echo ""                  >> $log_file
  echo "# Log"             >> $log_file
  echo "date $date"        >> $log_file
  echo "$band $mode"       >> $log_file

  exec bash "$0" $log_file

# Export ADIF
elif [ $method = "5" ]; then
  ./FLEcli adif -i --overwrite $log_file $log_file".adi" 
  echo "File exported: $log_file'.adi'"
  exec bash "$0" $log_file

# Change Band/Mode
elif [ $method = "4" ]; then
  echo ""
  echo "----- Change Band/Mode -----"
  read -p "Band (Format: 20M): " band
  read -p "Mode: " mode
  echo ""            >> $log_file
  echo "$band $mode" >> $log_file
  exec bash "$0" $log_file

# Upload to QRZ
elif [ $method = "6" ]; then
  echo ""
  echo "----- Upload to QRZ -----"

  if ! [ -f $log_file".adi" ]; then
    echo "Log Must be Exported to ADIF First"
    exec bash "$0" $log_file
  fi

  if ! [ -f tmp/qrz.key ]; then
    echo "tmp/qrz.key File Missing"
    exec bash "$0" $log_file
  fi

  qrz_key=`cat tmp/qrz.key`
  cat $log_file".adi" | grep 'STATION_CALLSIGN' | while read line; do qso=`echo $line | sed 's/ /%20/g'` && curl -d "KEY=$qrz_key&ACTION=INSERT&ADIF=$qso" -X POST https://logbook.qrz.com/api && echo ""; done

  echo ""
  echo "QRZ Upload Process Complete, Review Results Above"

  exec bash "$0" $log_file

# Invalid
else
  echo "Invalid Selection..."
  exec bash "$0" $log_file
fi
