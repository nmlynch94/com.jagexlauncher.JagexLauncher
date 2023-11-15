```
# Only use this next command if it has already been installed and you want to run from scratch
flatpak remove --delete-data com.jagex.JagexLauncher

# Use these to build and run
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak-builder --install-deps-from=flathub --user --install --force-clean build-dir --disable-cache com.jagex.JagexLauncher.yml
flatpak run com.jagex.JagexLauncher
```
