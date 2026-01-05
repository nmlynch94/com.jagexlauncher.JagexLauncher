#!/bin/sh
set -e

winebin="/app/opt/wine/bin"
wineprefix="$XDG_DATA_HOME"/prefix
jagex_launcher_exe_path="$wineprefix/drive_c/Program Files (x86)/Jagex Launcher/JagexLauncher.exe"
# The umu_proton_dir and protonpath need to be different because umu_proton_dir is from the flatpak sandbox perspective, while protonpath is from the steam runtime perspective.
export UMU_PROTON_DIR="$HOME/.var/app/com.jagexlauncher.JagexLauncher/.local/share/umu/proton-eve-bundled/proton"
export PROTONPATH="$HOME/.local/share/umu/proton-eve-bundled/proton"
export WINEPREFIX="$wineprefix"

# This is an unfortunate hack needed because the /app dir is not mounted inside the steam runtime. The paths seen by umu-run is different than is seen by scripts in the steam runtime. Let me know if you have ideas on how to avoid this.
if [[ -f "$UMU_PROTON_DIR/proton" ]]; then
  LOCAL_SHA256="$(sha256sum $UMU_PROTON_DIR/proton | awk '{ print $1 }')"
  FLATPAK_SHA256="$(sha256sum /app/opt/proton/proton | awk '{ print $1 }')"

  if [[ "$LOCAL_SHA256" != "$FLATPAK_SHA256" ]]; then
    echo "$LOCAL_SHA256 does not match $FLATPAK_SHA256. Updating proton ge..."

    rm -rf "$UMU_PROTON_DIR"
    mkdir -p "$UMU_PROTON_DIR"
    cp -r /app/opt/proton/* "$UMU_PROTON_DIR/"
  else
    echo "$LOCAL_SHA256 DOES match $FLATPAK_SHA256. No proton ge update needed."
  fi
else
  mkdir -p "$UMU_PROTON_DIR"
  cp -r /app/opt/proton/* "$UMU_PROTON_DIR/"
fi

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
WINEDEBUG="-all" umu-run reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall\RuneLite Launcher_is1" /v "InstallLocation" /t REG_SZ /d "Z:\app" /f

# Make sure the registry has the installation location for hdos
WINEDEBUG="-all" umu-run reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall\HDOS Launcher_is1" /v "InstallLocation" /t REG_SZ /d "Z:\app" /f

umu-run "$jagex_launcher_exe_path"
