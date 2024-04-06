#!/bin/bash

#MIT License
#
#Copyright (c) 2022 Rawley Fowler
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

set -e

function usage() {
	echo "
INSTALL WARBAND SCRIPT EXTENDER ON LINUX

./install.sh [-p PATH_TO_WARBAND] [-l INSTALL_LOC]

Installs Warband Script Extender on Linux using Wine.

If you don't specify PATH_TO_WARBAND, then we look in
'$HOME/.local/share/Steam/steamapps/common/MountBlade\ Warband/'

If you don't specify INSTALL_LOC then we install in
'$HOME/Games/MountBlade\ Warband'

Requirements to run:
- wget
- Wine
- Winetricks
- Unrar
"
	exit 1
}

PATH_TO_WARBAND="$HOME/.local/share/Steam/steamapps/common/MountBlade Warband"
INSTALL_LOC="$HOME/Games/MountBlade Warband"

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -p|--path) PATH_TO_WARBAND="$2"; shift ;;
        -l|--location) INSTALL_LOC="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Location of WSE, we will wget this in a moment
WSE_DL="https://www.dropbox.com/scl/fi/j31x2uve0cjora2xtt3km/WSE-v4.9.5.rar?rlkey=orhskyf7ye997kuf0z9ja6tcc&dl=1"
WB_EXE_DL="https://www.dropbox.com/s/zfeoi54q1kr3xlk/mb_warband_1174.exe.rar"

[ ! -x "$(command -v wget)" ] && echo "You are missing wget, please install it." && exit 1
[ ! -x "$(command -v wine)" ] && echo "You are missing wine, please install it. and follow the README to setup the correct prefix." && exit 1
[ ! -x "$(command -v winetricks)" ] && echo "You are missing winetricks, please install it." && exit 1
[ ! -x "$(command -v unrar)" ] && echo "You are missing unrar, please install it." && exit 1

echo "Installing WSE + Warband to: $INSTALL_LOC"
echo "Sourcing Warband from $PATH_TO_WARBAND"
echo
echo "The following directories will be wiped to install warband: "
echo " $INSTALL_LOC  $HOME/.wine_warband"
read -p "Are you sure you want to continue? [YyNn]: " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	echo
	echo "Stopping installation."
	exit 0
fi

echo
echo "Creating custom run script."
echo "#!/bin/sh
WINEPREFIX=\"\$HOME/.wine_warband\" wine \"$INSTALL_LOC/WSELoader.exe\"
" > wse_warband
chmod +x wse_warband

echo
rm -r -- "$INSTALL_LOC" || true
mkdir -p "$INSTALL_LOC"
cd "$INSTALL_LOC"

echo "Creating creating a copy of Warband to perform the installation upon."
cp -r "$PATH_TO_WARBAND"/* .

echo "Downloading WSE and 1.1.74 Exe's"
wget -O "wse.rar" "$WSE_DL"
wget -O "wb_exe.rar" "$WB_EXE_DL"

echo "Unpacking WSE"
unrar x -o+ "wse.rar"
unrar x -o+ "wb_exe.rar"

echo "Setting up wine"
WINEARCH="win32" WINEPREFIX="$HOME/.wine_warband" winetricks d3dx9 d3dx9_42
WINEARCH="win32" WINEPREFIX="$HOME/.wine_warband" wine reg add "HKEY_CURRENT_USER\Software\Wine\Direct3D" /v MaxShaderModelVS /t REG_DWORD /d 0

echo "Cleaning up."
rm *.rar

GREEN='\033[0;32m'
NC='\033[0m'

printf "
${GREEN}Installation complete!${NC} Happy modding!\n
\n
Warband with WSE has been installed to: $INSTALL_LOC\n
\n
If you want to add this to your path, copy the 'wse_warband' script at the root of this project\n
to somewhere on your path to make it easily runnable.\n
\n
Ex: chmod +x ./wse_warband && sudo cp ./wse_warband /usr/bin/warband\n
\n
Then simply run in a terminal or via dmenu/rofi with 'warband'.\n
\n
If you just want to run warband, then run:\n
   WINEPREFIX=\"\$HOME/.wine_warband\" wine $INSTALL_LOC/WSELoader.exe\n
   or\n
   ./wse_warband (If you're in this directory)\n
"
