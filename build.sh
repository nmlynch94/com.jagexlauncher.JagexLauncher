#!/bin/bash
set -euo pipefail

cd icons
./extract_icons.sh
cd ..

flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak-builder --install-deps-from=flathub --user --install --force-clean build-dir --disable-cache "$(basename $(git rev-parse --show-toplevel)).yml"
