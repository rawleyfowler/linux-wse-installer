# Linux WSE Installer
To many people's suprise, Mount and Blade Warband with [WSE](https://forums.taleworlds.com/index.php?threads/wb-warband-script-enhancer-v4-8-5-for-1-174.324890/) on Linux actually runs really well!
There is very little information out there on how to run it, so I created this script
to streamline the process for people (and for myself since I distro hop quite often).

*Note*: This uses Wine, unfortunately WSE is compiled for Windows, so we can't natively install it.

## Prerequisites
You need the following installed:
```
unrar wget wine winetricks 
```

## How it works
We make a copy of your clean Mount and Blade Warband install, grab all of the WSE stuff
we need from the internet, then simply merge the two and generate an exectuable script for you to run.
The script generated is named `wse_warband` and can be moved anywhere, the best place for it
though, is probably somewhere on your `$PATH` but i'll leave that up to you!


## Installations
#### How to install with Steam
1. Purchase Mount and Blade Warband
2. Open your Steam library
3. Right click Mount and Blade Warband
4. Click properties
5. Click compatability
6. Check "Force the use of a specific Steam Play compatability tool"
7. Select "Proton Experimental"
8. Install Mount and Blade Warband

Once that is finished do the following in a Bash terminal.
```bash
git clone https://github.com/rawleyfowler/linux-wse-installer
cd linux-wse-installer
nano README.md # Make sure you read the whole thing before you install
./install.sh
sudo cp wse_warband /usr/local/bin/ # Optional if you want it on the path.
```

#### How to install without Steam
You'll need to find a copy of Mount and Blade Warband Windows edition, and
install it to a directory on your Linux machine. Then you'll have to use the script a little
differently to install it.
```bash
git clone https://github.com/rawleyfowler/linux-wse-installer
cd linux-wse-installer
nano README.md # Make sure you read the whole thing before you install
./install.sh -p "/location/of/warband" # Make sure you specify where you have the game!
sudo cp wse_warband /usr/local/bin/ # Optional if you want it on the path.
```

## Installing Mods
Simply `unzip`, `unrar`, etc any module as you would normally on Windows, and move it to the `Modules` folder
of your WSE Warband install.


## Debugging/Changing Install

#### My Screen Is Black
Make sure you have the correct video drivers installed for your card, and ensure that you run Warband
with the run script generated by the installer.

#### Changing Warband Lookup Directory
The installer looks for Mount and Blade Warband at: `$HOME/.local/share/Steam/steamapps/common/MountBlade\ Warband` if
it's installed somewhere else, or you don't use Steam, you can specify it on the install script with the `-p` flag:
```bash
./install.sh -p "$HOME/my/warband/install/directory"
```

#### Changing the Warband Install Directory
By default the installer installs to `$HOME/Games/MountBlade\ Warband` if you want to install
somewhere else use the `-l` flag.
```bash
./install.sh -l "$HOME/where/I/keep/my/vidya_games"
```

## License
This project is licensed under the MIT license, feel free to read about it in the `LICENSE` file at the root of the project.
