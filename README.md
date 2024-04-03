# w4arb-clilog
Command line tool for logging. I made this for SST to start with, just for myself. It's not fancy, just a simple shell script for easy modification and portability. It spits out text for Fast Log Entry to generate ADIF files. This is just so I can have one terminal up during a contest and log all my contacts without any distraction. Feel free to copy and edit as desired.

## Features:
- Search and Pounce: Asks for Frequency every QSO
- Run: Only asks for Frequency once
- Call Lookup: When you enter a call, it performs a lookup in HamDB and prints the results in JSON. It's readable enough for me.

## Useage
1. Run the script, with the text file you want to write to as an argument
   Example : `./clilog.sh /home/abowman/20240405_SST.txt`
3. Log your contacts
4. Copy the text in the text file into Fast Log Entry to complete the log
