#!/bin/sh
set -e
set -x

winebin="/app/opt/wine/bin"
wineprefix="$XDG_DATA_HOME"/prefix
jagex_launcher_exe_path="$wineprefix/drive_c/Program Files (x86)/Jagex Launcher/JagexLauncher.exe"

if ! [ -f "$jagex_launcher_exe_path" ]; then
    mkdir tmp
    cd tmp
    python3 /app/bin/jagex-install
    cd ..
    mkdir -p "$wineprefix/drive_c/Program Files (x86)/Jagex Launcher"
    cp -r ./tmp/* "$wineprefix/drive_c/Program Files (x86)/Jagex Launcher/"

    # Copy steam deck properties file to a location accessible by the flatpak
    cp /app/steamdeck-settings.properties "$XDG_DATA_HOME/steamdeck-settings.properties"
fi

# Make sure the registry has the installation location for runelite.
WINEPREFIX="$wineprefix" WINEDEBUG="-all" "$winebin/wine" reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall\RuneLite Launcher_is1" /v "InstallLocation" /t REG_SZ /d "Z:\app" /f

# Make sure the registry has the installation location for hdos
WINEPREFIX="$wineprefix" WINEDEBUG="-all" "$winebin/wine" reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall\HDOS Launcher_is1" /v "InstallLocation" /t REG_SZ /d "Z:\app" /f

# Run with overrides for dxvk
WINEPREFIX="$wineprefix" WINEDLLOVERRIDES="dxgi=b" "$winebin/wine" "$jagex_launcher_exe_path"