#!/bin/sh
set -x
winebin="/app/opt/lutris-GE-Proton8-22-x86_64/bin"
wineprefix="$XDG_DATA_HOME"/prefix
runelite_location="$wineprefix/drive_c/Program Files (x86)/RuneLite"

#  First run setup
if [ ! -d "$wineprefix" ]; then
    WINEPREFIX="$wineprefix" "$winebin/wineboot"

    # Place metafile in the proper location
    mkdir -p "$wineprefix/drive_c/users/$(whoami)/AppData/Local/Jagex Launcher"
    cp /app/launcher-win.production.json "$wineprefix/drive_c/users/$(whoami)/AppData/Local/Jagex Launcher/"

    # Make sure the registry has the installation location for runelite.
    WINEPREFIX="$wineprefix" WINEDEBUG="-all" "$winebin/wine64" reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall\RuneLite Launcher_is1" /v "InstallLocation" /t REG_SZ /d "Z:\app" /f

    # Make sure the registry has the installation location for hdos
    WINEPREFIX="$wineprefix" WINEDEBUG="-all" "$winebin/wine64" reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall\HDOS Launcher_is1" /v "InstallLocation" /t REG_SZ /d "Z:\app" /f
fi

WINEPREFIX="$wineprefix" "$winebin/wine64" /app/JagexLauncher.exe
