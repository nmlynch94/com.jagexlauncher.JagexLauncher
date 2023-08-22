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
installer_debug_log="$wineprefix/drive_c/users/nate/AppData/LocalLow/Jagex/Jagex Launcher/host.developer.log"
jagex_launcher_executable="$wineprefix/drive_c/Program Files (x86)/Jagex Launcher/JagexLauncher.exe"

runelite_url="https://github.com/runelite/launcher/releases/download/2.6.8/RuneLite.AppImage"
runelite_launch_script_url="https://raw.githubusercontent.com/nmlynch94/jagex-launcher-linux/main/resources/runelite.sh"

installer_retries=0
max_retries=5

####################################################
#               Function Declarations             #
####################################################

# Function to install the jagex launcher
function install_launcher() {
    echo "This is attempt number $installer_retries of $max_retries at installation"

    # Run jagex launcher installer in the background. The reason we do this is because the installer appears to freeze and cannot be closed
    # with the 'x' button. To get around this, we open it in the background and then monitor the destionation directory to know when it is
    # complete and then close the process.
    WINEPREFIX="$wineprefix" WINEDLLOVERRIDES="jscript.dll=n" WINEDEBUG="-all" "$winebin" "jagex-launcher-installer.exe" --debug &

    # Grab the pid of the installer process
    installer_process="$!"

    # Installation size is roughly 200MB. We wait two cycles while it is above 200 MB and then kill the process
    above_200=0

    echo "PID of install process is $installer_process. Beginning installation..."

    while [ "$installer_retries" -lt "$max_retries" ] 
    do
        date
        # Checking if installer is still running
        if ps -p $installer_process > /dev/null
        then
            echo "Installer PID: $installer_process is still running."
        else
            echo "Installer PID: $installer_process appears to have quit."

            # If the process has quit for some reason and the executable does not exist, then launch it again.
            if [ ! -f "$jagex_launcher_executable" ]; then
                echo "Installation has not successfully completed. Launching again."

                # Remove debug log
                rm "$installer_debug_log"
                installer_retries=$((installer_retries+1))
                install_launcher
                break
            fi
            break
        fi

        # The debug log for the installer does not create for a few seconds so we do this check to avoid breakages if a check
        # happens within the first few seconds of launch.
        if [ -f "$installer_debug_log" ]; then
            echo -n "Debug log exists. Checking for timeout..."
            
            # This timeout waiting for window to load message is an intermittent error that we get when launching the installers
            # it appears to be some sort of race condition because often launching the installer again fixes it.
            # If we detect it in the debug log, we quit the process and then try launching the installer again.
            timeout_message=$(grep -i 'Timeout waiting for window to load' "$installer_debug_log") || echo "Confirmed installer did not time out"

            if [ -n "$timeout_message" ]; then
                echo "The process has timed out. Killing installer and launching again."
                kill "$installer_process"

                # Remove debug log
                rm "$installer_debug_log"

                #Start the installation over
                installer_retries=$((installer_retries+1))
                install_launcher
                break
            fi
        fi

        echo -n "Checking directory size..."
        # Grab directory size for jagex launcher install directory. This is how we know when to kill the installer window.
        dir_size=$(((du -sh "${wineprefix}/drive_c/Program Files (x86)/Jagex Launcher" 2> /dev/null) || echo '0G') | awk '{ print $1 }')
        # Remove the last character from the dir_size so the units don't show
        dir_size=$(echo "$dir_size" | sed 's/.$//')
        echo "$dir_size"MB

        # If the directory size is above 200M, then add one to the above_200 variable
        if (( $dir_size > 200 )); then
            above_200=$((above_200+1))
        fi

        if (( $above_200 > 1 )); then
            echo "Installation complete. Killing $installer_process"
            kill "$installer_process"
            break # Exit the while loop
        fi

        echo ""
        sleep 5
    done;

    wait;

    # This is here in case we hit the max retries and don't complete successfully
    if [ ! -f "$jagex_launcher_executable" ]; then
        echo "Installation has not successfully completed. Exiting."
        exit 1
    fi

    # Install RuneLite
    # Grab the RuneLite AppImage, then symlink it with RuneLite.exe
    # We also edit the registry location that the launcher uses to locate the RuneLite.exe executable
    # This is so runelite.sh will be called when the user presses play.
    mkdir -p "$clientdir/RuneLite"
    wget -O "$clientdir/RuneLite/RuneLite.AppImage" "$runelite_url"
    wget -O "$clientdir/RuneLite/runelite.sh" "$runelite_launch_script_url"
    ln -s "$clientdir/RuneLite/runelite.sh" "$clientdir/RuneLite/RuneLite.exe"
    chmod +x "$clientdir/RuneLite/runelite.sh"
    chmod +x "$clientdir/RuneLite/RuneLite.AppImage"
    cd "$wineprefix"/drive_c/windows/syswow64
    cd "$workdir"

    # Cleanup
    rm jagex-launcher-installer.exe
}

####################################################
#                 Main Script Logic                #
####################################################

# If the JagexLauncher executable exists, then first run setup is needed. Otherwise skip and just run the jagex launcher executable.
if [ ! -f "$jagex_launcher_executable" ]; then
    echo "First Run!"

    mkdir -p "$wineprefix"
    cd "$workdir"
    
    # Download the jagex launcher installer
    wget -O jagex-launcher-installer.exe "$jagex_launcher_url"

    install_launcher
fi

# Make sure the registry has the installation location for runelite.
WINEPREFIX="$wineprefix" WINEDEBUG="-all" "$winebin" reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall\RuneLite Launcher_is1" /v "InstallLocation" /t REG_SZ /d "C:\Program Files (x86)\Jagex Launcher\Games\RuneLite" /f

# Run the jagex launcher
WINEPREFIX="$wineprefix" WINEDEBUG="-all" "$winebin" "$jagex_launcher_executable" --window --debug