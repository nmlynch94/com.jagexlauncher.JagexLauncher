#!/bin/bash
FREEDESKTOP_VERSION="23.08"

flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --user --if-not-exists JLauncher https://nmlynch94.github.io/com.jagexlauncher.JagexLauncher/JagexLauncher.flatpakrepo

# https://github.com/flatpak/flatpak/issues/3094
flatpak install --user -y --noninteractive flathub \
    org.freedesktop.Platform//${FREEDESKTOP_VERSION} \
    org.freedesktop.Platform.Compat.i386/x86_64/${FREEDESKTOP_VERSION} \
    org.freedesktop.Platform.GL32.default/x86_64/${FREEDESKTOP_VERSION}

flatpak install -y --user --noninteractive JLauncher com.jagexlauncher.JagexLauncher
