# Aemulus Script Installer for Linux
This is also covered in [Persona 3 FES Modding Guide: Installing Aemulus on Linux](https://persona-3-fes-modding-guide.readthedocs.io/en/latest/linuxaemulussetup.html).
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
```sh
git clone https://github.com/alexankitty/aemulus-installer-linux
cd aemulus-installer-linux
chmod +x ./AemulusSetup.sh
./AemulusSetup.sh
```
If wine mono pops up, you can either click install or cancel. It doesn't matter, the script will ensure it's removed later.

## Issues
Put in an issue in the repo with the output of the script and as much information as possible.

## Updating
If for some reason the URLs become out of date that the script uses for grabbing everything, you can change the download path variables under `#Download Paths`

## Uninstalling
`rm -rf ~/.local/share/aemulus`

