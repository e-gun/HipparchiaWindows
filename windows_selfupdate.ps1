Set-Alias git  'C:\Program Files\Git\bin\git.exe'

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
New-Variable -Name LEXDATA -Value $HIPPHOME\HipparchiaLexicalData
New-Variable -Name STATIC -Value $SERVERPATH\server\static
New-Variable -Name THEDB -Value hipparchiaDB

New-Variable -Name SERVERGIT -Value https://github.com/e-gun/HipparchiaServer.git
New-Variable -Name BUILDERGIT -Value https://github.com/e-gun/HipparchiaBuilder.git
New-Variable -Name LOADERGIT -Value https://github.com/e-gun/HipparchiaSQLoader.git
New-Variable -Name NIXGIT -Value https://github.com/e-gun/HipparchiaNIX.git
New-Variable -Name MACGIT -Value https://github.com/e-gun/HipparchiaMacOS.git
New-Variable -Name WINGIT -Value https://github.com/e-gun/HipparchiaWindows.git
New-Variable -Name THIRDPARTYGIT -Value https://github.com/e-gun/HipparchiaThirdPartySoftware.git
New-Variable -Name FONTGIT -Value https://github.com/e-gun/HipparchiaExtraFonts.git
New-Variable -Name LEXTGIT -Value https://github.com/e-gun/HipparchiaLexicalData.git

cd $SERVERPATH
git pull $SERVERGIT

cd $BUILDERPATH
git pull $BUILDERGIT

cd $LOADERPATH
git pull $LOADERGIT

cd $NIXPATH
git pull $NIXGIT

cd $MACPATH
git pull $MACGIT

cd $WINPATH
git pull $WINGIT

cd $THIRDPARTYPATH
git pull $THIRDPARTYGIT

cd $EXTRAFONTS
git pull $FONTGIT

cd $HIPPHOME
