#!/bin/bash
INSTALLER_URL="https://cdn.jagex.com/Jagex%20Launcher%20Installer.exe"
FILE_LIST_URL="$BASE_URL/launcherinfo.json"
JAGEX_EXE_NAME="JagexLauncherInstaller.exe"

curl -L "$INSTALLER_URL" > "$JAGEX_EXE_NAME"

wrestool -x --output=icon.ico -t14 "$JAGEX_EXE_NAME"
convert icon.ico 256.png
mkdir -p 256
mv 256-0.png 256/256.png

# Cleanup
rm -f "icon.ico"
rm -f "256-*"
rm -f "$JAGEX_EXE_NAME"
