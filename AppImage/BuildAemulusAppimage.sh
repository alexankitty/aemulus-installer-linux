#!/bin/sh
set -eux

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ARCH="$(uname -m)"
SHARUN="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/quick-sharun.sh"
APPIMAGETOOL="https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage"
URUNTIME="https://github.com/VHSgunzo/uruntime/releases/download/v0.5.7/uruntime-appimage-squashfs-lite-x86_64"

#Wine Prefix Dependencies
vcx64='https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x64.exe'
vcx86='https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x86.exe'
dotnet8="https://download.visualstudio.microsoft.com/download/pr/84ba33d4-4407-4572-9bfa-414d26e7c67c/bb81f8c9e6c9ee1ca547396f6e71b65f/windowsdesktop-runtime-8.0.2-win-x64.exe"
dotnet7="https://download.visualstudio.microsoft.com/download/pr/c81fc3af-c371-4bb5-a59d-fa3e852799c7/056ac9df87d92b75cc463cb106ef3b64/windowsdesktop-runtime-7.0.17-win-x64.exe"
wine_ver=$(wine --version)
wine_ver=$(echo ${wine_ver#*-} | awk '{print $1;}')
wine_ver=$(echo ${wine_ver%.*})

# Configure the AppImage
export ICON="$SCRIPT_DIR/aemulus-package-manager.png"
export DESKTOP="$SCRIPT_DIR/aemulus-package-manager.desktop"
export OUTPATH="$SCRIPT_DIR/dist"
export OUTNAME=Aemulus-"$ARCH".AppImage
export WINEPREFIX="$SCRIPT_DIR/AppDir/wineprefix"
export UPINFO="https://github.com/alexankitty/aemulus-installer-linux"
export ADD_HOOKS="vulkan-check.hook"
export VERSION="1.0.0"
export APPNAME="Aemulus Package Manager"
export RUNTIME_FILE="/tmp/uruntime"

# Install your application (example using pacman)
#sudo pacman -Sy --noconfirm base-devel wget wine xorg-server-xvfb zsync --needed

# Download and run quick-sharun
wget "$SHARUN" -O ./quick-sharun
wget "$APPIMAGETOOL" -O ./appimagetool
curl -Lso /tmp/uruntime "$URUNTIME"
chmod +x ./quick-sharun
chmod +x ./appimagetool

#Clear old shit
rm -rf "$SCRIPT_DIR/AppDir"

#setup AppDir structure
mkdir -p "$SCRIPT_DIR/AppDir/bin"
cp "$SCRIPT_DIR/Launch-Aemulus.sh" "$SCRIPT_DIR/AppDir/bin/Launch-Aemulus"
chmod +x "$SCRIPT_DIR/AppDir/bin/Launch-Aemulus"

#setup Prefix
mkdir $WINEPREFIX
wineboot -u
curl -o "/tmp/windowsdesktop-runtime-8.0.2-win-x64.exe" $dotnet8
curl -o "/tmp/windowsdesktop-runtime-7.0.17-win-x64.exe" $dotnet7
curl -o "/tmp/vcredist_x86.exe" $vcx86
curl -o "/tmp/vcredist_x64.exe" $vcx64
if [[ $wine_ver -lt 9 ]]
then
    winetricks -q dotnet48
    winetricks -q dotnet35
    winetricks -q win10
fi
wine "/tmp/windowsdesktop-runtime-8.0.2-win-x64.exe" /passive
wine "/tmp/windowsdesktop-runtime-7.0.17-win-x64.exe" /passive
wine "/tmp/vcredist_x86.exe" /passive
wine "/tmp/vcredist_x64.exe" /passive
rm "/tmp/vcredist_x86.exe" "/tmp/vcredist_x64.exe" "/tmp/windowsdesktop-runtime-8.0.2-win-x64.exe" "/tmp/windowsdesktop-runtime-7.0.17-win-x64.exe" 

# Bundle the application (point to Launch-Aemulus)
./quick-sharun ./AppDir/bin/Launch-Aemulus

# Create the AppImage
#./quick-sharun --make-appimage
#./appimagetool "$SCRIPT_DIR/AppDir" "$SCRIPT_DIR/dist/Aemulus-$(uname -m).AppImage"
mksquashfs $SCRIPT_DIR/AppDir "/tmp/aemulus-squashfs" -root-owned -noappend
cat /tmp/uruntime "/tmp/aemulus-squashfs" > "$SCRIPT_DIR/dist/Aemulus-$VERSION-$ARCH.AppImage"
chmod +x "$SCRIPT_DIR/dist/Aemulus-$VERSION-$ARCH.AppImage"
rm /tmp/aemulus-squashfs
rm /tmp/uruntime
