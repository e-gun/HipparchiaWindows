# Right-Click and 'run' this script

# Set-ExecutionPolicy RemoteSigned

New-Variable -Name HIPPHOME -Value ~\hipparchia_venv
New-Variable -Name SERVERPATH -Value $HIPPHOME\HipparchiaServer

cd $SERVERPATH
..\Scripts\activate
Start-Process python .\run.py
