```
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak-builder --install-deps-from=flathub --user --install --force-clean build-dir --disable-cache com.jagex.JagexLauncher.yml && flatpak run com.jagex.JagexLauncher
flatpak run com.jagex.JagexLauncher
```
