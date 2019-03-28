# wordcounts run out of memory w/ 6G RAM 

# you will need an admin powershell session to properly set the next...
# rightclick on powershell will allow you this option

Set-ExecutionPolicy RemoteSigned

# [install chocolatey]
# install python
# install git
# install 7z

# install postgresql  
#	for unicode postgres needs to have "no locale" set: i.e., C

$UNAME = [Environment]::UserName

Set-Alias python "C:\Users\$UNAME\AppData\Local\Programs\Python\Python3*\python.exe"
Set-Alias git  'C:\Program Files\Git\bin\git.exe'
Set-Alias psql 'C:\Program Files\PostgreSQL\*\bin\psql.exe'
Set-Alias 7z   'C:\Program Files\7-zip\7z.exe'

[Reflection.Assembly]::LoadWithPartialName("System.Web")
$PSPASS = [System.Web.Security.Membership]::GeneratePassword(12,3)

echo 'the following are required: 7z, git, postgresql, python'
echo 'this script will probe for each'
echo 'the full list of downloads is:'
echo ''
echo '[1] https://www.7-zip.org/download.html'
echo '[2] https://github.com/git-for-windows/git/releases/'
echo '[3] https://www.postgresql.org/download/windows/'
echo '[4] https://www.python.org/downloads/windows/'
echo ''
echo '[the git installer will ask you a lot of questions: pick the default answers and you will be fine]'
echo ''
echo '[the postgres installer will ask for a superuser password for the user "postgres"'
echo 'consider using the following random password:   " $PSPASS "]'
echo 'it is SUPER IMPORTANT that you chose "C" as the Locale when asked'
echo ''


Try { python --version }
Catch { 
	echo 'python not installed: download and install via "https://www.python.org/downloads/windows/"'
	Break
	}

Try { git --version }
Catch { 
	echo 'git not installed: download and install via "https://github.com/git-for-windows/git/releases/"'
	Break
	}

Try { 7z }
Catch { 
	echo '7z not installed: download and install via "https://www.7-zip.org/download.html"'
	Break
	}

Try { psql --version }
Catch { 
	echo 'postgresql not installed: download and install via "https://www.postgresql.org/download/windows/"'
	echo 'the Hipparchia installation script will ask you for the password for "postgres"'
	echo 'You will be asked to set that password when running the postgresql installer'
	echo 'consider using the following random password:   " $PSPASS "'
	Break
	}

	
New-Variable -Name HIPPHOME -Value ~\hipparchia_venv
New-Variable -Name SERVERPATH -Value $HIPPHOME\HipparchiaServer
New-Variable -Name BUILDERPATH -Value $HIPPHOME\HipparchiaBuilder
New-Variable -Name LOADERPATH -Value $HIPPHOME\HipparchiaSQLoader
New-Variable -Name BSDPATH -Value $HIPPHOME\HipparchiaBSD
New-Variable -Name MACPATH -Value $HIPPHOME\HipparchiaMacOS
New-Variable -Name WINPATH -Value $HIPPHOME\HipparchiaWindows
New-Variable -Name DATAPATH -Value $HIPPHOME\HipparchiaData
New-Variable -Name THIRDPARTYPATH -Value $HIPPHOME\HipparchiaThirdPartySoftware
New-Variable -Name EXTRAFONTS -Value $HIPPHOME\HipparchiaExtraFonts
New-Variable -Name SUPPORT -Value $THIRDPARTYPATH\minimal_installation
New-Variable -Name STATIC -Value $SERVERPATH\server\static
New-Variable -Name THEDB -Value hipparchiaDB

New-Variable -Name SERVERGIT -Value https://github.com/e-gun/HipparchiaServer.git
New-Variable -Name BUILDERGIT -Value https://github.com/e-gun/HipparchiaBuilder.git
New-Variable -Name LOADERGIT -Value https://github.com/e-gun/HipparchiaSQLoader.git
New-Variable -Name BSDGIT -Value https://github.com/e-gun/HipparchiaBSD.git
New-Variable -Name MACGIT -Value https://github.com/e-gun/HipparchiaMacOS.git
New-Variable -Name WINGIT -Value https://github.com/e-gun/HipparchiaWindows.git
New-Variable -Name THIRDPARTYGIT -Value https://github.com/e-gun/HipparchiaThirdPartySoftware.git
New-Variable -Name FONTGIT -Value https://github.com/e-gun/HipparchiaExtraFonts.git

ForEach ($dirname in $HIPPHOME, $SERVERPATH, $BUILDERPATH, $LOADERPATH, $BSDPATH, $MACPATH, $WINPATH, $DATAPATH, $THIRDPARTYPATH, $EXTRAFONTS) {
    mkdir $dirname
    }

cd $SERVERPATH
git init
git pull $SERVERGIT
cp -r $SERVERPATH\server\sample_settings $SERVERPATH\server\settings 

cd $BUILDERPATH
git init
git pull $BUILDERGIT
cp $BUILDERPATH\sample_config.ini $BUILDERPATH\config.ini

cd $LOADERPATH
git init
git pull $LOADERGIT
cp $LOADERPATH\sample_config.ini $LOADERPATH\config.ini

cd $BSDPATH
git init
git pull $BSDGIT

cd $MACPATH
git init
git pull $MACGIT

cd $WINPATH
git init
git pull $WINGIT
cp $WINPATH\launch_hipparchia_server.ps1 $HIPPHOME\
cp $WINPATH\windows_selfupdate.ps1 $HIPPHOME\

cd $FONTGIT
git init
git pull $EXTRAFONTS

cd $THIRDPARTYPATH
git init
git pull $THIRDPARTYGIT

cp $SUPPORT\jquery-3.3.1.min.js $STATIC\jquery.min.js
cp $SUPPORT\js.cookie.js $STATIC\js.cookie.js
cp $SUPPORT\jquery-ui-1.12.1.zip $STATIC\jquery-ui-1.12.1.zip
# 7z seems not to like to follow variable pathnames... so we 'cd'
cd $STATIC\
7z -aoa x .\jquery-ui-1.12.1.zip
rm $STATIC\query-ui-1.12.1.zip
mv $STATIC\query-ui-1.12.1\* $STATIC\
rmdir $STATIC\query-ui-1.12.1\

cp $SUPPORT\NotoMono-hinted.zip $STATIC\ttf\NotoMono-hinted.zip
cp $SUPPORT\NotoSans-unhinted.zip $STATIC\ttf\NotoSans-unhinted.zip
cp $SUPPORT\NotoSansDisplay-unhinted.zip $STATIC\ttf\NotoSansDisplay-unhinted.zip
cd $STATIC\ttf
7z -aoa x .\*.zip
rm $STATIC\ttf\*.zip

Add-Type -AssemblyName System.Web
$WRPASS = [System.Web.Security.Membership]::GeneratePassword(12,3)
$RDPASS = [System.Web.Security.Membership]::GeneratePassword(12,3)
$SKRKEY = [System.Web.Security.Membership]::GeneratePassword(24,6)

echo "the next several commands require you to enter the password for postgres (4x)"
C:\Program*Files\PostgreSQL\*\bin\createdb.exe -U postgres -E utf8 -l C $THEDB
# 'no such file or directory' if you do this via "$BUILDERPATH\builder\sql\generate_hipparchia_dbs.sql"
cd $BUILDERPATH\builder\sql
psql -U postgres -d $THEDB -a -f .\generate_hipparchia_dbs.sql
psql -U postgres -d $THEDB --command="ALTER ROLE hippa_wr WITH PASSWORD '$WRPASS';"
psql -U postgres -d $THEDB --command="ALTER ROLE hippa_rd WITH PASSWORD '$RDPASS';"

New-Variable -Name SONE -Value $SERVERPATH\server\settings\securitysettings.py
New-Variable -Name STWO -Value $BUILDERPATH\config.ini
New-Variable -Name STHREE -Value $LOADERPATH\config.ini

(Get-Content $SONE).replace('yourpassheretrytomakeitstrongplease', $RDPASS) | Set-Content $SONE
(Get-Content $SONE).replace('yourkeyhereitshouldbelongandlooklikecryptographicgobbledygook', $SKRKEY) | Set-Content $SONE
(Get-Content $STWO).replace('>>yourpasshere<<', $WRPASS) | Set-Content $STWO
(Get-Content $STHREE).replace('yourpasshere', $WRPASS) | Set-Content $STHREE

# tilde confuses us...
cd ~
python -m venv .\hipparchia_venv\
cd $HIPPHOME\Scripts\
.\activate
pip install flask psycopg2-binary websockets

# building...
# edit config.ini
