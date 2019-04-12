##GENERIC INSTALLATION OVERVIEW

1. Top of repository:

    https://github.com/e-gun

1. Description + Pictures of what you get/what `Hipparchia` can do: (scroll all the way down through the page…)

	https://github.com/e-gun/HipparchiaServer

1.  To actaully get started, first pick your OS:

	* https://github.com/e-gun/HipparchiaMacOS
	* https://github.com/e-gun/HipparchiaWindows
	* https://github.com/e-gun/HipparchiaBSD

1. Then you do what your OS install instructions say: 

	e.g: open Terminal.app and paste
	
	`curl https://raw.githubusercontent.com/e-gun/HipparchiaMacOS/master/automated_macOS_install.sh | /bin/bash`

    After watching a lot of messages fly by you will have the full framework. Its probably good news 
    if you see the following: `CONGRATULATIONS: You have installed the Hipparchia framework`

1. After you have installed the software framework, you need to load the data. 
    You either do what it says at

    **either**

	* https://github.com/e-gun/HipparchiaBuilder

    **or**

	* https://github.com/e-gun/HipparchiaSQLoader

    If you know somebody with a build, then you are interested in `HipparchiaSQLoader`.
    Your **reload** (via `reloadhipparchiaDBs.py`) the products of an 
    **extraction** (via `extracthipparchiaDBs.py`). 

    Otherwise you need to build the databases yourself via `HipparchiaBuilder`.
    You put the data in the right place and then run `makecorpora.py`. 
    For example if A ran `extracthipparchiaDBs.py` and then put the `sqldump` folder on a thumb drive, 
    B could move that folder from the drive into his/her `HipparchiaData` folder and then run 
    `reloadhipparchiaDBs.py`. 

1. Then you will have a working installation. Now it is time to use `HipparchiaServer`. You can `run.py` whenever you want. 
    Mac people even have a handy `launch_hipparchia.app` that can be clicked. 
    
    Once `HipparchiaServer` is running you launch a web browser and (by default) go to http://localhost:5000

    You can leave `HipparchiaServer` running forever, really: it only consumes an interesting 
    amount of computing resources when you execute queries. 


## Windows SPECIFIC INSTALLATION INFORMATION

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

![sample_screen](hipparchia_windows_screenshot.png)