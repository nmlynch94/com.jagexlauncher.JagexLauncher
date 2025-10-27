#!/bin/bash
FREEDESKTOP_VERSION="24.08"

set -e

HAS_NVIDIA=0
if [[ -f /proc/driver/nvidia/version ]]; then
    HAS_NVIDIA=1
    NVIDIA_VERSION=$(cat /proc/driver/nvidia/version | grep "NVRM version" | grep -oE '[0-9]{3,4}\.[0-9]{1,4}[\.0-9]+\s' | sed 's/\./-/g' | sed 's/ //g')
fi

flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --user --if-not-exists JLauncher https://nmlynch94.github.io/com.jagexlauncher.JagexLauncher/JagexLauncher.flatpakrepo

# https://github.com/flatpak/flatpak/issues/3094
flatpak install --user -y --noninteractive flathub \
    org.freedesktop.Platform//${FREEDESKTOP_VERSION} \
    org.freedesktop.Platform.Compat.i386/x86_64/${FREEDESKTOP_VERSION} \
    org.freedesktop.Platform.GL32.default/x86_64/${FREEDESKTOP_VERSION}

if [[ ${HAS_NVIDIA} -eq 1 ]]; then
    flatpak install --user -y --noninteractive flathub \
        org.freedesktop.Platform.GL.nvidia-${NVIDIA_VERSION}/x86_64 \
        org.freedesktop.Platform.GL32.nvidia-${NVIDIA_VERSION}/x86_64
fi

flatpak install -y --user --noninteractive JLauncher com.jagexlauncher.JagexLauncher

# Perform first time setup
flatpak run com.jagexlauncher.JagexLauncher
echo "DONE. You should now be able to launch from your application menu"
