#!/bin/sh
set -e

####################################################
#                    Configuration                 #
####################################################

jagex_launcher_url="https://cdn.jagex.com/Jagex%20Launcher%20Installer.exe"

winebin="/app/opt/lutris-GE-Proton8-12-x86_64/bin/wine64"
wineexe="$winebin/wine"
workdir="$XDG_DATA_HOME/jagex-launcher"
wineprefix="$workdir/prefix"
clientdir="$wineprefix/drive_c/Program Files (x86)/Jagex Launcher/Games"

runelite_url="https://raw.githubusercontent.com/TormStorm/jagex-launcher-linux/main/resources/runelite.sh"
runelite_launch_script_url="https://raw.githubusercontent.com/TormStorm/jagex-launcher-linux/main/resources/runelite.sh"

####################################################
#               Function Declarations             #
####################################################

# Function to install the jagex launcher
function install_launcher() {
    # Place pre-created wine prefix so we don't run into errors related to mono or gecko
    mkdir -p "$wineprefix"
    cd "$workdir"
    wget -O prefix.tar.gz "https://public-bucket-caution1.s3.amazonaws.com/prefix.tar.gz"
    tar xf prefix.tar.gz -C "$wineprefix/../"
    
    # Download the jagex launcher installer
    wget -O jagex-launcher-installer.exe "$jagex_launcher_url"

    # Run wine installer
    WINEPREFIX="$wineprefix" WINEDLLOVERRIDES="jscript.dll=n" "$winebin" "jagex-launcher-installer.exe" &

    # Grab the pid of the installer process
    installer_process="$!"

    above_200=0

    echo "PID of install process is $installer_process. Beginning installation..."

    while true 
    do
        # Checking if installer is still running
        if ps -p $installer_process > /dev/null
        then
            echo "$installer_process is still running. Continuing to check directory..."
        else
            echo "$installer_process appears to have quit. Ending loop."
            break
        fi
        echo "Checking directory size..."
        # Grab directory size for jagex launcher install directory. This is how we know when to kill the installer window.
        dir_size=$(((du -sh "${wineprefix}/drive_c/Program Files (x86)/Jagex Launcher" 2> /dev/null) || echo '0G') | awk '{ print $1 }')
        # Remove the last character from the dir_size so the units don't show
        dir_size=$(echo "$dir_size" | sed 's/.$//')

        # If the directory size is above 200M, then add one to the above_200 variable
        if (( $dir_size > 200 )); then
            above_200=$((above_200+1))
        fi

        if (( $above_200 > 1 )); then
            echo "Installation complete. Killing $installer_process"
            kill "$installer_process"
            break # Exit the while loop
        fi

        sleep 10
    done;

    wait;
    # Install RuneLite
    mkdir -p "$clientdir/RuneLite"
    wget -O "$clientdir/RuneLite/RuneLite.AppImage" "$runelite_url"
    wget -O "$clientdir/RuneLite/runelite.sh" "$runelite_launch_script_url"
    ln -s "$clientdir/RuneLite/runelite.sh" "$clientdir/RuneLite/RuneLite.exe"
    chmod +x "$clientdir/RuneLite/runelite.sh"
    chmod +x "$clientdir/RuneLite/RuneLite.AppImage"
    cd "$wineprefix"/drive_c/windows/syswow64
    WINEPREFIX="$wineprefix" "$winebin" reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall\RuneLite Launcher_is1" /v "InstallLocation" /t REG_SZ /d "C:\Program Files (x86)\Jagex Launcher\Games\RuneLite"
    cd "$workdir"

    # Cleanup
    rm jagex-launcher-installer.exe
}

####################################################
#                 Main Script Logic                #
####################################################

# If the JagexLauncher executable exists, then first run setup is needed
if [ ! -f "$XDG_DATA_HOME/jagex-launcher/prefix/drive_c/Program Files (x86)/Jagex Launcher/JagexLauncher.exe" ]; then
    echo "First Run!"
    install_launcher
fi

# Run the jagex launcher
WINEPREFIX="$XDG_DATA_HOME/jagex-launcher/prefix" "$winebin" "$wineprefix/drive_c/Program Files (x86)/Jagex Launcher/JagexLauncher.exe"
