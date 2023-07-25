#!/bin/sh
set -e

####################################################
#                    Configuration                 #
####################################################

jagex_launcher_url="https://cdn.jagex.com/Jagex%20Launcher%20Installer.exe"
winebin=/app/opt/lutris-GE-Proton8-12-x86_64/bin/wine64
workdir="$XDG_DATA_HOME/jagex-launcher"
wineprefix="$workdir/prefix"

####################################################
#               Variable Initialization           #
####################################################
first_run="false"

####################################################
#               Function Declarations             #
####################################################

# Function to install the jagex launcher
function install_launcher() {
    # Create wine prefix directory and launch the installer
    mkdir -p "$wineprefix"

    # Download the jagex launcher installer
    cd "$workdir" 
    wget -O jagex-launcher-installer.exe "$jagex_launcher_url"

    WINEPREFIX="$wineprefix" WINEDLLOVERRIDES="jscript.dll=n" "$winebin" "jagex-launcher-installer.exe" &

    # Grab the pid of the installer process
    installer_process="$!"

    above_200=0

    echo "Beginning installation..."

    while true 
    do
        echo "Checking directory size..."
        # Grab directory size for jagex launcher install directory. This is how we know when to kill the installer window.
        dir_size=$(((du -sh "${wineprefix}/drive_c/Program Files (x86)/Jagex Launcher" 2> /dev/null) || echo '0G') | awk '{ print $1 }')
        # Remove the last character from the dir_size so the units don't show
        dir_size=$(echo "$dir_size" | sed 's/.$//')

        # If the directory size is above 200M, then add one to the above_200 variable
        if (( $dir_size > 200 )); then
            above_200=$((above_200+1))
        fi

        # If the directory has been above 200M for two loops, then the installer should be done and we can kill the window.
        if (( $above_200 > 1 )); then
            kill "$installer_process"
            break # Exit the while loop
        fi
        sleep 10
    done;

    # Cleanup
    rm jagex-launcher-installer.exe
}

####################################################
#                 Main Script Logic                #
####################################################

# If the JagexLauncher executable exists, then first run setup is not needed
if [ ! -f "$XDG_DATA_HOME/jagex-launcher/prefix/drive_c/Program Files (x86)/Jagex Launcher/JagexLauncher.exe" ]; then
    echo "First Run!"
    first_run="true"
fi

if [ "$first_run" == "true" ]; then
    install_launcher
fi
WINEPREFIX="$XDG_DATA_HOME/jagex-launcher/prefix" "$winebin" "$wineprefix/drive_c/Program Files (x86)/Jagex Launcher/JagexLauncher.exe"
