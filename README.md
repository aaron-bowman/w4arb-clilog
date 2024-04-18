# w4arb-clilog
Command line based logging that looks up call signs while logging, and writes Fast Log Entry (FLE) log text files. This is not a fancy logging app, it's just a way for me to log in the FLE format and perform call lookups at the same time without window switching. It's intended for distraction-free logging. Additionally, once the ADIF is exported it can be uploaded to QRZ if a ./tmp/qrz.key file is in place with your QRZ logbook API key.

## Features:
- Performs Callsign Lookups While Logging (HamDB, some DX may not be found)
- Stores Log in Fast Log Entry (FLE) Format for Easy Reading/Modification
- Export to ADIF File
- Upload to QRZ Directly via API

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
