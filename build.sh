#!/bin/bash
cd icons
./extract_icons.sh
cd ..

flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak-builder --repo ./repo --gpg-sign=787C55D80BC4CB5BB385FC67B9D5939A8F40EB05 --user --install --force-clean build-dir --disable-cache "$(basename $(git rev-parse --show-toplevel)).yml"