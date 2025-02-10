#!/bin/sh
#Environment
WINEDLLOVERRIDES="mscoree=d;mshtml=d"
export WINEPREFIX=$HOME/.local/share/aemulus
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ICON_PATH=~/.local/share/icons/hicolor/256x256/apps/
EXEC_LINE="Exec=env WINEPREFIX=$WINEPREFIX "
EXEC_LINE+="DOTNET_ROOT= $HOME/.local/share/wine.AppImage wine "
EXEC_LINE+='C:\\\\\\\\AemulusPackageManager\\\\\\\\AemulusPackageManager.exe %u'
PATH_LINE="Path=${WINEPREFIX}/drive_c/AemulusPackageManager"
DESKTOP_PATH="$HOME/.local/share/applications"
alias wine='$HOME/.local/share/wine.AppImage wine'
alias winetricks='$HOME/.local/share/wine.AppImage winetricks'
alias wineboot='$HOME/.local/share/wine.AppImage wineboot'

#Download Paths
vcx64='https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x64.exe'
vcx86='https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x86.exe'
version=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/TekkaGB/AemulusModManager/releases/latest)
version=${version##*/}
wineimage=$(curl -sL https://api.github.com/repos/mmtrt/WINE_AppImage/releases/tags/continuous-staging | jq -r ".assets[].browser_download_url" | grep AppImage | head -1)
aemulus="https://github.com/TekkaGB/AemulusModManager/releases/latest/download/AemulusPackageManagerv${version}.7z"
dotnet8="https://download.visualstudio.microsoft.com/download/pr/84ba33d4-4407-4572-9bfa-414d26e7c67c/bb81f8c9e6c9ee1ca547396f6e71b65f/windowsdesktop-runtime-8.0.2-win-x64.exe"
dotnet7="https://download.visualstudio.microsoft.com/download/pr/c81fc3af-c371-4bb5-a59d-fa3e852799c7/056ac9df87d92b75cc463cb106ef3b64/windowsdesktop-runtime-7.0.17-win-x64.exe"

if [ ! -f $HOME/.local/share/wine.AppImage ]; then
    curl -o $HOME/.local/share/wine.AppImage -L $wineimage
    chmod +x $HOME/.local/share/wine.AppImage
fi
wine_ver=$(wine --version)
wine_ver=$(echo ${wine_ver#*-} | awk '{print $1;}')
wine_ver=$(echo ${wine_ver%.*})
#setup Prefix
wineboot
cd $SCRIPT_DIR
curl -o /tmp/windowsdesktop-runtime-8.0.2-win-x64.exe $dotnet8
curl -o /tmp/windowsdesktop-runtime-7.0.17-win-x64.exe $dotnet7
curl -o /tmp/vcredist_x86.exe $vcx86
curl -o /tmp/vcredist_x64.exe $vcx64
if [[ $wine_ver -lt 9 ]]
then
    winetricks -q dotnet48
    winetricks -q dotnet35
    winetricks -q win10
fi
wine /tmp/windowsdesktop-runtime-8.0.2-win-x64.exe /passive
wine /tmp/windowsdesktop-runtime-7.0.17-win-x64.exe /passive
wine /tmp/vcredist_x86.exe /passive
wine /tmp/vcredist_x64.exe /passive
rm /tmp/vcredist_x86.exe /tmp/vcredist_x64.exe /tmp/windowsdesktop-runtime-8.0.2-win-x64.exe /tmp/windowsdesktop-runtime-7.0.17-win-x64.exe
curl -Lso /tmp/AemulusPackageManager.7z $aemulus
7z x /tmp/AemulusPackageManager.7z -o"${WINEPREFIX}/drive_c/"
rm /tmp/AemulusPackageManager.7z
mv "${WINEPREFIX}/drive_c/AemulusPackageManagerv${version}" "${WINEPREFIX}/drive_c/AemulusPackageManager"

#Setup desktop icon
cp $SCRIPT_DIR/AemulusPackageManager.png $ICON_PATH/AemulusPackageManager.png
sed -i "s|^Exec=.*|$EXEC_LINE|" $SCRIPT_DIR/AemulusPackageManager.desktop
sed -i "s|^Path=.*|$PATH_LINE|" $SCRIPT_DIR/AemulusPackageManager.desktop

desktop-file-install --dir=$DESKTOP_PATH $SCRIPT_DIR/AemulusPackageManager.desktop
update-desktop-database $DESKTOP_PATH
