# HipparchiaWindows
files for installing Hipparchia on Windows

[in progress; but it works...]

users will need to pre-load several packages themselves:
1. [python](https://www.python.org/downloads/windows/)
1. [git](https://github.com/git-for-windows/git/releases/)
1. [7z](https://www.7-zip.org/download.html)
1. [postgresql](https://www.postgresql.org/download/windows/)

it is **critical** to choose `"C"` as the Locale when asked to by the
`postgresql` installer

you will need to pick a good, strong `password` for the user `postgres` 
when installing `postgresql`. You will enter this password 4x when 
running the installation script.

the software also needs to be installed into the proper 
folders (should default to them, though):

    python: "C:\Users\$UNAME\AppData\Local\Programs\Python\Python3*\python.exe"
    git:    'C:\Program Files (x86)\Git\bin\git.exe'
    7z:     'C:\Program Files\7-zip\7z.exe'
    psql:   'C:\Program Files\PostgreSQL\*\bin\psql.exe'
    
the installer script (`windows_installation_script.ps1`) needs 
`Set-ExecutionPolicy RemoteSigned`. In order to do that, you will 
need to set that policy via an `Administrator` shell.

**Building** entails `activate`-ing the `venv`. Edit `config.ini` 
as necessary and then...

    cd ~\hipparchia_venv\Scripts\
    .\activate
    cd ..\HipparchiaBuilder\
    python .\makecorpora.py
    
[**nb**: wordcounts build only in theory: they require >4GB of RAM and 
are untested on a Windows installation with that much memory. But installations
that do not have wordcounts work just fine.]