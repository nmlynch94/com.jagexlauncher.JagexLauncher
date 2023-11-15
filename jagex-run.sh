#!/bin/sh
set -e
winebin="/app/opt/lutris-GE-Proton8-22-x86_64/bin"
wineprefix="$XDG_DATA_HOME"/prefix

WINEPREFIX="$wineprefix" "$winebin/wineboot"

mkdir -p "$wineprefix/drive_c/users/nate/AppData/Local/Jagex Launcher"
cp /app/launcher-win.production.json "$wineprefix/drive_c/users/nate/AppData/Local/Jagex Launcher/"

WINEPREFIX="$wineprefix" "$winebin/wine64" /app/JagexLauncher.exe