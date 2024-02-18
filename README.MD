# Aemulus Script Installer for Windows
## Dependencies
```
curl
wine
winetricks
p7zip
unzip
desktop-file-utils
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

## Issues
Put in an issue in the repo with the output of the script and as much information as possible.

## Updating
If for some reason the URLs become out of date that the script uses for grabbing everything, you can change the download path variables under `#Download Paths`

## Uninstalling
`rm -rf ~/.aemulus`

