#!/bin/sh
set -euo pipefail

winebin="/app/opt/wine/bin"
wineprefix="$XDG_DATA_HOME"/umu_prefix
JAGEX_LAUNCHER_EXE_PATH="$wineprefix/drive_c/Program Files (x86)/Jagex Launcher/JagexLauncher.exe"
JAGEX_LAUNCHER_GAMES_PATH="$(dirname "$JAGEX_LAUNCHER_EXE_PATH")/Games"
# The umu_proton_dir and protonpath need to be different because umu_proton_dir is from the flatpak sandbox perspective, while protonpath is from the steam runtime perspective.
export UMU_PROTON_DIR="$HOME/.var/app/com.jagexlauncher.JagexLauncher/.local/share/umu/proton-bundled/proton"
export PROTONPATH="$HOME/.local/share/umu/proton-bundled/proton"
export WINEPREFIX="$wineprefix"

function ensure_latest_file () {
  SOURCE_FILE_PATH="$1"
  DEST_FILE_PATH="$2"

  echo "ensuring $SOURCE_FILE_PATH matches $DEST_FILE_PATH"
  if [[ -f "$DEST_FILE_PATH" ]]; then
    SOURCE_SHA256="$(sha256sum "$SOURCE_FILE_PATH" | awk '{ print $1 }')"
    DEST_SHA256="$(sha256sum "$DEST_FILE_PATH" | awk '{ print $1 }')"

    if [[ "$SOURCE_SHA256" != "$DEST_SHA256" ]]; then
      echo "$SOURCE_SHA256 does not match $DEST_SHA256. Updating $DEST_FILE_PATH..."

      mkdir -p "$(dirname "$DEST_FILE_PATH")"
      cp -r "$SOURCE_FILE_PATH" "$DEST_FILE_PATH"
    else
      echo "$SOURCE_SHA256 DOES match $DEST_SHA256. No update needed."
    fi

  else
      echo "$DEST_FILE_PATH does not exist. Copying..."
      mkdir -p "$(dirname "$DEST_FILE_PATH")"
      cp -r "$SOURCE_FILE_PATH" "$DEST_FILE_PATH"
  fi
}

function ensure_latest_dir () {
  SOURCE_FILE_PATH="$1"
  DEST_FILE_PATH="$2"

  echo "ensuring $SOURCE_FILE_PATH matches $DEST_FILE_PATH"
  if [[ -f "$DEST_FILE_PATH" ]]; then
    SOURCE_SHA256="$(sha256sum "$SOURCE_FILE_PATH" | awk '{ print $1 }')"
    DEST_SHA256="$(sha256sum "$DEST_FILE_PATH" | awk '{ print $1 }')"

    if [[ "$SOURCE_SHA256" != "$DEST_SHA256" ]]; then
      echo "$SOURCE_SHA256 does not match $DEST_SHA256. Updating $DEST_FILE_PATH..."

      mkdir -p "$(dirname "$DEST_FILE_PATH")"
      rm -r "$(dirname "$DEST_FILE_PATH")"
      cp -r "$(dirname "$SOURCE_FILE_PATH")" "$(dirname "$DEST_FILE_PATH")"
    else
      echo "$SOURCE_SHA256 DOES match $DEST_SHA256. No update needed."
    fi

  else
      echo "$DEST_FILE_PATH does not exist. Copying..."
      mkdir -p "$(dirname "$DEST_FILE_PATH")"
      rm -r "$(dirname "$DEST_FILE_PATH")"
      cp -r "$(dirname "$SOURCE_FILE_PATH")" "$(dirname "$DEST_FILE_PATH")"
  fi
}

ensure_latest_dir "/app/opt/proton" "$HOME/.local/share/umu/proton-bundled/proton"

# If we are still using wine-ge, migrate to umu proton
if [[ -z "$XDG_DATA_HOME/prefix" ]]; then

  echo "We are still on wine-ge. Migrating to proton..."
  umu-run wineboot -u
  mkdir -p "$WINEPREFIX/umu_prefix/drive_c/Program Files (x86)/Jagex Launcher"
  cp -r "$XDG_DATA_HOME/prefix/drive_c/Program Files (x86)/Jagex Launcher" "$WINEPREFIX/drive_c/Program Files (x86)/Jagex Launcher" || exit 1
  mv "$XDG_DATA_HOME/prefix" "$XDG_DATA_HOME/prefix.bk"

fi

if ! [ -f "$JAGEX_LAUNCHER_EXE_PATH" ]; then
    mkdir tmp
    cd tmp
    python3 /app/bin/jagex-install
    cd ..
    mkdir -p "$wineprefix/drive_c/Program Files (x86)/Jagex Launcher"
    cp -r ./tmp/* "$wineprefix/drive_c/Program Files (x86)/Jagex Launcher/"

    # Copy steam deck properties file to a location accessible by the flatpak
    cp /app/steamdeck-settings.properties "$XDG_DATA_HOME/steamdeck-settings.properties"
fi

ensure_latest_file "/app/RuneLite.exe" "$JAGEX_LAUNCHER_GAMES_PATH/RuneLite.exe"
ensure_latest_file "/app/HDOS.exe" "$JAGEX_LAUNCHER_GAMES_PATH/HDOS.exe"

# Make sure the registry has the installation location for runelite.
WINEDEBUG="-all" umu-run reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall\RuneLite Launcher_is1" /v "InstallLocation" /t REG_SZ /d "C:\Program Files (x86)\Jagex Launcher\Games" /f

# Make sure the registry has the installation location for hdos
WINEDEBUG="-all" umu-run reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall\HDOS Launcher_is1" /v "InstallLocation" /t REG_SZ /d "C:\Program Files (x86)\Jagex Launcher\Games" /f

umu-run "$JAGEX_LAUNCHER_EXE_PATH"
