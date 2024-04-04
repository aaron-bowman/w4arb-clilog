# w4arb-clilog
Command line ham radio logging for contests and such. Initially, I'm using this for SST and CWT mini contests. I'll add features, fields, etc. as needed for different contests.It also works for realtime logging POTA activations under "run". 
This is a very simple tool with one purpose; zero-distraction logging while operating unassisted. Feel free to copy, use, modify, etc. at will.

## Features:
- Performs Callsign Lookups While Logging (HamDB, some DX may not be found)
- Stores Log in Fast Log Entry (FLE) Format for Easy Reading/Modification
- Export to ADIF File

### Key Functions:
0) Initiate Log: Sets the fields for My Call, My Grid, and initial Band and Mode (can be changed later)
1) Run: Logs QSOs while "running" on a frequency. Sets frequency once at the beginning of the run.
2) Search & Pounce: Logs QSOs while "S&P"ing. Sets frequency for every QSO.
3) View Log: Shows a readable output of contacts in the log file.
4) Export ADIF: Uses FLEcli to export an ADIF file of all contacts in the log file.
5) Change Band/Mode: Changes band and mode for subsequent QSOs

## Useage
1. Copy this repo to a Linux machine (or probably Mac, but haven't tested that)
2. Run the script with the text file you want to write to as an argument. Example: `./clilog.sh YYYYMMDD_SST.txt`
3. Operate distraction-free and log your contacts
4. Export to ADIF and upload wherever you need to!
