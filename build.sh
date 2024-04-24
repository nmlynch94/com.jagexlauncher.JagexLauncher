#!/bin/bash
cd icons
./extract_icons.sh
cd ..

flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak-builder --repo=out --default-branch=stable --gpg-sign=FFB01AD591778A1B0321C2E6C38BBBC648E22A4B --require-changes --rebuild-on-sdk-change --install --install-deps-from=flathub --user --ccache --force-clean build-dir com.jagexlauncher.JagexLauncher.yml
flatpak build-update-repo --gpg-sign=FFB01AD591778A1B0321C2E6C38BBBC648E22A4B out --title="Jagex Launcher" --generate-static-deltas --default-branch=stable --prune
