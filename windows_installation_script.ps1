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
echo 'if you have not already chosen one, consider using the following random password:   " $PSPASS "]'
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
New-Variable -Name NIXPATH -Value $HIPPHOME\HipparchiaNIX
New-Variable -Name MACPATH -Value $HIPPHOME\HipparchiaMacOS
New-Variable -Name WINPATH -Value $HIPPHOME\HipparchiaWindows
New-Variable -Name DATAPATH -Value $HIPPHOME\HipparchiaData
New-Variable -Name THIRDPARTYPATH -Value $HIPPHOME\HipparchiaThirdPartySoftware
New-Variable -Name EXTRAFONTS -Value $HIPPHOME\HipparchiaExtraFonts
New-Variable -Name SUPPORT -Value $THIRDPARTYPATH\minimal_installation
New-Variable -Name STATIC -Value $SERVERPATH\server\static
New-Variable -Name THEDB -Value hipparchiaDB
New-Variable -Name LEXDATAPATH -Value $HIPPHOME\HipparchiaLexicalData

New-Variable -Name SERVERGIT -Value https://github.com/e-gun/HipparchiaServer
New-Variable -Name BUILDERGIT -Value https://github.com/e-gun/HipparchiaBuilder
New-Variable -Name LOADERGIT -Value https://github.com/e-gun/HipparchiaSQLoader
New-Variable -Name BSDGIT -Value https://github.com/e-gun/HipparchiaNIX
New-Variable -Name MACGIT -Value https://github.com/e-gun/HipparchiaMacOS
New-Variable -Name WINGIT -Value https://github.com/e-gun/HipparchiaWindows
New-Variable -Name THIRDPARTYGIT -Value https://github.com/e-gun/HipparchiaThirdPartySoftware
New-Variable -Name FONTGIT -Value https://github.com/e-gun/HipparchiaExtraFonts.
New-Variable -Name LEXGIT -Value $SERVERPATH\HipparchiaLexicalData
New-Variable -Name LEXTGIT -Value https://github.com/e-gun/HipparchiaLexicalData

ForEach ($dirname in $HIPPHOME, $SERVERPATH, $BUILDERPATH, $LOADERPATH, $NIXPATH, $MACPATH, $WINPATH, $DATAPATH, $THIRDPARTYPATH, $EXTRAFONTS, $LEXDATAPATH) {
    mkdir $dirname
    }

cd $HIPPHOME
git clone $SERVERGIT
cp -r $SERVERPATH\server\sample_settings $SERVERPATH\server\settings 

git clone $BUILDERGIT
cp $BUILDERPATH\sample_config.ini $BUILDERPATH\config.ini

git clone $LOADERGIT
cp $LOADERPATH\sample_config.ini $LOADERPATH\config.ini

git clone $BSDGIT
git clone $MACGIT

git clone $WINGIT
cp $WINPATH\launch_hipparchia_server.ps1 $HIPPHOME\
cp $WINPATH\windows_selfupdate.ps1 $HIPPHOME\

git clone $FONTGIT

git clone $THIRDPARTYGIT
git clone $LEXGIT

cp $SUPPORT\jquery-3.6.0.min.js $STATIC\jquery.min.js
cp $SUPPORT\js.cookie.js $STATIC\js.cookie.js
cp $SUPPORT\jquery-ui-1.12.1.zip $STATIC\jquery-ui-1.12.1.zip
# 7z seems not to like to follow variable pathnames... so we 'cd'
cd $STATIC\
7z -aoa x .\jquery-ui-1.12.1.zip
rm $STATIC\jquery-ui-1.12.1.zip
mv $STATIC\jquery-ui-1.12.1\* $STATIC\
rmdir $STATIC\jquery-ui-1.12.1\

cp $SUPPORT\NotoMono-hinted.zip $STATIC\ttf\NotoMono-hinted.zip
cp $SUPPORT\NotoSans-unhinted.zip $STATIC\ttf\NotoSans-unhinted.zip
cp $SUPPORT\NotoSansDisplay-unhinted.zip $STATIC\ttf\NotoSansDisplay-unhinted.zip
cd $STATIC\ttf
7z -aoa x .\*.zip
rm $STATIC\ttf\*.zip

mkdir $DATAPATH\lexica\
cd $DATAPATH\lexica\
cp $LEXDATAPATH\*.gz $DATAPATH\lexica\
7z -aoa x $DATAPATH\lexica\*.gz

# the next can generate passwords with '%' in them; configparser will choke on '%' (which needs to be escaped as '%%')
# this is a problem if hippa_wr gets a bad password: build/reload will fail

Add-Type -AssemblyName System.Web
$WRPASS = [System.Web.Security.Membership]::GeneratePassword(12,3)
$RDPASS = [System.Web.Security.Membership]::GeneratePassword(12,3)
$SKRKEY = [System.Web.Security.Membership]::GeneratePassword(24,6)
$RUPASS = [System.Web.Security.Membership]::GeneratePassword(12,3)

$WRPASS = $WRPASS -Replace '%#]?+'
$RDPASS = $RDPASS -Replace '%#]?+'

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
(Get-Content $STWO).replace('loadwordcountsviasql = y', 'loadwordcountsviasql = n') | Set-Content $STWO
(Get-Content $STHREE).replace('yourpasshere', $WRPASS) | Set-Content $STHREE
(Get-Content $SONE).replace('yourremoteuserpassheretrytomakeitstrongplease', $RDPASS) | Set-Content $SONE

# tilde confuses us...
cd ~
python -m venv .\hipparchia_venv\
cd $HIPPHOME\Scripts\
.\activate
pip install flask psycopg2-binary websockets flask_wtf flask_login

# building...
# edit config.ini
