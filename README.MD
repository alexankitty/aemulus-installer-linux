# Aemulus Script Installer for Linux
This is also covered in [Persona 3 FES Modding Guide: Installing Aemulus on Linux](https://persona-3-fes-modding-guide.readthedocs.io/en/latest/linuxaemulussetup.html).  
Important note: Aemulus does not run under WINE version 6 or earlier. Current stable is 9.0, LTS distros ship 8.0 still. Please make sure you're running WINE ≥ 8.0 !
## Dependencies

### Arch and Steam Deck
```
curl
wine
winetricks
p7zip
unzip
desktop-file-utils
lib32-gnutls
lib32-gst-plugins-base
```
If you're on steamdeck you need to disable immutable fs temporarily!
```
sudo steamos-readonly disable
```
Install your dependencies with the following
```
sudo pacman -S curl wine winetricks p7zip unzip desktop-file-utils lib32-gnutls lib32-gst-plugins-base
```
If wine is "missing" from the repositories, open /etc/pacman.conf in your favorite editor and uncomment the two multilib (not multililb testing lines!) close to the endo f the file.  

Once done on steamdeck, re-enable immutable fs.
```
sudo steamos-readonly enable
```

### Debian and similar
```
curl
wine
winetricks
p7zip
unzip
desktop-file-utils
gnutls
```

Install
```
sudo apt install curl wine winetricks p7zip unzip desktop-file-utils gnutls
```

### Fedora
```
curl
wine
winetricks
p7zip
unzip
desktop-file-utils
gnutls
gnutls.i686
```
Install
```
sudo dnf install curl wine winetricks p7zip unzip desktop-file-utils gnutls gnutls.i686
```

Make sure you have these installed before trying to run the script otherwise you will run into issues.

## Installation
Make sure you have git installed if you want it super easy!  
```bash
git clone https://github.com/alexankitty/aemulus-installer-linux
cd aemulus-installer-linux
chmod +x ./AemulusSetup.sh
./AemulusSetup.sh
```
If wine mono pops up, you can either click install or cancel. It doesn't matter, the script will ensure it's removed later.

## Game specific instructions
# Persona 5 Royal (Switch)
For some unknown reason, Aemulus tries to pass a null file reference to the lib responsible for unpacking the CPKs for this game. 
You will need to unpack them by hand by downloading and extracting [CriFsV2Lib](https://github.com/Sewer56/CriFsV2Lib), and then running it under your wine Aemulus prefix with the following command:
```bash
cd ~/Path/To/CriFsLib.GUI
WINEPREFIX=~/.local/share/aemulus wine CriFsLib.GUI.exe
```
Followed by copying the extracted results to `~/.local/share/aemulus/drive_c/AemulusPackageManager/Original/Persona 5 Royal (Switch)`

## Issues
Put in an issue in the repo with the output of the script and as much information as possible.

## Updating
If for some reason the URLs become out of date that the script uses for grabbing everything, you can change the download path variables under `#Download Paths`

## Uninstalling
`rm -rf ~/.local/share/aemulus`

